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
        case "text": # { speaker: { speaker, color }, text }
            color_array = []
            for color_piece in arguments[1].split(" "):
                color_array.append(float(color_piece))

            speaker_data = {}
            speaker_data["speaker"] = arguments[0]
            speaker_data["color"] = color_array

            parsed_line["speaker_data"] = speaker_data
            parsed_line["text"] = arguments[2]

        case "input": # { }
            pass
            
        case "ask": # { text, choices: [[text, jump], [text, jump]]}
            pass
        case "wait": # { time }
            parsed_line["time"] = float(arguments[0])
        
        case "background": # { file_name }
            pass
        case "sprite": # { file_name, character, location }
            parsed_line["character"] = arguments[0]
            parsed_line["file_name"] = arguments[1]
            parsed_line["location"] = arguments[2]

        case "active_sprite": # { location }
            parsed_line["location"] = arguments[0]
        
        case "move_sprite": # { name, location, time, method }
            pass
        case "animation": # { name }
            pass
        case "music": # { name }
            pass
        case "sound_effect": # { name }
            pass
        case "jump": # { type, amount }
            pass
        case "set_flag": # { name, value }
            pass
        case "if": # { flag, value, jump_true, jump_false }
            pass
        case "script": # { name }
            pass
        case "event":

            print("aple")
            pass
        case _:
            print("Oh no!")
            pass

    return parsed_line



def parse_lines(old_list: list):
    new_list = []

    for line in old_list:
        new_list.append(parse(line))

    return new_list