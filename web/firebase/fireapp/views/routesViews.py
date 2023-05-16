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
    
def createRoute(request):
    if request.method == 'POST':

        stopsList = request.POST.getlist('stops')[0].split(',')
        route = Route()
        route.Destiny = stopsList[-1]
        route.Origin = stopsList[0]
        routeModel = RouteModel()
        routeId = routeModel.createRoute(route)

        routeStopsModel = RouteStopsModel()
        for stopId in stopsList:
            routeStopsModel.createRouteStops(routeId,stopId)

        return redirect('managementRoutes')

    else:
        return HttpResponse(
            json.dumps({"nothing to see": "this isn't happening"}),
            content_type="application/json"
        )
#End Routes