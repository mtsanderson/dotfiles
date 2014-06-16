#!/bin/bash

curl -s http://www.wunderground.com/US/TX/denton.html | grep -A1 '<span class="wx-data" data-station="KTXDENTO11" data-variable="feelslike">' | grep wx-value | sed "s/		<span class=\"wx-value\">//" | cut -d '<' -f1
