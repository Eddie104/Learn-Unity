#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import types
import os
import shutil

# 当前脚本所在目录
script_root = os.path.split(os.path.realpath(__file__))[0]
# 客户端根目录
game_root = os.path.split(script_root)[0]
# 资源目录
res_root = '../../../timetown-res'

down_root = '%s/Downloads' % os.path.expanduser('~')

# print(down_root)


def space_str(layer):
    lua_str = ""
    for i in range(0, layer):
        lua_str += '\t'
    return lua_str


def dic_to_lua_str(data, layer=0):
    d_type = type(data)
    if d_type is types.StringTypes or d_type is str or d_type is types.UnicodeType:
        # return "'""'" + data + "'"
        return "'" + data + "'"
    elif d_type is types.BooleanType:
        if data:
            return 'true'
        else:
            return 'false'
    elif d_type is types.IntType or d_type is types.LongType or d_type is types.FloatType:
        return str(data)
    elif d_type is types.ListType:
        lua_str = "{\n"
        lua_str += space_str(layer+1)
        for i in range(0, len(data)):
            lua_str += dic_to_lua_str(data[i], layer + 1)
            if i < len(data)-1:
                lua_str += ','
        lua_str += '\n'
        lua_str += space_str(layer)
        lua_str += '}'
        return lua_str
    elif d_type is types.DictType:
        lua_str = ''
        lua_str += "\n"
        lua_str += space_str(layer)
        lua_str += "{\n"
        data_len = len(data)
        data_count = 0
        for k, v in data.items():
            if k == '_id' or k == '__v':
                continue
            data_count += 1
            lua_str += space_str(layer+1)
            if type(k) is types.IntType:
                lua_str += '[' + str(k) + ']'
            else:
                lua_str += k
            lua_str += ' = '
            try:
                lua_str += dic_to_lua_str(v, layer + 1)
                if data_count < data_len:
                    lua_str += ',\n'

            except Exception, e:
                print 'error in ', k, v
                raise
        lua_str += '\n'
        lua_str += space_str(layer)
        lua_str += '}'
        return lua_str
    else:
        print d_type, 'is error'
        return None


if __name__ == '__main__':
    # 先把下载好的json复制到项目目录下
    # cfg_arr = ['furniture.json', 'mine.json', 'npc.json', 'scene.json', 'suit.json', 'item.json',
    #         'award.json', 'forest.json', 'publicScene.json', 'vehicle.json', 'terrain.json']
    cfg_arr = []
    for cfg in cfg_arr:
        source_cfg_path = os.path.join(down_root, cfg)
        if os.path.exists(source_cfg_path):
            target_file_path = os.path.join(res_root, 'doc', 'config', cfg)
            shutil.move(source_cfg_path, target_file_path)
    # 再生成lua
    for parent, dirnames, filenames in os.walk(os.path.join(res_root, 'doc', 'config')):
        for filename in filenames:
            if filename.endswith('.json'):
                print('start : %s' % filename)
                f = open(os.path.join(parent, filename))
                json_str = f.read()
                f.close()
                lua_str = dic_to_lua_str(json.loads(json_str)).encode('utf-8')
                f = open(os.path.join(game_root, 'src', 'app', 'config',
                                    filename.replace('.json', '.lua')), 'wb')
                f.write('return ' + lua_str)
                f.close()
                print('end : %s' % filename)
    print('done!')
