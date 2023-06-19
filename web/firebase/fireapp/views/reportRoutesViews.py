from django.shortcuts import render,redirect
from ..models import ReportRouteModel, RouteModel
from ..forms import ReportRouteForm
from datetime import datetime

def reportRoutes(request):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        allRoutes = fillAllRoutes()
        form = ReportRouteForm(request.POST, allRoutes=allRoutes)
        if form.is_valid():
            reportRouteModel = ReportRouteModel()
            post = form.save(commit=False)
            date = datetime(post.Date.year, post.Date.month, post.Date.day)
            report = reportRouteModel.getReportRoute(post.RouteId, date)
            form = ReportRouteForm(allRoutes=allRoutes)
            return render(request, 'Reports/routes.html', {'form': form, 'report': report})
        else:
            form = ReportRouteForm(allRoutes=allRoutes)
    else:
        allRoutes = fillAllRoutes()
        form = ReportRouteForm(allRoutes=allRoutes)
    return render(request, 'Reports/routes.html', {'form': form})

def fillAllRoutes():
    routeModel = RouteModel()
    allRoutesDict = routeModel.getAllActiveRoutes()
    allRoutes = []
    for route in allRoutesDict:
        value = route.OriginName + ' - ' + route.DestinyName
        key = route.Id
        myTuple = (key, value)
        allRoutes.append(myTuple)
    return allRoutes