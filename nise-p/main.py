import sys

import nise


def main():
    if sys.argv.__len__ == 1:
        print("Ouchies! You didn't include a filepath!")
        return

    file = open(sys.argv[1], "r")

    # Generally `input/FILENAME.txt`, grabs FILENAME
    file_name = file.name.split("/", 1)[1].split(".")[0]
    file_lines = trim_list(file.readlines())

    print(file_lines)

    nise.parse_lines(file_lines)

    return


def trim_list(old_list: list):
    new_list = []

    for line in old_list:
        new_list.append(line.split("\n")[0])

    return new_list


if __name__ == "__main__":
    main()