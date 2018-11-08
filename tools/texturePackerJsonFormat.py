#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import os


def read_json(json_path):
    f = open(json_path)
    json_txt = f.read()
    f.close()
    return json_txt


def write_json(json_path, json_txt):
    f = open(json_path, 'w')
    f.write(json_txt)
    f.close()


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
                write_json(json_path, json.dumps(json_data))
                print('%s is done!' % json_path)

if __name__ == '__main__':
    main()
    print('done')
