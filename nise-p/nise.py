import pickle

def parse(line: str):
    parsed_line = {}

    # Grab opcode
    line_split_from_opcode = line.split(";")
    opcode = line_split_from_opcode.pop(0)

    parsed_line["opcode"] = opcode

    # Gotta trim the whitespace
    arguments_untrimmed = line_split_from_opcode

    arguments = []
    for arg in arguments_untrimmed:
        arguments.append(arg.strip())

    # Cries in not bothering to do this properly again
    match opcode:
        case "apples":
            print("aple")
            pass
        case _:
            print("Oh no!")
            pass

    print(parsed_line)

    return parsed_line



def parse_lines(old_list: list):
    new_list = []

    for line in old_list:
        new_list.append(parse(line))

    return new_list