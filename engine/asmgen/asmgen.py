import argparse
import json
# from jsonschema import validate, ValidationError

parser = argparse.ArgumentParser(description='Does the tedious job of generating assembly for objects')
parser.add_argument('-s', '--schema-file',
                    type=argparse.FileType('r'),
                    help='The JSON file describing the objects',
                    default='engine/asmgen/schema.json')
parser.add_argument('-i', '--input-file',
                    type=argparse.FileType('r'),
                    help='The JSON file describing the objects',
                    default='game_data.json')
parser.add_argument('-m', '--output-macros-file',
                    type=argparse.FileType('w+'),
                    help='The ASM file with the macros',
                    default='build/macros.asm')

args = parser.parse_args()

with args.input_file as json_file:
    json_data = json.load(json_file)

with args.schema_file as schema_file:
    schema_data = json.load(schema_file)

# Templates for the ASM code
macro_start_template = '.MACRO load{}\n'
macro_end_template = '.ENDM\n\n'

load_tile_template = '  LDA #${:02X}\n' \
                     '  STA ${:04X}\n'

load_oam_template = '  LDA #${1:02X}\n' \
                    '  STA AgentYLow + {0}\n' \
                    '  LDA #${2:02X}\n' \
                    '  STA AgentXLow + {0}\n' \
                    '  LDA #${3:02X}\n' \
                    '  STA AgentOAMAddress + {0}\n' \
                    '  LDA #${4:02X}\n' \
                    '  STA AgentTileTotal + {0}\n\n'

load_palette_template = '; Load values into the PPU (MUST LATCH FIRST)\n' \
                        '  LDA #${:02X}\n'\
                        '  STA $2007\n' \
                        '  LDA #${:02X}\n'\
                        '  STA $2007\n' \
                        '  LDA #${:02X}\n'\
                        '  STA $2007\n' \
                        '  LDA #${:02X}\n'\
                        '  STA $2007\n\n'


for palette in json_data['palettes']:
    args.output_macros_file.write('; ' + palette['name'] + '\n')
    args.output_macros_file.write(macro_start_template.format(palette['name']))
    args.output_macros_file.write(load_palette_template.format(int(palette['colors'][0], 0),
                                                               int(palette['colors'][1], 0),
                                                               int(palette['colors'][2], 0),
                                                               int(palette['colors'][3], 0)))
    args.output_macros_file.write(macro_end_template)

oam_index = 0

for i, agent in enumerate(json_data['agents']):
    args.output_macros_file.write(macro_start_template.format(agent['name']))
    args.output_macros_file.write(load_oam_template.format(i, agent['y_position'], agent['x_position'], oam_index * 4, len(agent['tiles'])))
    for tile in agent['tiles']:
        args.output_macros_file.write(load_tile_template.format(agent['y_position'] + tile['y_offset'], 0x0200 + oam_index * 4))
        args.output_macros_file.write(load_tile_template.format(int(tile['address'], 0), 0x0200 + oam_index * 4 + 1))
        args.output_macros_file.write(load_tile_template.format(int(tile['attributes'], 0), 0x0200 + oam_index * 4 + 2))
        args.output_macros_file.write(load_tile_template.format(agent['x_position'] + tile['x_offset'], 0x0200 + oam_index * 4 + 3))
        args.output_macros_file.write('\n')
        oam_index += 1
    args.output_macros_file.write(macro_end_template)
