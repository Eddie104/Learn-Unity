#!/usr/bin/env python
# -*- coding: utf-8 -*-


import os
import requests
from pyquery import PyQuery


def read_file(path):
    f = open(path)
    txt = f.read()
    f.close()
    return txt


def get(url):
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


def main():
    for parent, dir_name_arr, file_name_arr in os.walk('../Assets/Source/Generate/'):
        for file_name in file_name_arr:
            if file_name.endswith('.cs'):
                pass

if __name__ == '__main__':
    main()