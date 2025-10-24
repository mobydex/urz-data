#!/bin/bash

args=(
  # 1. residential
  # building=residential,apartments,house,detached,terrace

  # 2. shopping / retail
  shop=supermarket,convenience,greengrocer,bakery,butcher,dairy
  shop=chemist,cosmetics amenity=pharmacy

  # 3. health care
  amenity=doctors,dentist,hospital healthcare=hospital
  social_facility=nursing_home amenity=social_facility

  # 4. education & child care
  amenity=kindergarten,childcare,school,college,university,library

  # 5. Work
  amenity=coworking_space

  # 6. Leisure, Sport & Culture
  leisure=park
  amenity=cinema,theatre
  amenity=restaurant,cafe,bar,fast_food,pub

  # 7. Public Transport
  highway=bus_stop public_transport=platform railway=station public_transport=stop_position amenity=bus_station railway=halt light_rail=station subway=station tram=station
)

osmium tags-filter "$1" "${args[@]}" -o out.osm.pbf

