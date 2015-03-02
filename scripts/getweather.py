import sys
import urllib2
from bs4 import BeautifulSoup

URL = 'http://www.wunderground.com/weather-forecast/US/TX/Denton.html'


def main():
    weather = get_weather(URL)
    print weather


def get_weather(url):
    page = urllib2.urlopen(url).read()
    soup = BeautifulSoup(page)

    temp_div = soup.find('div', attrs={'id':'curTemp'})
    temp_span = temp_div.find('span', attrs={'class':'wx-value'})
    temp = temp_span.get_text().strip()

    return temp


if __name__ == '__main__':
    sys.exit(main())

