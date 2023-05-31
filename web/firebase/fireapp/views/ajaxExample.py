from django.shortcuts import render
from django.http import HttpResponse
import json

#Ajax example
def myajaxtestview(request):
    if request.method == 'GET':
        param1 = request.GET.get('param_first')
        param2 = request.GET.get('param_second')
        print(param1, param2)


        response_data = 'successful!'

        return HttpResponse(
            json.dumps(response_data),
            content_type="application/json"
        )

    else:
        return HttpResponse(
            json.dumps({"nothing to see": "this isn't happening"}),
            content_type="application/json"
        )

def login(request):
        #EnewRegion = models.Region("1","Barra da Tijuca")
        #createRegion(newRegion)

        return render(request, 'login.html')
#End Ajax example

def addressTest(request):

    if request.method == 'POST':
        print(request.POST["ship-address"])


        response_data = 'successful!'

        return render(request, 'Components/addressTest.html')
    else:
        return render(request, 'Components/addressTest.html')
     
    