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
                new_frames = None
                json_path = os.path.join(parent, file_name)
                json_txt = read_json(json_path)
                json_data = json.loads(json_txt)
                if not json_data.get('formated', False):
                    frames = json_data.get('frames', [])
                    new_frames = []
                    for key, val in frames.items():
                        val['filename'] = key
                        new_frames.append(val)
                else:
                    new_frames = json_data.get('frames')

                # 生成动画的配置文件
                # 对象的type值
                object_type = file_name.split('_')[1].split('.')[0]
                if file_name.startswith('role'):
                    frame_prefix = 'role_%s_' % object_type
                    animation_list = read_json(os.path.join(script_root, './animation/roleAnimation.json'))
                    animation_list = json.loads(animation_list)
                    for animation in animation_list:
                        for frame in animation.get('frames'):
                            for part in frame.keys():
                                t = '%s%s.png' % (
                                    frame_prefix, frame[part].get('name'))
                                frame[part]['vector2'] = 'Vector2(%d, %d)' % (
                                    create_offset_x_with(new_frames, t), create_offset_y_with(new_frames, t))
                                frame[part]['name'] = frame_prefix + \
                                    frame[part].get('name')
                    lua_str = 'return ' + \
                        utils.json2lua.dic_to_lua_str(animation_list)
                    # 把 'Vector2(-0.01, -0.14)' 的引号去掉
                    lua_str = lua_str.replace(
                        'vector2 = \'', 'vector2 = ').replace(')\'', ')')
                    write_json(os.path.join(script_root, '../Assets/Lua/app/config/roleAnimation_%s.lua' % object_type), lua_str)
                    print('%s is done!' % os.path.join(script_root, '../Assets/Lua/app/config/roleAnimation_%s.lua' % object_type))
                elif file_name.startswith('clothes'):
                    pass


if __name__ == '__main__':
    main()
    print('done')
