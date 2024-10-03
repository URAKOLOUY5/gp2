import tkinter as tk
from tkinterdnd2 import DND_FILES, TkinterDnD
import re

def process_file(file_path):
    # Read the file
    with open(file_path, 'r') as file:
        content = file.read()

    # Regular expression to find `if-else` blocks
    pattern = re.compile(r'if\s+(.*?)\s*\{(.*?)\}(?:\s*else\s*\{(.*?)\})?', re.DOTALL)

    # Replacement function
    def replace_block(match):
        condition = match.group(1).strip()
        if_body = match.group(2).strip()
        else_body = match.group(3).strip() if match.group(3) else None

        # Construct the new block
        new_block = f"if {condition} then\n  {if_body}\nend"
        if else_body:
            new_block += f" else\n  {else_body}\nend"

        return new_block

    # Perform replacement
    replaced_content = re.sub(pattern, replace_block, content)

    # Write the results back to the same file
    with open(file_path, 'w') as file:
        file.write(replaced_content)

    print(f"Replacement completed in the file {file_path}")

def drop(event):
    # Get the file path from the drop event
    file_path = event.data
    # Remove curly braces if present (common for some systems/paths)
    process_file(file_path.lstrip('{').rstrip('}'))

# Create the main window
root = TkinterDnD.Tk()
root.title("Drag and Drop File Processor")
root.geometry("500x300")

# Instruction label
label = tk.Label(root, text="Drag and drop your file here to process", pady=20)
label.pack()

# Make the window a drop target for files
root.drop_target_register(DND_FILES)
root.dnd_bind('<<Drop>>', drop)

root.mainloop()
