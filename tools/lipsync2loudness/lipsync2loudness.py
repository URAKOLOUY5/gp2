import librosa
import numpy as np

def compute_loudness(file_path):
    # Load the audio file
    y, sr = librosa.load(file_path, sr=None)
    
    # Define the length of one second in samples
    hop_length = sr // 4
    
    # Compute the RMS (root-mean-square) energy
    rms = librosa.feature.rms(y=y, frame_length=hop_length, hop_length=hop_length, center=True)
    
    # Take the mean RMS for each second (these will be segments of the full track)
    rms = rms.squeeze()
    
    # Normalize the RMS values to the range [0, 1]
    rms_normalized = rms / np.max(rms) if np.max(rms) != 0 else rms

    # Convert to the format of a Lua table
    lua_table = '{' + ', '.join(f'{value:.3f}' for value in rms_normalized) + '}'
    
    return lua_table

# Example usage
file_path = 'potatos_a3_wakeupb03.wav'
lua_loudness_table = compute_loudness(file_path)
print(lua_loudness_table)