import argparse
import json


class Objects:
    ppu_register = 0x0200
    current_indent = "  "

    template_load_tile = '{0:s}LDA #${1:02X}\n{0:s}STA ${2:04X}'

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
    parser.add_argument('-o', "--output-file",
                        type=str,
                        help='The ASM6 file to be created',
                        default='output.asm')

    args = parser.parse_args()

    return (args.input_file,
            args.output_file)


if __name__ == '__main__':
    input_file, output_file = parse_args()

    try:
        json_file = open(input_file, 'r')
    except FileNotFoundError:
        exit('ERROR: File not found: ' + input_file)

    json_data = json.load(json_file)
    json_file.close()

    if 'objects' not in json_data:
        exit('ERROR: No \"objects\" found in file: ' + input_file)

    for object in json_data['objects']:
        if 'name' in object:
            name = object['name']
        else:
            exit('ERROR: An object is missing \"name\"')

        if 'x_position' in object:
            x_position = object['x_position']
        else:
            exit('ERROR: ' + name + ' is missing \"x_position\"')

        if 'y_position' in object:
            y_position = object['y_position']
        else:
            exit('ERROR: ' + name + ' is missing \"y_position\"')

        if 'tiles' in object:
            tiles = object['tiles']
        else:
            exit('ERROR: ' + name + ' is missing \"tiles\"')

        print('load' + name + ':')

        objects = Objects()

        for tile in tiles:
            chr_address = int(tile['address'], 0)
            attributes = int(tile['attributes'], 0)
            objects.load_tile(chr_address, attributes, x_position + tile['x_offset'], y_position + tile['y_offset'])

        print('  RTS\n')
