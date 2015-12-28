#!/usr/bin/env python


# GETS YAHOO WEATHER DATA FOR SPECIFIC CITY, SAVE IT IN CURRENT DIR
def get_weather_data(city_numb):
    import urllib.request as urlreq

    url = 'http://weather.yahooapis.com/forecastrss?w={}&u=c'.format(city_numb)

    with urlreq.urlopen(url) as resp, open('weather.xml', 'wb') as out_file:
        data = resp.read()
        out_file.write(data)


# GETS SUNRISE TIME FROM weather.xml
def get_sunrise():
    import xml.etree.ElementTree as etree

    ns = {'yweather': 'http://xml.weather.yahoo.com/ns/rss/1.0',
          'geo': 'http://www.w3.org/2003/01/geo/wgs84_pos#'}

    tree = etree.parse('weather.xml')

    for char in tree.findall('channel/yweather:astronomy', ns):
        silly = char.get('sunrise').split()[0]

    print(silly)


# GETS SUNSET TIME IN 24 HOUR FORMAT FROM weather.xml
def get_sunset():
    import xml.etree.ElementTree as etree

    ns = {'yweather': 'http://xml.weather.yahoo.com/ns/rss/1.0',
          'geo': 'http://www.w3.org/2003/01/geo/wgs84_pos#'}

    tree = etree.parse('weather.xml')

    for char in tree.findall('channel/yweather:astronomy', ns):
        silly = char.get('sunset').split()[0]

    setsun = silly.split(':')
    print('{}:{}'.format(int(setsun[0]) + 12, setsun[1]))


# SHOWS THIS MONTH CALENDAR WITH TODAY MARKED RED
def get_calendar():
    import time
    import calendar

    localtime = time.localtime(time.time())
    calendar.setfirstweekday(calendar.MONDAY)
    cal = calendar.month(localtime[0], localtime[1])

    parts = cal.split('\n')
    del parts[0]
    del parts[-1]
    parts[0] = '${{color9}}{}${{color1}}'.format(parts[0])
    cal = '${color1}${offset 175}' + '\n${offset 175}'.join(parts)
    today = '${{color4}}{}${{color1}}'.format(localtime[2])
    new_cal = cal.replace(str(localtime[2]), today)
    print(new_cal)


if __name__ == '__main__':
    import sys
    import os
    cmd_args = sys.argv
    working_dir = os.path.dirname(os.path.realpath(__file__))
    os.chdir(working_dir)

    if cmd_args[1] == 'get_weather_data':
        get_weather_data(cmd_args[2])
    if cmd_args[1] == 'get_sunrise':
        get_sunrise()
    if cmd_args[1] == 'get_sunset':
        get_sunset()
    if cmd_args[1] == 'get_calendar':
        get_calendar()
