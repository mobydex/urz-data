#!/bin/bash

args=(
  # 1. residential
  # n/building=residential,apartments,house,detached,terrace

  # 2. shopping / retail
  n/shop=supermarket,convenience,greengrocer,bakery,butcher,dairy
  n/shop=chemist,cosmetics
  n/amenity=pharmacy

  # 3. health care
  n/amenity=doctors,dentist,hospital
  n/healthcare=hospital
  n/social_facility=nursing_home
  n/amenity=social_facility

  # 4. education & child care
  n/amenity=kindergarten,childcare,school,college,university,library

  # 5. Work
  n/amenity=coworking_space

  # 6. Leisure, Sport & Culture
  n/leisure=park
  n/amenity=cinema,theatre
  n/amenity=restaurant,cafe,bar,fast_food,pub

  # 7. Public Transport
  n/highway=bus_stop
  n/public_transport=platform
  n/railway=station
  n/public_transport=stop_position
  n/amenity=bus_station
  n/railway=halt
  n/light_rail=station
  n/subway=station
  n/tram=station
)

echo "Args: ${args[@]}"

osmium tags-filter "$1" "${args[@]}" -o out.nodes.osm.pbf

