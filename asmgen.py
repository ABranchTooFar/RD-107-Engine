import argparse
import json
from jsonschema import validate, ValidationError


class Objects:
    ppu_register = 0x0200
    current_indent = "  "

    template_load_tile = '{0:s}LDA #${1:02X}\n{0:s}STA ${2:04X}, x\n'

    def load_tile(self, chr_address, attributes, x_position, y_position):
        print(self.template_load_tile.format(self.current_indent, y_position, self.ppu_register))
        self.ppu_register += 1
        print('  ; Tile address in PPU memory')
        print(self.template_load_tile.format(self.current_indent, chr_address, self.ppu_register))
        self.ppu_register += 1
        print('  ; Attributes')
        print(self.template_load_tile.format(self.current_indent, attributes, self.ppu_register))
        self.ppu_register += 1
        print('  ; Horizontal position')
        print(self.template_load_tile.format(self.current_indent, x_position, self.ppu_register))
        self.ppu_register += 1


def parse_args():
    parser = argparse.ArgumentParser(description='Does the tedious job of generating assemply for objects')
    parser.add_argument('-i', '--input-file',
                        type=str,
                        help='The JSON file describing the objects',
                        default='gamedata.json')

    args = parser.parse_args()

    return args.input_file


if __name__ == '__main__':
    input_file = parse_args()

    try:
        json_file = open(input_file, 'r')
    except FileNotFoundError:
        exit('ERROR: File not found: ' + input_file)

    try:
        json_schema_file = open('schema.json', 'r')
    except FileNotFoundError:
        exit('ERROR: File not found: schema.json')

    json_data = json.load(json_file)
    json_file.close()

    json_schema = json.load(json_schema_file)
    json_schema_file.close()

    try:
        validate(json_data, json_schema)
    except ValidationError as error:
        exit(error)

    for obj in json_data['objects']:
        print('load' + obj['name'] + ':')

        objects = Objects()

        for tile in obj['tiles']:
            objects.load_tile(int(tile['address'], 0),
                              int(tile['attributes'], 0),
                              obj['x_position'] + tile['x_offset'],
                              obj['y_position'] + tile['y_offset'])

        print('  RTS\n')
