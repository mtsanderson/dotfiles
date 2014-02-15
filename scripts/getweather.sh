#!/bin/bash

curl -s http://www.wunderground.com/US/TX/denton.html | grep tempActual | cut -d '"' -f18
