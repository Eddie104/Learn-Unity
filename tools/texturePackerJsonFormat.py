#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import os
import json2lua


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
    # for frame in frames:
    #     if frame.get('filename') == filename:
    #         sprite_source_size = frame.get('spriteSourceSize')
    #         return (sprite_source_size.get('x') - sprite_source_size.get('w') / 2) / 100.0
    return 0.0


def create_offset_y_with(frames, filename):
    for frame in frames:
        if frame.get('filename') == filename:
            return (frame.get('frame').get('h') / 2 + frame.get('spriteSourceSize').get('y') - frame.get('sourceSize').get('h') / 2) / 100.0


def main():
    for parent, dir_name_arr, file_name_arr in os.walk('../Assets/Imgs/'):
        for file_name in file_name_arr:
            if file_name.endswith('.txt'):
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
                    # 生成配置文件
                    # 对象的type值
                    object_type = file_name.split('_')[1].split('.')[0]
                    if file_name.startswith('role'):
                        frame_list = [
                            {
                                'name': 'idle3',
                                'frame': [
                                    {
                                        'body': {
                                            'name': 'role_%s_3_01' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_01.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_01.png' % object_type)
                                        },
                                        'hand': {
                                            'name': 'role_%s_3_hand_01' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_hand_01.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_hand_01.png' % object_type)
                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'walk3',
                                'frame': [
                                    {
                                        'body': {
                                            'name': 'role_%s_3_02' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_02.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_02.png' % object_type)
                                        },
                                        'hand': {
                                            'name': 'role_%s_3_hand_02' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_hand_02.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_hand_02.png' % object_type)
                                        }
                                    },
                                    {
                                        'body': {
                                            'name': 'role_%s_3_01' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_01.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_01.png' % object_type)
                                        },
                                        'hand': {
                                            'name': 'role_%s_3_hand_01' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_hand_01.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_hand_01.png' % object_type)
                                        }
                                    },
                                    {
                                        'body': {
                                            'name': 'role_%s_3_03' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_03.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_03.png' % object_type)
                                        },
                                        'hand': {
                                            'name': 'role_%s_3_hand_04' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_hand_04.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_hand_04.png' % object_type)
                                        }
                                    },
                                    {
                                        'body': {
                                            'name': 'role_%s_3_01' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_01.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_01.png' % object_type)
                                        },
                                        'hand': {
                                            'name': 'role_%s_3_hand_01' % object_type,
                                            'offsetX': create_offset_x_with(new_frames, 'role_%s_3_hand_01.png' % object_type),
                                            'offsetY': create_offset_y_with(new_frames, 'role_%s_3_hand_01.png' % object_type)
                                        }
                                    }
                                ]
                            }
                        ]
                        lua_str = 'return ' + json2lua.dic_to_lua_str(frame_list)
                        write_json('../Assets/Lua/app/config/roleAnimation.lua', lua_str)
                write_json(json_path, json.dumps(json_data))
                print('%s is done!' % json_path)


if __name__ == '__main__':
    main()
    print('done')
