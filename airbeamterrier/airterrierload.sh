#!/bin/bash

# This file redirects output of the python script to a log file

# Set the filename of the log file
logFile="/data/sasa_airquality/airbeamterrier/logs/airbeamterrier.log"

# Redirect all output to a log file
exec &>> $logFile

python /data/sasa_airquality/airbeamterrier/airbeamterrier.py
