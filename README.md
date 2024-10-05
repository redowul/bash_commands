# Bash Script Repository

This repository contains a collection of utility scripts written in Bash, designed to automate and simplify several tasks. Here are the scripts included in this repo:

## 1. commit_generator.sh

This script is used to generate git commits with weighted randomness. It also considers holidays and weekends, with lesser commit activity during summer months. It uses a local git repository to commit text files with timestamps.

Please be aware, this script permanently alters your repository's history. Be sure to backup your repository before running it.

## 2. deckfinder.sh

This script is designed to find a Steam Deck device on the local network and initiate an SSH connection to it. It uses nmap to scan the local network for a host with the specified name. If it fails to connect, it will rescan the network and try again.

## 3. django_aliases

This file is not a script, but rather a set of shorthand aliases for common Django management commands. The aliases are designed to be sourced in a bashrc or similar file, and used from the command line. The aliases allow you to specify the Python version to use, and provide shorthands for the `runserver`, `makemigrations`, and `migrate` commands.

# Usage

For the bash scripts, make them executable using the chmod command:

```bash
chmod +x commit_generator.sh deckfinder.sh
```

Then, you can run them directly:

```
./commit_generator.sh
./deckfinder.sh
```

For the Django aliases, add the following line to your `.bashrc` or `.bash_profile` file:
```
source /path/to/repo/django_aliases
```

Then, you can use the dj command directly from your terminal:
```
dj 3.8 r  # This will run 'python3.8 manage.py runserver'
dj 3.8 m1  # This will run 'python3.8 manage.py makemigrations'
dj 3.8 m2  # This will run 'python3.8 manage.py migrate'
```

Remember to replace `/path/to/repo` with the actual path to the `django_aliases` file.

#Contributions

Feel free to contribute to this repository by creating a pull request. Please provide a description of what your script does, and how to use it.

# gcompile Function for Simplified C++ Compilation

This README provides instructions on using the gcompile function to simplify compiling C++ programs with additional arguments such as linking libraries.

## Compiling for Execution

The gcompile function simplifies the process of compiling C++ programs. It supports specifying the input file, an optional output file, and additional arguments such as linking libraries.

### gcompile

- Compile with Default Output Name:

  `gcompile <input_file>`

  This compiles the <input_file> and creates an executable with the same name (without the extension).

  **Example:**

  `gcompile inputs.cpp`

  **Output:**

  `inputs`  *# Executable created*

---

- Compile with Specified Output Name:

  `gcompile <input_file> <output_file>`

  This compiles the <input_file> and creates an executable with the specified <output_file> name.

  **Example:**

  `gcompile inputs.cpp mynewoutput`

  **Output:**

  `mynewoutput`  *# Executable created*

---

- Compile with Additional Arguments:

  `gcompile <input_file> [output_file] [additional_args]`

  This compiles the <input_file>, optionally specifies the <output_file>, and includes any additional arguments such as linking libraries.

  **Example 1:**

  `gcompile inputs.cpp -lncurses`

  **Output 1:**

  `inputs`  *# Executable created with ncurses linked*

  **Example 2:**

  `gcompile inputs.cpp mynewoutput -lncurses`

  **Output 2:**

  `mynewoutput`  *# Executable created with ncurses linked*

## Running the Executable

### grun

The grun function simplifies running the compiled executable.

- Run the Executable:

  `grun <executable_file>`

  This runs the specified executable file.

  **Example:**

  `grun inputs`

  **Output:**

  The program output will be displayed in the terminal.

### Compiling for Windows

- Compile for Windows with Default Output Name

  `gexe <input_file>`

  This compiles the <input_file> and creates a Windows executable with the same name (without the extension).

  **Example:**

  `gexe inputs.cpp`

  **Output:**

  `inputs.exe`  *# Executable created for Windows*

- Compile for Windows with Specified Output Name:

  `gexe <input_file> <output_file>`

  This compiles the `<input_file>` and creates an executable with the specified `<output_file>` name.

  **Example:**

  `gexe inputs.cpp mynewoutput.exe`

  **Output:**

  `mynewoutput.exe`  *# Executable created for Windows*

- Compile for Windows with Additional Arguments:

  `gexe <input_file> [output_file] [additional_args]`

  This compiles the `<input_file>`, optionally specifies the `<output_file>`, and includes any additional arguments such as linking Windows-specific libraries.

  **Example:**

  `gexe inputs.cpp mynewoutput.exe -static-libgcc -static-libstdc++`

  **Output:**

  `mynewoutput.exe` *# Executable created with static libraries linked*

Additional Information

- Arguments Handling: The gcompile function checks the number of arguments and processes them accordingly. It identifies whether an output file name is provided or if additional arguments (such as linking flags) are present.
- Debugging Information: The -g flag is included by default to add debugging information to the executable.

By following these instructions, you can streamline the process of compiling C++ programs with custom configurations using the gcompile function and easily run them using the grun function.
