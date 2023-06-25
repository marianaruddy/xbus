from django.shortcuts import render,redirect
from ..models import ReportRegionsModel,RouteModel, RegionModel
from ..forms import ReportRegionsForm
from datetime import datetime, date, timedelta
import json
from django.core.serializers.json import DjangoJSONEncoder

def reportRegions(request):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    allRoutes = fillAllRoutes()
    if request.method == "POST":
        form = ReportRegionsForm(request.POST, allRoutes = allRoutes)
        if form.is_valid():
            reportRegionsModel = ReportRegionsModel()
            post = form.cleaned_data
            routeId = post['RouteId']
            date = datetime(post["Date"].year, post["Date"].month, post["Date"].day)
            regionModel = RegionModel()
            allRegions = regionModel.getAllRegions()
            report = {}
            for region in allRegions:
                report[region['Name']] = reportRegionsModel.getQuantityOfTicketsGeneratedByRouteDateAndRegion(routeId, date, date + timedelta(days=1), region['Id'])

            form = ReportRegionsForm(allRoutes=allRoutes)
            return render(request, 'Reports/regions.html', {'form': form, 'report': json.dumps(report)})
        else:
            form = ReportRegionsForm(allRoutes=allRoutes)
    else:
        form = ReportRegionsForm(allRoutes=allRoutes)
    return render(request, 'Reports/regions.html', {'form': form})

def fillAllRoutes():
    routeModel = RouteModel()
    allRoutesDict = routeModel.getAllActiveRoutes()
    allRoutes = []
    for route in allRoutesDict:
        value = 'Route ' + str(route.Number) + ': ' + route.OriginName + ' - ' + route.DestinyName
        key = route.Id
        myTuple = (key, value)
        allRoutes.append(myTuple)
    return allRoutes