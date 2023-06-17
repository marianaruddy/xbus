from django.shortcuts import redirect, render
from django.http import HttpResponse
from django.contrib.auth import authenticate, login
from django.contrib.auth import logout
from ..forms import LoginForm
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

def myLogin(request):
        #EnewRegion = models.Region("1","Barra da Tijuca")
        #createRegion(newRegion)
        if request.method == 'POST':
            form = LoginForm(request.POST)
            if form.is_valid():
                print("a")
                print("b")
                post = form.cleaned_data
                username = post['Username']
                password = post['Password']

                user = authenticate(request, username=username, password=password)
                if user is not None:
                    print("Success")
                    login(request, user)
                    # Redirect to a success page.
                    return redirect('home')
                else:
                    print("Failed")

                    # Return an 'invalid login' error message.
                    ...
        else:
            form = LoginForm()

        return render(request, 'login.html', {'form': form})

def myLogout(request):
    logout(request)
    return redirect('myLogin')
#End Ajax example

def addressTest(request):

    if request.method == 'POST':
        print(request.POST["ship-address"])


        response_data = 'successful!'

        return render(request, 'Components/addressTest.html')
    else:
        return render(request, 'Components/addressTest.html')
     
    