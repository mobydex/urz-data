import requests
import json
import polyline

project_id = 2
coordiante_system = 'WGS84'
coordinate_precision = 5

print("Loading cells and decoding cell bounds:")
cells = requests.get(f'https://mobydex.locoslab.com/controller-service/projects/{project_id}/cells?coordinateSystem={coordiante_system}&coordinatePrecision={coordinate_precision}&pageOffset=0&pageSize=10000').json()
for cell in cells['elements'][:5]: # print only first 5 cells
    print(cell['id'], polyline.decode(cell['bounds']['coordinates'], cell['bounds']['precision'] ) )


print("Finding computations for route planning:")
mode = 'transit' # or driving, walking, cycling
route_computation = None
computations = requests.get(f'https://mobydex.locoslab.com/controller-service/projects/{project_id}/computations?pageOffset=0&pageSize=10000').json()
for computation in computations['elements']:
    print(computation['id'], computation['type'], computation['attributes'] )
    if computation['type'] == 'DIRECTIONS' and computation['attributes']['mode'] == mode:
        route_computation = computation


if route_computation is not None:
    cell_id = cells['elements'][0]['id']
    # Request directions from the first cell to all other cells but do not include all route details
    directions = requests.get(f'https://mobydex.locoslab.com/controller-service/computations/{route_computation["id"]}/directions?origins={cell_id}&steps=true&routes=false').json()
    print(json.dumps(directions[0], indent=2)) # only print one result not all of them


# Request the first direction from the first cell to the second cell including all route details
destination_cell_id = cells['elements'][1]['id']
directions = requests.get(f'https://mobydex.locoslab.com/controller-service/computations/{route_computation["id"]}/directions?origins={cell_id}&destinations={destination_cell_id}&steps=true&routes=true').json()
print(json.dumps(directions[0], indent=2)) # only print one result not all of them

