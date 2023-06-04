from django.shortcuts import render
from django.http import HttpResponse
from ..models import StopModel
import json

def home(request):
        return render(request, 'home.html')

def stopDetails(request):
        if request.method == 'GET':
                stopName = request.GET["stopName"]
                stopModel = StopModel()
                stop = stopModel.getStopDictByName(stopName)

                stopDetails = {}
                stopDetails['Address'] = stop['Address']
                stopDetails['Tickets'] = stopModel.getQuantityOfTicketsGeneratedToStopToTheNext30Minutes(stop['Id'])

                response_data = stopDetails

                return HttpResponse(
                        json.dumps(response_data),
                        content_type="application/json"
                )

        else:
                return HttpResponse(
                        json.dumps({"nothing to see": "this isn't happening"}),
                        content_type="application/json"
                )