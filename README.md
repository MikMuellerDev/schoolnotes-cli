```
 ___     _             _ _  _     _
/ __| __| |_  ___  ___| | \| |___| |_ ___ ___
\__ \/ _| ' \/ _ \/ _ \ | . / _ \  _/ -_|_--<
|___/\__|_||_\___/\___/_|_|\_\___/\__\___/__/
```

# Schoolnotes-Cli
Schoolnotes-Cli is a bash script which intents to make using $\LaTeX$ easier and more user-friendly.

### Features

| Feature                                                                                  | CLI command                                                                  |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Creating a new notebook in the current directory                                         | `-i or --init [template]`                                                    |
| Creating a new notebook with a custom name in a new directory                            | `-i or --init [name] [template]` optional: `-o or --open` to edit right away |
| Removing temporary files from the current directory                                      | `-c or --clean`                                                              |
| Compiling the `main.tex` entry-point to a `.pdf` file                                    | `-b or --build`                                                              |
| Watching for filechanges and compiling if they are any                                   | `-w or --watch`                                                              |
| Viewing the `main.pdf`                                                                   | `-v or --view`                                                               |
| Updating SchoolNotes to the current version                                              | `-u or --update`                                                             |
| Editing in the current directory                                                         | `-e or --edit`                                                               |
| Automatically renaming `main.pdf` like the current notebook, including the author's name | `-r or --rename`                                                             |
| Editing in the `~/SchoolNotes` directory                                                 | `schoolnotes`    (no arguments)                                              |




### Templates
- **normal**, used in everyday life
- **math**, used for creating mathematical handouts
- **it**, used in computer class
- **complex**, used to create larger papers and complex assignments


### Dependencies
- A working lualatex configuration, like `texlive-full`
- `VSCode` for editing
- [Optional] `Okular` vor viewing
- `sed` (should be installed already)
- `curl / wget` (should be installed already)

## Installation

```
wget https://raw.githubusercontent.com/MikMuellerDev/schoolnotes-cli/main/install.sh && sudo bash install.sh i && rm install.sh
```
```
curl -fsSl https://raw.githubusercontent.com/MikMuellerDev/schoolnotes-cli/main/install.sh > install.sh  && sudo bash install.sh i && rm install.sh
```

## Removal
```
wget https://raw.githubusercontent.com/MikMuellerDev/schoolnotes-cli/main/install.sh && sudo bash install.sh r && rm install.sh
```
```
curl -fsSl https://raw.githubusercontent.com/MikMuellerDev/schoolnotes-cli/main/install.sh > install.sh  && sudo bash install.sh r && rm install.sh
```