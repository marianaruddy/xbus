from django.shortcuts import render,redirect
from django.http import HttpResponse
import json
from ..models import RouteModel, Route, RouteStopsModel
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

        routeModel.deleteRouteById(id)

        return managementRoutes(request)

def managementRoutes(request):
        route = RouteModel()
        routes = route.getAllRoutes()

        context = {
                'routes': routes,
        }
        return render(request, 'Management/routes.html', context)

def managementRoutesAdd(request):
        return render(request, 'Management/routesAdd.html')

def managementRoutesEdit(request, id):
        routeStopsModel = RouteStopsModel()
        stops = routeStopsModel.getStopsDictNoCoordsFromRouteId(id)

        context = {
               'stops': json.dumps(stops),
               'routeId': id,
        }

        return render(request, 'Management/routesAdd.html', context)
    
def createRoute(request):
    if request.method == 'POST':

        stopsList = request.POST.getlist('stops')[0].split(',')
        route = Route()
        route.Destiny = stopsList[-1]
        route.Origin = stopsList[0]
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