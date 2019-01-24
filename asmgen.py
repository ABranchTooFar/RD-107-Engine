import argparse
import json
# from jsonschema import validate, ValidationError

parser = argparse.ArgumentParser(description='Does the tedious job of generating assembly for objects')
parser.add_argument('-s', '--schema-file',
                    type=argparse.FileType('r'),
                    help='The JSON file describing the objects',
                    default='schema.json')
parser.add_argument('-i', '--input-file',
                    type=argparse.FileType('r'),
                    help='The JSON file describing the objects',
                    default='game_data.json')
#parser.add_argument('-o', '--output-object-file',
                    #type=argparse.FileType('r'),
                    #help='The ASM file with the objects\' code',
                    #default='objects.asm')
#parser.add_argument('-p', '--output-palette-file',
                    #type=argparse.FileType('r'),
                    #help='The ASM file with the palettes\' code',
                    #default='palette.asm')

args = parser.parse_args()

with args.input_file as json_file:
    json_data = json.load(json_file)

with args.schema_file as schema_file:
    schema_data = json.load(schema_file)

# Templates for the ASM code
agent_start_template = '.MACRO load{}'
agent_end_template = '.ENDM\n'

load_tile_template = '  LDA #${:02X}\n  STA ${:04X}, x'

oam_index = 0

for agent in json_data['agents']:
    print(agent_start_template.format(agent['name']))
    for tile in agent['tiles']:
        print(load_tile_template.format(agent['y_position'] + tile['y_offset'], 0x0200 + oam_index * 4))
        print(load_tile_template.format(int(tile['address'], 0), 0x0200 + oam_index * 4 + 1))
        print(load_tile_template.format(int(tile['attributes'], 0), 0x0200 + oam_index * 4 + 2))
        print(load_tile_template.format(agent['x_position'] + tile['x_offset'], 0x0200 + oam_index * 4 + 3))
        print()
        oam_index += 1
    print(agent_end_template)
