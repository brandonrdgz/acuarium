import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatosDireccion extends StatefulWidget {
  final String idDir;
  final String idCliente;
  const DatosDireccion({ Key? key ,required this.idDir,required this.idCliente}) : super(key: key);

  @override
  _DatosDireccionState createState() => _DatosDireccionState();
}

class _DatosDireccionState extends State<DatosDireccion> {
  late Direccion _direccion;
  late GoogleMapController _mapController;
  Set<Marker> _markers = Set();
  late LatLng _center;


  @override
  Widget build(BuildContext context) {
    return _dataFromStream();
  }

      _dataFromStream(){
    return StreamBuilder(
      stream: Firestore.datosDireccion(uid:widget.idCliente, did: widget.idDir),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return InfoView(type: InfoView.ERROR_VIEW, context: context,msg: 'Error al cargar los datos');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return InfoView(type: InfoView.LOADING_VIEW, context: context, );
        }

        if (!snapshot.data!.exists){
          return InfoView(type: InfoView.ERROR_VIEW, context: context,msg:'No se encontraron los datos');
        }

        if (snapshot.data!.data()!.length==0) {
          return InfoView(type: InfoView.ERROR_VIEW, context: context,msg:'No se encontraron los datos');
        }

        try{
        _mapController.dispose();
        }catch(e){

        }
        _direccion=Direccion.fromSnapshot(snapshot.data!);
        _center = LatLng(_direccion.getLat,_direccion.getLng);
        _markers.add(
                  Marker(
                    markerId: MarkerId(_direccion.getNombre),
                    position: LatLng(_direccion.getLat,_direccion.getLng)
                  )
                );
        return _dataDisplay();
  });
  }
  _dataDisplay() {
    return ListTile(
                          title: Text('Dirección de entrega',),
                          subtitle: Text('${_direccion.getNombre} : ${_direccion.getCalle}, ${_direccion.getMunicipio} ${_direccion.getEstado}',),
                          leading:  Icon(FontAwesomeIcons.mapMarkedAlt,color: Colors.blue),
                          onTap: (){
                                Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('${_direccion.getNombre}'),
                                          contenido: 
                                          SizedBox(
                                          width: MediaQuery.of(context).size.width, // or use fixed size like 200
                                          height: MediaQuery.of(context).size.height/1.6,
                                          child: GoogleMap(
                                          onMapCreated: _onMapCreated,
                                          markers: _markers,
                                          initialCameraPosition: CameraPosition(
                                            target: _center,            
                                            zoom: 15.0,
                                          ),
                                      )
                                      ),
                                       acciones: [
                                          ]);
                          },                       
                        );
}
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
}

