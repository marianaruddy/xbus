from django.shortcuts import render,redirect
from django.http import HttpResponse
import json
from ..models import RouteModel, Route, RouteStopsModel, TripModel
from datetime import datetime

#Routes
def routes(request):
        route = Route()
        date = datetime(2023,4,27)

        route = route.getStopWithBiggestWaitingTimeByRouteAndDate("YpJSm4cl9adlkSXZMVIo", date)
        context = {
                'route': route,
        }
        return render(request, 'Reports/routes.html', context)

def deleteRoute(request, id):
        routeModel = RouteModel()

        tripModel = TripModel()
        if len(tripModel.getFutureOrProgressTripsByRouteId(id)) > 0:
                routeModel = RouteModel()
                routes = routeModel.getAllActiveRoutes()

                context = {
                        'routes': routes,
                        'hasTripAssociatedToRoute': False,
                        'hasFutureOrProgressTripToDelete': True,
                }
                return render(request, 'Management/routes.html', context)

        routeModel.deleteRouteById(id)

        return redirect('managementRoutes')

def managementRoutes(request):
        if not request.user.is_authenticated:
                return redirect('myLogin')
        route = RouteModel()
        routes = route.getAllActiveRoutes()

        context = {
                'routes': routes,
                'hasTripAssociatedToRoute': False,
                'hasFutureOrProgressTripToDelete': False,
        }
        return render(request, 'Management/routes.html', context)

def managementRoutesAdd(request):
        if not request.user.is_authenticated:
                return redirect('myLogin')
        return render(request, 'Management/routesAdd.html')

def managementRoutesEdit(request, id):
        if not request.user.is_authenticated:
                return redirect('myLogin')
        routeStopsModel = RouteStopsModel()
        stops = routeStopsModel.getStopsDictNoCoordsFromRouteId(id)
        routeModel = RouteModel()
        price = routeModel.getRouteById(id)['Price']
        tripModel = TripModel()
        hasTripAssociatedToRoute = tripModel.hasTripAssociatedToRoute(id)

        if hasTripAssociatedToRoute:
                routes = routeModel.getAllActiveRoutes()

                context = {
                        'routes': routes,
                        'hasTripAssociatedToRoute': hasTripAssociatedToRoute,
                        'hasFutureOrProgressTripToDelete': False,
                }
                return render(request, 'Management/routes.html', context)
        else:
                context = {
                        'stops': json.dumps(stops),
                        'routeId': id,
                        'price': price,
                        'id': id
                }
                return render(request, 'Management/routesAdd.html', context)
    
def createRoute(request):
    if request.method == 'POST':

        stopsList = request.POST.getlist('stops')[0].split(',')
        route = Route()
        route.Destiny = stopsList[-1]
        route.Origin = stopsList[0]
        route.Price = float(request.POST.get('price'))
        routeModel = RouteModel()
        routeId = request.POST.get('routeId')
        routeStopsModel = RouteStopsModel()

        if (routeId != ""):
                route.Id = routeId
                routeModel.updateRoute(route)
                for i,stopId in enumerate(stopsList):
                        order = i + 1
                        routeStops = routeStopsModel.getRouteStopsFromRouteIdAndStopId(routeId,stopId)
                        if routeStops != {}:
                                routeStops["Order"] = order
                                routeStopsModel.updateRouteStops(routeStops)
                        else:
                                routeStopsModel.createRouteStops(routeId,stopId, order)
        else:
                routeId = routeModel.createRoute(route)
                for i,stopId in enumerate(stopsList):
                        order = i + 1
                        routeStopsModel.createRouteStops(routeId,stopId, order)

        return redirect('managementRoutes')

    else:
        return HttpResponse(
            json.dumps({"nothing to see": "this isn't happening"}),
            content_type="application/json"
        )
#End Routes