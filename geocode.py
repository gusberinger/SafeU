import pandas as pd
import requests
import json


with open("api.txt", "r") as f:
    api = f.read()

def geocode(address):
    print(address)
    address = address + ", Minneapolis MN"
    url = f"https://maps.googleapis.com/maps/api/geocode/json?address={address}&key={api}"
    response = json.loads(requests.get(url).content)
    location = response['results'][0]['geometry']['location']
    lat, long = location['lat'], location['lng']
    print(lat, long)
    return (lat, long)

df = pd.read_csv("SafeU_locations.csv")
df = df.dropna()
df = df.assign(
    latlong = lambda df: df.Location.apply(geocode)
)
for i, col in enumerate(['lat', 'long']):
    df[col] = df['latlong'].apply(lambda x: x[i])
df = df.drop('latlong', axis=1)
df.to_csv("SafeU_geocoded.csv")
