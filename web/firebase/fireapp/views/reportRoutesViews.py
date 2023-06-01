from django.shortcuts import render,redirect
from ..models import ReportRouteModel
from ..forms import ReportRouteForm
from datetime import datetime

def reportRoutes(request):
    if request.method == "POST":
        form = ReportRouteForm(request.POST)
        if form.is_valid():
            reportRouteModel = ReportRouteModel()
            post = form.save(commit=False)
            date = datetime(post.Date.year, post.Date.month, post.Date.day)
            report = reportRouteModel.getReportRoute(post.RouteId, date)
            form = ReportRouteForm()
            return render(request, 'Reports/routes.html', {'form': form, 'report': report})
        else:
            form = ReportRouteForm()
    else:
        form = ReportRouteForm()
    return render(request, 'Reports/routes.html', {'form': form})