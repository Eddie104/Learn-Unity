#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import shutil
import json
from utils.json2lua import dic_to_lua_str

# 当前脚本所在目录
script_root = os.path.split(os.path.realpath(__file__))[0]
# 客户端根目录
game_root = os.path.split(script_root)[0]
# 资源目录
res_root = game_root + '/Assets/Res'

down_root = '%s/Downloads' % os.path.expanduser('~')

def mk_dir(path):
	if not os.path.exists(path):
		os.makedirs(path)
	return path

if __name__ == '__main__':
    # 先把下载好的json复制到项目目录下
    # cfg_arr = ['mine.json', 'npc.json', 'suit.json', 'item.json',
    #         'award.json', 'forest.json', 'vehicle.json', 'terrain.json']
    cfg_arr = ['scene.json', 'furniture.json', 'publicScene.json']
    dir_name = os.path.join(res_root, 'doc', 'config')
    mk_dir(dir_name)
    for cfg in cfg_arr:
        source_cfg_path = os.path.join(down_root, cfg)
        if os.path.exists(source_cfg_path):
            target_file_path = os.path.join(dir_name, cfg)
            shutil.move(source_cfg_path, target_file_path)
    # 再生成lua
    for parent, dirnames, filenames in os.walk(dir_name):
        for filename in filenames:
            if filename.endswith('.json'):
                print('start : %s' % filename)
                f = open(os.path.join(parent, filename))
                json_str = f.read()
                f.close()
                lua_str = dic_to_lua_str(json.loads(json_str)).encode('utf-8')
                f = open(os.path.join(game_root, 'Assets', 'Lua', 'app', 'config',
                                      filename.replace('.json', '.lua')), 'wb')
                f.write('return ' + lua_str)
                f.close()
                print('end : %s' % filename)
    print('done!')
