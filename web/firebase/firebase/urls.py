"""firebase URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from fireapp import views


urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.login, name='login'),
    path('home', views.home, name='home'),
    path('Reports/tickets', views.tickets, name='tickets'),
    path('Reports/routes', views.reportRoutes, name='reportRoutes'),
    path('Management/routes', views.managementRoutes, name='managementRoutes'),
    path('Management/routesAdd', views.managementRoutesAdd, name='managementRoutesAdd'),
    path('Management/routes/delete/<str:id>/', views.deleteRoute, name='deleteRoute'),
    path('Management/my-ajax-test/', views.myajaxtestview, name='ajax-test-view'),
    path('Management/routes/searchStops/', views.searchStops, name='searchStops'),
    path('Management/routes/createRoute/', views.createRoute, name='createRoute'),
    path('Management/stops', views.managementStops, name='managementStops'),
    path('Management/stopsAdd', views.managementStopsAdd, name='managementStopsAdd'),
    path('Management/stopsEdit/<str:id>', views.managementStopsEdit, name='managementStopsEdit'),
    path('Management/stops/delete/<str:id>/', views.deleteStop, name='deleteStop'),
    path('Management/vehicles', views.managementVehicles, name='managementVehicles'),
    path('Management/vehiclesAdd', views.managementVehiclesAdd, name='managementVehiclesAdd'),
    path('Management/vehiclesEdit/<str:id>', views.managementVehiclesEdit, name='managementVehiclesEdit'),
    path('Management/vehicles/delete/<str:id>/', views.deleteVehicle, name='deleteVehicle'),
    path('Management/regions', views.managementRegions, name='managementRegions'),
    path('Management/regionsAdd', views.managementRegionsAdd, name='managementRegionsAdd'),
    path('Management/regionsEdit/<str:id>', views.managementRegionsEdit, name='managementRegionsEdit'),
    path('Management/regions/delete/<str:id>/', views.deleteRegion, name='deleteRegion'),
    path('Management/drivers', views.managementDrivers, name='managementDrivers'),
    path('Management/driversAdd', views.managementDriversAdd, name='managementDriversAdd'),
    path('Management/driversEdit/<str:id>', views.managementDriversEdit, name='managementDriversEdit'),
    path('Management/drivers/delete/<str:id>/', views.deleteDriver, name='deleteDriver'),
    path('Management/trips', views.managementTrips, name='managementTrips'),
    path('Management/tripsAdd', views.managementTripsAdd, name='managementTripsAdd'),
    path('Management/tripsEdit/<str:id>', views.managementTripsEdit, name='managementTripsEdit'),
    path('Management/trips/delete/<str:id>/', views.deleteTrip, name='deleteTrip'),
]
