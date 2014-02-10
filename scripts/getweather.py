#!/usr/bin/python

#get current temp from zip code

import os
import argparse
from xml.dom import minidom
import urllib

parser = argparse.ArgumentParser()
parser.add_argument('--zipcode',action='store',help='zip code',required=True)
args = parser.parse_args()

zipcode = args.zipcode

url = 'http://www.weather.gov/xml/current_obs/KDTO.xml'
feed = urllib.urlopen(url)
doc = minidom.parse(feed)
temp_f = doc.getElementsByTagName("temp_f")
temperature = temp_f[0].childNodes[0].nodeValue

print temperature + ' F' 
