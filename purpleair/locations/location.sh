curl -g "https://map.purpleair.org/json" > locations.json

python3 locationload.py locations.json


pgloader data.load
