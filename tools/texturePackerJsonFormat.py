#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import os
import utils.json2lua


def read_json(json_path):
    f = open(json_path)
    json_txt = f.read()
    f.close()
    return json_txt


def write_json(json_path, json_txt):
    f = open(json_path, 'w')
    f.write(json_txt)
    f.close()


def create_offset_x_with(frames, filename):
    for frame in frames:
        if frame.get('filename') == filename:
            # 原图大小
            source_size = frame.get('sourceSize')
            # 小图在原图中的位置
            sprite_source_size = frame.get('spriteSourceSize')
            return (sprite_source_size.get('w') / 2 + sprite_source_size.get('x')) - source_size.get('w') / 2


def create_offset_y_with(frames, filename):
    for frame in frames:
        if frame.get('filename') == filename:
            # 原图大小
            source_size = frame.get('sourceSize')
            # 小图在原图中的位置
            sprite_source_size = frame.get('spriteSourceSize')
            return source_size.get('h') / 2 - (sprite_source_size.get('h') / 2 + sprite_source_size.get('y'))


def main():
    # 当前脚本所在目录
    script_root = os.path.split(os.path.realpath(__file__))[0]
    for parent, _, file_name_arr in os.walk(os.path.join(script_root, '../Assets/Imgs/')):
        for file_name in file_name_arr:
            if file_name.endswith('.txt'):
                # 将旧版的texturePacker生成的txt格式化一下，以便自动切图图集
                json_path = os.path.join(parent, file_name)
                json_txt = read_json(json_path)
                json_data = json.loads(json_txt)
                if not json_data.get('formated', False):
                    frames = json_data.get('frames', [])
                    new_frames = []
                    for key, val in frames.items():
                        val['filename'] = key
                        new_frames.append(val)
                    json_data['frames'] = new_frames
                    json_data['formated'] = True
                write_json(json_path, json.dumps(json_data))
                print('%s is done!' % json_path)


if __name__ == '__main__':
    main()
    print('done')
