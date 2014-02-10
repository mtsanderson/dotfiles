#!/usr/bin/python

#generates m3u playlist in current directory containing all songs from specified album

import pycurl
import cStringIO
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-o',action='store',help='Output directory',required=False)
args = parser.parse_args()

artist = raw_input("Enter the artist name: ").lower();

album = raw_input("Enter the album name: ").lower();

massagedalbum = album.replace(" ","%20")
massagedartist = album.replace(" ","%20")
url = 'http://localhost:9999/get_by_search?type=album&artist='+massagedartist + '&title='+massagedalbum
fname = artist.replace(" ","")+album.replace(" ", "")+'.m3u'

buff = cStringIO.StringIO()

c = pycurl.Curl()
c.setopt(c.URL, url)
c.setopt(c.CONNECTTIMEOUT, 10)
c.setopt(c.TIMEOUT, 50)
c.setopt(c.SSL_VERIFYHOST, 0)
c.setopt(c.SSL_VERIFYPEER, 0)
c.setopt(c.WRITEFUNCTION, buff.write)

c.perform()

content = buff.getvalue()

f = open(fname,'w')
f.write(content)
f.close()
