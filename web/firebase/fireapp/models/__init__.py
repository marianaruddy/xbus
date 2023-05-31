import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

from .currentTrip import *
from .currentTripModel import *
from .driver import *
from .driverModel import *
from .region import *
from .regionModel import *
from .reportRoute import *
from .reportRouteModel import *
from .route import *
from .routeModel import *
from .routeStops import *
from .routeStopsModel import *
from .stop import *
from .stopModel import *
from .ticket import *
from .trip import *
from .tripModel import *
from .vehicle import *
from .vehicleModel import *
