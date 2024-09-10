function gcompile() {
    if [ $# -lt 1 ]; then
        echo "Usage: gcompile <input_file> [output_file] [additional_args]"
        return 1
    fi

    input_file=$1
    shift

    # Check if the next argument is not an option (does not start with a dash)
    if [ $# -gt 0 ] && [[ $1 != -* ]]; then
        output_file=$1
        shift
    else
        output_file="${input_file%.*}"
    fi

    g++ -g "$input_file" -o "$output_file" "$@"
}


function grun() {
    if [ $# -ne 1 ]; then
        echo "Usage: grun <executable_file>"
    else
        ./"$1"
    fi
}

function gexe() {
    if [ $# -lt 2 ]; then
        echo "Usage: .gexe <file1> <file2> [additional_args]"
        echo "Specify both a .cpp input file and an .exe output file in any order."
        return 1
    fi

    # Initialize variables for input and output files
    input_file=""
    output_file=""

    # Iterate through the first two arguments to determine the input and output files
    for arg in "$1" "$2"; do
        if [[ "$arg" == *.cpp ]]; then
            input_file="$arg"
        elif [[ "$arg" == *.exe ]]; then
            output_file="$arg"
        fi
    done

    # Check if both input and output files are identified correctly
    if [ -z "$input_file" ] || [ -z "$output_file" ]; then
        echo "Error: You must specify a .cpp input file and an .exe output file."
        return 1
    fi

    # Shift past the first two arguments
    shift 2

    # Compile using x86_64-w64-mingw32-g++ with any additional arguments
    x86_64-w64-mingw32-g++ -o "$output_file" "$input_file" -lmingw32 "$@"

    # Check if the compilation was successful
    if [ $? -eq 0 ]; then
        echo "Compilation successful: $output_file created."
    else
        echo "Compilation failed."
    fi
}

