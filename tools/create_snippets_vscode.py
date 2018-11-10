#!/usr/bin/env python
# -*- coding: utf-8 -*-


import os
import requests
from requests.adapters import HTTPAdapter
import json
from pyquery import PyQuery


snippets_arr = [
	'''"Load scene": {
		"prefix": "LoadScene",
		"body": [
			"SceneManager.LoadScene('$1')"
		],
		"description": "Load scene"
	},
	"Log info": {
		"prefix": "logInfo",
		"body": [
			"logInfo('$1')"
		],
		"description": "logInfo"
	},
	"Log debug": {
		"prefix": "logDebug",
		"body": [
			"logDebug('$1')"
		],
		"description": "logDebug"
	},
	"Log warn": {
		"prefix": "logWarn",
		"body": [
			"logWarn('$1')"
		],
		"description": "logWarn"
	},
	"Log error": {
		"prefix": "logError",
		"body": [
			"logError('$1')"
		],
		"description": "logError"
	}'''
];


def read_file(path):
    f = open(path)
    txt = f.read()
    f.close()
    return txt


def write_file(path, content):
	f = open(path, 'w')
	f.write(content)
	f.close()


def get(url):
	print(url)
	s = requests.Session()
	s.mount('https://', HTTPAdapter(max_retries=10))
	response = None
	try:
		response = s.get(url, timeout=10)
	except Exception as err:
		return get(url)
	if response.status_code == 200:
		pq = None
		try:
			pq = PyQuery(response.text)
		except:
			pq = None
		return pq
	else:
		return None


def create_snippet(class_name, key, val, type, sign):
	val = val.replace('"', '\\"').split('\n')[0]
	if type in ['Properties', 'Static Properties']:
		title = '%s.%s' % (class_name, key)
		prefix = title
		body = key
		description = 'return:%s des: %s' % (sign, val)
	elif type in ['Public Methods', 'Static Methods']:
		title = '%s.%s' % (class_name, key)
		prefix = title
		body = '%s($1)' % key if type == 'Public Methods' else title
		description = '%s des: %s' % (sign, val)
	elif type == 'Messages':
		title = '%s.%s' % (class_name, key)
		prefix = title
		body = key
		description = val

	return '''
	"%s": {
		"prefix": "%s",
		"body": [
			"%s"
		],
		"description": "%s"
	}''' % (title, prefix, body, description)


def fetch_detail(url, class_name, key, type):
	pq = get(url)
	val = ''
	for div in pq('div.subsection'):
		div = PyQuery(div)
		h2 = div.find('h2').text()
		if h2 == 'Description':
			val = div.find('p').text()
			break
	global snippets_arr
	# if type in ['Properties', 'Static Properties']:
	if type in ['Static Properties']:
		sign = pq('div.signature-CS').text().replace('public', '').replace(key, '').replace(';', '').strip()
		snippets_arr.append(create_snippet(class_name, key, val, type, sign))
	# elif type in ['Public Methods', 'Static Methods']:
	# 	sign = pq('div.signature-CS').text()
	# 	snippets_arr.append(create_snippet(class_name, key, val, type, sign))
	# elif type == 'Messages':
	# 	sign = ''
	# 	snippets_arr.append(create_snippet(class_name, key, val, type, sign))


def fetch_page(url, class_name):
	pq = get(url)
	for div in pq('div.subsection'):
		div = PyQuery(div)
		h2 = div.find('h2').text()
		if h2 in ['Properties', 'Static Properties', 'Public Methods', 'Static Methods', 'Messages']:
			for a in div.find('a'):
				fetch_detail('https://docs.unity3d.com/ScriptReference/%s' % a.get('href'), class_name, a.text, h2)
			global snippets_arr
			txt = ','.join(snippets_arr)
			write_file('lua.json', txt)


def do_data(data):
	link = data.get('link', None)
	if link and link != 'null':
		fetch_page('https://docs.unity3d.com/ScriptReference/%s.html' % link, link)
	children = data.get('children', None)
	if children:
		for child in children:
			do_data(child)


def main():
	# txt = get('https://docs.unity3d.com/ScriptReference/docdata/global_toc.js').html(
	txt = get('https://docs.unity3d.com/ScriptReference/docdata/toc.js').html(
	).replace('</t0>', '').replace('var toc = ', '')
	json_data = json.loads(txt)
	# print(json_data)
	data_arr = json_data.get('children')[0].get('children')
	for data in data_arr:
		if data.get('title') == 'Classes':
			data_arr = data.get('children')
			break
	for data in data_arr:
		do_data(data)

	# txt = get('https://docs.unity3d.com/ScriptReference/docdata/toc.js').html(
	# ).replace('</t0>', '').replace('var toc = ', '')
	# json_data = json.loads(txt)
	# # print(json_data)
	# data_arr = json_data.get('children')[0].get('children')
	# for data in data_arr:
	# 	if data.get('title') == 'Classes':
	# 		data_arr = data.get('children')
	# 		break
	# for data in data_arr:
	# 	do_data(data)


if __name__ == '__main__':
    main()
