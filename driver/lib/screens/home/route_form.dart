import 'package:driver/models/route.dart';
import 'package:driver/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver/shared/constants.dart';

class RouteForm extends StatefulWidget {
  const RouteForm({super.key});

  @override
  State<RouteForm> createState() => _RouteFormState();
}

class _RouteFormState extends State<RouteForm> {
  @override
  Widget build(BuildContext context) {

    final routes = Provider.of<List<RouteModel>?>(context);

    final licensePlates = Provider.of<List<Vehicle>?>(context);
  
    final _formKey = GlobalKey<FormState>();
  
    String? currentRoute;

    String? currentLicensePlate;

    return Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  routes!.length > 0 ? DropdownButtonFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Selecione uma rota'),
                    value: currentRoute,
                    items: routes.map((route) {
                      return DropdownMenuItem(
                        value: route,
                        child: Text('Linha ${route.number.toString()}: ${route.origin} - ${route.destiny}'),
                      );
                    }).toList(), 
                    onChanged: (value) { setState(() => currentRoute = value as String? ); },
                  ) : 
                  Text('Nenhuma rota cadastrada'),
                  SizedBox(height: 20.0),
                  licensePlates!.length > 0 ? DropdownButtonFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Selecione um veículo'),
                    value: currentLicensePlate,
                    items: licensePlates?.map((license) {
                      return DropdownMenuItem(
                        value: license.licensePlate,
                        child: Text(license.licensePlate.toString()),
                      );
                    }).toList(), 
                    onChanged: (value) { setState(() => currentLicensePlate = value as String?); },
                  ) : 
                  Text('Nenhum veículo cadastrado'),
                  SizedBox(height: 20.0),
    
                  // TODO: add google maps integration
    
                  // // TODO: image not working
                  // Image.asset(
                  //   'assets/map.png',
                  //   fit: BoxFit.contain,
                  // ),
    
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('Iniciar Viagem'),
                  )
                ],
              ),
            ),);
  }
}