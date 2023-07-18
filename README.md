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
