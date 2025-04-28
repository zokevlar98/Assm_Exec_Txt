#!/usr/bin/env python3

import os
import sys
import shutil
import zipfile
import py7zr
import oletools.olevba as olevba

ALLOWED_EXTENSIONS = {'.exe', '.doc', '.xls', '.pdf', '.docm', '.xlsm'}
SPECIAL_MACRO_EXTENSIONS = {'.doc', '.xls', '.docm', '.xlsm'}

def extract_archives(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            filepath = os.path.join(root, file)
            if file.endswith('.zip'):
                try:
                    with zipfile.ZipFile(filepath, 'r') as zip_ref:
                        extract_path = os.path.splitext(filepath)[0]
                        os.makedirs(extract_path, exist_ok=True)
                        zip_ref.extractall(extract_path)
                        print(f"Extracted zip: {filepath}")
                except Exception as e:
                    print(f"Failed to extract {filepath}: {e}")
            elif file.endswith('.7z'):
                try:
                    with py7zr.SevenZipFile(filepath, mode='r') as archive:
                        extract_path = os.path.splitext(filepath)[0]
                        os.makedirs(extract_path, exist_ok=True)
                        archive.extractall(path=extract_path)
                        print(f"Extracted 7z: {filepath}")
                except Exception as e:
                    print(f"Failed to extract {filepath}: {e}")

def remove_unwanted_files(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if not any(file.lower().endswith(ext) for ext in ALLOWED_EXTENSIONS):
                filepath = os.path.join(root, file)
                print(f"Skipping and deleting: {filepath}")
                try:
                    os.remove(filepath)
                except Exception as e:
                    print(f"Error deleting {filepath}: {e}")

def extract_macros(directory, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    for root, _, files in os.walk(directory):
        for file in files:
            if any(file.lower().endswith(ext) for ext in SPECIAL_MACRO_EXTENSIONS):
                filepath = os.path.join(root, file)
                print(f"Extracting macros from: {filepath}")
                try:
                    vbaparser = olevba.VBA_Parser(filepath)
                    if vbaparser.detect_vba_macros():
                        for (filename, stream_path, vba_filename, vba_code) in vbaparser.extract_macros():
                            macro_filename = os.path.join(output_dir, f"{os.path.basename(filepath)}_{vba_filename}")
                            with open(macro_filename, 'w') as macro_file:
                                macro_file.write(vba_code)
                                print(f"Saved macro: {macro_filename}")
                    vbaparser.close()
                except Exception as e:
                    print(f"Error extracting macros from {filepath}: {e}")

def main():
    if len(sys.argv) != 3:
        print("Usage: prepare_batch.py <malware_directory> <output_macro_directory>")
        sys.exit(1)

    input_directory = sys.argv[1]
    output_macro_directory = sys.argv[2]

    extract_archives(input_directory)
    remove_unwanted_files(input_directory)
    extract_macros(input_directory, output_macro_directory)

if __name__ == "__main__":
    main()
