#!/bin/bash

# Source the .bash_functions file to use the gexe function
source ~/.bash_functions

# Source the config.env file to use the environment variables
source ./build/config.env

# Get the current WSL2 username dynamically
current_user=$(whoami)

# Define the source directory where all .cpp files are located
src_directory="$SRC_DIRECTORY"  # e.g., "./code/src"

# Define the output executable filename
output_file="$OUTPUT_FILE_WINDOWS"  # e.g., "Program.exe"

# Define the base path to SDL2 using the current user
sdl_base_path="./build/x86_64-w64-mingw32"

# Define the directory where object files and executables will be stored
artifacts_directory="./build/artifacts"

# Create the artifacts directory if it doesn't exist
mkdir -p "$artifacts_directory"

# Create a list of object files that will be linked
object_files=""

# Define the entry point file
entrypoint_file="$ENTRYPOINT"

echo "Entry point file: $entrypoint_file"

# Check if the entry point file exists
if [[ ! -f "$entrypoint_file" ]]; then
    echo "Error: Entry point file not found: $entrypoint_file"
    exit 1
fi

# Initialize an array to store all source files found, starting with the entry point
all_source_files="$entrypoint_file"

# Function to find headers and corresponding source files
find_sources() {
    local file=$1
    echo "Scanning #include headers in $file..."
    
    # Scan the #include headers and clean up any comments or extra text
    local includes=$(grep -E '^#include\s*".*"' "$file" | sed -E 's/#include "(.*)".*/\1/' | grep -E '^./')

    # Display the found include headers
    echo "Found headers in $file:"
    echo "$includes"

    # Loop through each header to find corresponding source files
    for header in $includes; do
        # Replace /include/ with /src/ in the path and add the base path to locate the corresponding .cpp file
        local cpp_file=$(echo "$header" | sed 's|^\./include|src|; s|\.h$|.cpp|')
        local full_cpp_path="$src_directory/$cpp_file"  # Correctly concatenate the base path

        # If the corresponding .cpp file exists and hasn't been processed, add it to the list
        if [[ -f "$full_cpp_path" && ! "$all_source_files" =~ "$full_cpp_path" ]]; then
            echo "Found corresponding source file: $full_cpp_path"
            all_source_files="$all_source_files $full_cpp_path"
        else
            echo "No corresponding .cpp file found for header: $header"
        fi
    done
}

# Start the process by finding sources from the entry point file
find_sources "$entrypoint_file"

# Process each found source file, checking for additional dependencies
while :; do
    new_files=""

    # Loop over each source file to check for additional includes
    for file in $all_source_files; do
        # Check if the file has already been processed
        if [[ ! "$processed_files" =~ "$file" ]]; then
            processed_files="$processed_files $file"
            find_sources "$file"
            new_files="$new_files $file"
        fi
    done

    # Break the loop if no new files are found
    if [[ -z "$new_files" ]]; then
        break
    fi
done

# Display the final list of source files to compile
echo "Final list of source files to compile:"
echo "$all_source_files"

# Compile the list of source files to .o files in the artifacts directory
for file in $all_source_files; do
    # Extract the object file name by replacing .cpp with .o and placing it in the artifacts directory
    obj_file="$artifacts_directory/$(basename "${file%.cpp}.o")"

    # Check if the object file needs to be recompiled
    if [[ ! -f "$obj_file" || "$file" -nt "$obj_file" ]]; then
        echo "Compiling $file to $obj_file..."
        x86_64-w64-mingw32-g++ -c "$file" -o "$obj_file" \
        -I"$sdl_base_path/include"

        # Check if compilation was successful
        if [ $? -ne 0 ]; then
            echo "Compilation of $file failed. Exiting script."
            exit 1
        fi
    else
        echo "$file is up-to-date."
    fi

    # Add the object file to the list of object files to link
    object_files="$object_files $obj_file"
done

# Link all object files into the final executable
echo "Linking object files to create $output_file..."
x86_64-w64-mingw32-g++ $object_files -o "$artifacts_directory/$output_file" \
-L"$sdl_base_path/lib" \
-lmingw32 -lSDL2main -lSDL2 -mwindows

# Check if linking was successful
if [ $? -ne 0 ]; then
    echo "Linking failed. Exiting script."
    exit 1
fi 

# Verify that the output file exists and is not empty
if [ ! -s "$artifacts_directory/$output_file" ]; then
    echo "Compilation output file $output_file is missing or empty. Exiting script."
    exit 1
fi

# Define the target directory to move the executable
target_directory=$TARGET_DIRECTORY_WINDOWS

# Move the generated executable to the target directory
mv "$artifacts_directory/$output_file" "$target_directory"

# Check if the move was successful
if [ $? -eq 0 ]; then
    echo "Successfully moved $output_file to $target_directory"
else
    echo "Failed to move $output_file to $target_directory"
    exit 1
fi

# Check if the -execute flag was passed
if [[ "$1" == "-execute" ]]; then
    echo "Executing the program in PowerShell..."

    # Convert the path to the Windows format
    win_path=$(wslpath -w "$target_directory/$output_file")

    # Use PowerShell to execute the .exe file without opening an interactive PowerShell session
    powershell.exe -NoProfile -NonInteractive -Command "Start-Process '$win_path'"

    # Alternatively, for PowerShell Core, use:
    # pwsh.exe -NoProfile -NonInteractive -Command "Start-Process '$win_path'"

    # Check if execution was successful
    if [ $? -ne 0 ]; then
        echo "Failed to execute $output_file in PowerShell."
        exit 1
    fi
fi
