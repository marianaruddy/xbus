from django.shortcuts import render,redirect
from ..models import Ticket
from ..forms import ReportTicketForm
from datetime import datetime, date, timedelta
import json
from django.core.serializers.json import DjangoJSONEncoder

def reportTicket(request):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        form = ReportTicketForm(request.POST)
        if form.is_valid():
            ticket = Ticket()
            post = form.cleaned_data
            startDate = datetime(post["StartDate"].year, post["StartDate"].month, post["StartDate"].day)
            currentDate = startDate
            endDate = datetime(post["EndDate"].year, post["EndDate"].month, post["EndDate"].day)
            report = {}
            while currentDate <= endDate:
                date_time = currentDate.strftime("%Y-%m-%d").replace("'",'"')
                report[date_time] = ticket.getQuantityOfTicketsGeneratedByPeriod(currentDate, currentDate + timedelta(days=1))
                currentDate = currentDate + timedelta(days=1)

            form = ReportTicketForm()
            return render(request, 'Reports/tickets.html', {'form': form, 'report': json.dumps(report), 'startDate': startDate, 'endDate': endDate})
        else:
            form = ReportTicketForm()
    else:
        form = ReportTicketForm()
    return render(request, 'Reports/tickets.html', {'form': form})