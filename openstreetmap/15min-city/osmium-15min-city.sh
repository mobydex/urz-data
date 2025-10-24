#!/bi"${TYPE}"bash

# Osm entity type (node, way, relation)
TYPE=""
# TYPE="n/"

args=(
  # 1. residential
  # "${TYPE}"building=residential,apartments,house,detached,terrace

  # 2. shopping / retail
  "${TYPE}"shop=supermarket,convenience,greengrocer,bakery,butcher,dairy
  "${TYPE}"shop=chemist,cosmetics
  "${TYPE}"amenity=pharmacy

  # 3. health care
  "${TYPE}"amenity=doctors,dentist,hospital
  "${TYPE}"healthcare=hospital
  "${TYPE}"social_facility=nursing_home
  "${TYPE}"amenity=social_facility

  # 4. education & child care
  "${TYPE}"amenity=kindergarten,childcare,school,college,university,library

  # 5. Work
  "${TYPE}"amenity=coworking_space

  # 6. Leisure, Sport & Culture
  "${TYPE}"leisure=park
  "${TYPE}"amenity=cinema,theatre
  "${TYPE}"amenity=restaurant,cafe,bar,fast_food,pub

  # 7. Public Transport
  "${TYPE}"highway=bus_stop
  "${TYPE}"public_transport=platform
  "${TYPE}"railway=station
  "${TYPE}"public_transport=stop_position
  "${TYPE}"amenity=bus_station
  "${TYPE}"railway=halt
  "${TYPE}"light_rail=station
  "${TYPE}"subway=station
  "${TYPE}"tram=station
)

echo "Args: ${args[@]}"

osmium tags-filter "$1" "${args[@]}" -o out.nodes.osm.pbf

