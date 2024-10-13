import os.path
import sys

import librosa
import numpy as np
from PyQt6.QtCore import QThread, pyqtSignal
from PyQt6.QtGui import QWindow

from PyQt6.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QFileDialog, QMessageBox, QWidget

import matplotlib
from matplotlib.pyplot import margins, tight_layout, subplots_adjust, figure

from lipsync2loudness import file_path
from ui_loading import Ui_Loading

matplotlib.use('QtAgg')

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure

import ui_main
import ui_loading

MARKER_FRACTION = 16

class ExportThread(QThread):
    progress_changed = pyqtSignal(int, str)
    export_finished = pyqtSignal(int)
    window = None

    def __init__(self, window, starting_directory):
        super().__init__()
        self.starting_directory = starting_directory
        self.window = window

    def run(self):
        audio_extensions = ('.mp3', '.wav', '.ogg')
        count = 0
        total_files = 0

        for root, dirs, files in os.walk(self.starting_directory):
            total_files += sum(
                1 for file in files
                if file.lower().endswith(audio_extensions) and not os.path.basename(file).startswith('_lipsync_')
            )

        for root, dirs, files in os.walk(self.starting_directory):
            for file in files:
                if file.lower().endswith(audio_extensions):
                    sound_file_path = os.path.join(root, file)

                    if os.path.basename(file).startswith('_lipsync_'):
                        continue

                    self.window.file_name = sound_file_path
                    try:
                        self.window.load_via_librosa(sound_file_path)
                    except:
                        continue
                    self.window.export_markers(show_message=False)
                    count += 1
                    # Emit the progress
                    self.progress_changed.emit(int((count / total_files) * 100), sound_file_path)

        self.export_finished.emit(count)


class ProgressWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.ui = Ui_Loading()
        self.ui.setupUi(self)
        self.show()

    def update_progress(self, value, file):
        self.ui.progressBar.setValue(value)
        self.ui.file_name.setText(file)

    def update_finished(self, count):
        self.ui.progressBar.setValue(100)


class L2L(QMainWindow):
    def __init__(self):
        super().__init__()
        self.rms_normalized = None
        self.rms = None
        self.sr = None
        self.y = None
        self.figure = Figure()

        self.figure.clear()
        self.figure.set_facecolor("black")

        self.canvas = FigureCanvas(self.figure)

        self.ui = ui_main.Ui_MainWindow()
        self.ui.setupUi(self)

        self.ui.actionOpen.triggered.connect(self.showFileDialog)

        # Create a layout for the waveform widget
        self.layout = QVBoxLayout(self.ui.waveform)
        self.layout.addWidget(self.canvas)

        self.ui.exportBtn.setDisabled(True)
        self.ui.exportBtn.pressed.connect(self.export_markers)
        self.ui.actionExport_markers.setDisabled(True)
        self.ui.actionExport_markers.triggered.connect(self.export_markers)
        self.ui.actionClose.setDisabled(True)
        self.ui.actionClose.triggered.connect(lambda: self.load_waveform_from_file())
        self.ui.actionBulk_export.triggered.connect(self.bulk_export)

        self.setWindowTitle('Lipsync To Markers')
        self.file_name = None

    def showFileDialog(self):
        # Set file dialog options
        file_name, _ = QFileDialog.getOpenFileName(
            self,
            "Open File",
            ".",
            "Audio Files (*.mp3 *.wav *.ogg)",
        )

        if not file_name:
            return

        self.file_name = file_name
        self.load_waveform_from_file(file_name)

    def show_message(self, title, message):
        msg_box = QMessageBox(self)
        msg_box.setWindowTitle(title)
        msg_box.setText(message)
        msg_box.setIcon(QMessageBox.Icon.Information)
        msg_box.setStandardButtons(QMessageBox.StandardButton.Ok)
        msg_box.exec()

    def load_waveform_from_file(self, file_path=''):
        file_name = os.path.basename(file_path)

        # Clear the previous plot
        self.ui.code.setText('')
        self.figure.clear()
        self.figure.set_facecolor("black")

        self.ui.exportBtn.setDisabled(True)
        self.ui.actionExport_markers.setDisabled(True)
        self.ui.actionClose.setDisabled(True)

        if not os.path.exists(file_path):
            self.file_name = None
            self.canvas.draw()
            return

        self.ui.exportBtn.setDisabled(False)
        self.ui.actionExport_markers.setDisabled(False)
        self.ui.actionClose.setDisabled(False)

        try:
            self.load_via_librosa(file_path)
        except:
            self.file_name = None
            self.canvas.draw()
            return

        # Add new plot
        ax = self.figure.add_subplot(111, facecolor='black')
        ax.spines['top'].set_visible(False)
        ax.spines['right'].set_visible(False)
        ax.spines['bottom'].set_visible(False)
        ax.spines['left'].set_visible(False)
        ax.plot(np.linspace(0, len(self.y) / self.sr, num=len(self.y)), self.y, color='tab:gray')

        ax.set_yticklabels([])
        ax.yaxis.set_tick_params(width=0)
        ax.tick_params(axis='x', colors='white')

        ax.fill_between(np.linspace(0, len(self.y) / self.sr, num=len(self.y)), self.y, color='tab:gray')

        self.figure.tight_layout()

        marker_positions = (np.arange(len(self.rms)) * (self.hop_length / self.sr))

        # Set the vertical lines for loudness markers
        for pos in marker_positions:
            ax.axvline(x=pos, color='red', linestyle='-', linewidth=1, )

        ax.axhline(y=0, color='#000000', linestyle='-', linewidth=1, )

        # Convert to the format of a Lua table
        markers = [f'{value:.3f}' for value in self.rms_normalized]
        self.ui.code.setText(f"<div style='font-size: 16px'><div>Sound path: {os.path.abspath(file_path)}</div><div>Sound lipsync markers: {len(markers)}</div></div>")

        # Draw canvas
        self.canvas.draw()

    def export_markers(self, show_message = True):
        lua_table = 'return {' + ', '.join(f'{value:.3f}' for value in self.rms_normalized) + '}'

        directory = os.path.abspath(self.file_name).replace("\\", '/')
        directory = os.path.dirname(directory)
        filename = os.path.basename(self.file_name)

        lipsync_path = f'{directory}/_lipsync_{filename}'

        with open(lipsync_path, 'w') as f:
            f.write(lua_table)

        if show_message:
            self.show_message('Done!', lipsync_path)

    def load_via_librosa(self, file_path):
        self.y, self.sr = librosa.load(file_path, sr=None)

        # Get loudness
        self.hop_length = self.sr // MARKER_FRACTION
        self.rms = librosa.feature.rms(y=self.y, frame_length=self.hop_length, hop_length=self.hop_length, center=True)

        # Take the mean RMS for each second (these will be segments of the full track)
        self.rms = self.rms.squeeze()

        # Normalize the RMS values to the range [0, 1]
        self.rms_normalized = self.rms / np.max(self.rms) if np.max(self.rms) != 0 else self.rms

    def bulk_export(self):
        starting_directory = QFileDialog.getExistingDirectory(self, "Select Directory with Audio Files")
        if not starting_directory:
            return

        self.export_window = ProgressWindow()
        self.export_thread = ExportThread(self, starting_directory)
        self.export_thread.progress_changed.connect(self.export_window.update_progress)
        self.export_thread.export_finished.connect(self.export_window.update_finished)
        self.export_thread.start()

        self.export_window.destroyed.connect(self.export_thread.terminate)


if __name__ == "__main__":
    os.putenv("QT_QPA_PLATFORM", "windows:darkmode=2")
    app: QApplication = QApplication(sys.argv)
    app.setStyle('windows')

    app.setStyleSheet("""
QMainWindow {
    background-color: #363636;
}    

QPushButton {
    border: 1px solid #606060;
    background-color: #404040;
    border-radius: 2px;
    min-width: 80px;
    padding: 0;
}

QPushButton:hover {
    background-color: #555e71;
}

QPushButton:pressed {
    margin: 2px;
}

QPushButton:flat {
    border: none; /* no border for a flat push button */
}

QPushButton:default {
    border-color: navy; /* make the default button prominent */
}

QMenuBar {
    background-color: qlineargradient(spread:pad, x1:1, y1:0, x2:1, y2:1, stop:0 rgba(70, 70, 70, 255), stop:1 rgba(31, 31, 31, 255)); /* sets background of the menu */
    border-bottom: 2px solid #2a2a2a;
    padding: 3px;
    color: #b6b6b7;
}

QMenu {
    background-color: #2e2e2e;
}

QMenu::item {
    /* sets background of menu item. set this to something non-transparent
        if you want menu color and menu item color to be different */
    background-color: transparent;
}

QMenu::item:selected { /* when user selects item using mouse or keyboard */
    background-color: #4f5259;
    color: white;
}

QProgressBar {
    border: 2px solid #606060;
}

QProgressBar::chunk {
    background-color: #4f5259;
    width: 14px;
    margin: 1px;
    margin-right: 2px;
}
    """)

    window = L2L()
    window.show()

    sys.exit(app.exec())