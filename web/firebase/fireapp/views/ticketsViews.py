from django.shortcuts import render
from ..models import Ticket

def tickets(request):
        ticket = Ticket()
        
        tickets = ticket.getAllTickets()
        context = {
              'tickets': tickets,
        }
        return render(request, 'tickets.html', context)