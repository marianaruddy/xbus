from django import forms

from .models import RegionModel,Route,Vehicle,Region,Driver,Stop,Trip, RouteModel, ReportRoute

class LoginForm(forms.Form):
    Username = forms.CharField()
    Password = forms.CharField(widget=forms.PasswordInput())

class StopForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)
    RegionId = forms.ChoiceField(label='Region',choices=[], widget=forms.Select())

    def __init__(self, *args, **kwargs):
        self._allRegions = kwargs.pop('allRegions', None)
        super().__init__(*args,**kwargs)
        self.fields['RegionId'].choices = self._allRegions

    class Meta:
        model = Stop
        fields = ('Name', 'RegionId','Id',)
        widgets = {
            'Id': forms.HiddenInput(),
        }

class TripForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)
    RouteId = forms.ChoiceField(label='Route',choices=[], widget=forms.Select())

    def __init__(self, *args, **kwargs):
        self._allRoutes = kwargs.pop('allRoutes', None)
        self._disableRoute = kwargs.pop('disableRoute', False)
        super().__init__(*args,**kwargs)
        self.fields['RouteId'].choices = self._allRoutes
        self.fields['RouteId'].widget.attrs['disabled'] = self._disableRoute
        self.fields['RouteId'].required = False if self._disableRoute else True

        

    class Meta:
        model = Trip
        fields = ('RouteId','IntendedDepartureTime','CapacityInVehicle','Id',)
        labels = {
            'IntendedDepartureTime': 'Intended Departure',
            'CapacityInVehicle': 'Capacity In Vehicle',
        }
        widgets = {
            'IntendedDepartureTime': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            'Id': forms.HiddenInput(attrs={'required':False}),
        }

class VehicleForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)

    class Meta:
        model = Vehicle
        fields = ('LicensePlate','Capacity','Id',)
        labels = {
            'LicensePlate': 'License Plate',
        }
        widgets = {
            'Id': forms.HiddenInput(),
        }

class RegionForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)

    class Meta:
        model = Region
        fields = ('Name','Id',)
        widgets = {
            'Id': forms.HiddenInput(),
        }

class DriverForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)

    class Meta:
        model = Driver
        fields = ('Name','Company','Document','Email','Id',)
        widgets = {
            'Id': forms.HiddenInput(),
        }

class RouteForm(forms.ModelForm):
    class Meta:
        model = Route
        fields = ('Price',)

class ReportRouteForm(forms.ModelForm):
    RouteId = forms.ChoiceField(label='Route',choices=[], widget=forms.Select())

    def __init__(self, *args, **kwargs):
        self._allRoutes = kwargs.pop('allRoutes', None)
        super().__init__(*args,**kwargs)
        self.fields['RouteId'].choices = self._allRoutes

    class Meta:
        model = ReportRoute
        fields = ('RouteId','Date',)
        widgets = {
            'Date': forms.DateInput(attrs={'type': 'date'}),
        }

class ReportTicketForm(forms.Form):
    StartDate = forms.DateField(label='Start Date', widget=forms.DateInput(attrs={'type': 'date'}))
    EndDate = forms.DateField(label='End Date', widget=forms.DateInput(attrs={'type': 'date'}))

class ReportRegionsForm(forms.Form):
    RouteId = forms.ChoiceField(label='Route',choices=[], widget=forms.Select())
    Date = forms.DateField(label='Date', widget=forms.DateInput(attrs={'type': 'date'}))

    def __init__(self, *args, **kwargs):
        self._allRoutes = kwargs.pop('allRoutes', None)
        super().__init__(*args,**kwargs)
        self.fields['RouteId'].choices = self._allRoutes
