import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/pantallas/cliente/editar_direccion_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DireccionVista extends StatefulWidget {
  static const String id = 'Direccion';
  const DireccionVista({ Key? key, }) : super(key: key);

  @override
  _DireccionVistaState createState() => _DireccionVistaState();
}

class _DireccionVistaState extends State<DireccionVista> {
  late Direccion _direccion;
  late GoogleMapController _mapController;
  Set<Marker> _markers = Set();
  late LatLng _center;
  @override
  void initState() {
    super.initState();
   

  }
  init(){
    _direccion = ModalRoute.of(context)!.settings.arguments as Direccion;
     _center = LatLng(_direccion.getLat,_direccion.getLng);
    _markers.add(
              Marker(
                markerId: MarkerId(_direccion.getNombre),
                position: LatLng(_direccion.getLat,_direccion.getLng)
              )
            );
  }
  
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    init();
    return _dataFromStream();
  }
    _dataFromStream(){
    return StreamBuilder(
      stream: Firestore.datosDireccion(uid: Auth.getUserId()!, did: _direccion.getId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return _errorView('Error','Error al cargar lso datos');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingView('Cargando','Cargando Datos');
        }

        if (!snapshot.data!.exists){
          return _errorView('Sin datos','No se encontraron los datos');
        }

        if (snapshot.data!.data()!.length==0) {
          return _errorView('Sin datos','No se encontraron los datos');
        }

        _direccion=Direccion.fromSnapshot(snapshot.data!);
        return _dataDisplay();
  });
  }
    _body(){
      return SingleChildScrollView(
          child: Column(
            children: [  
                  IconLabel(icon: Icon(FontAwesomeIcons.infoCircle, color: Colors.blueAccent),
                            text: ' Datos'),
                  TextLabel(label:'Calle',text:_direccion.getCalle),
                  TextLabel(label:'Número', text:_direccion.getNumero),
                  TextLabel(label:'Código Postal',text: _direccion.getCodigoPostal),
                  TextLabel(label: 'Municipio', text:_direccion.getMunicipio),
                  TextLabel(label:'Estado', text:_direccion.getEstado),    
                   Divider(thickness: 2,),  
                   IconLabel(icon:Icon(FontAwesomeIcons.mapMarker, color: Colors.blueAccent),
                            text:' Posición'),  
                   SizedBox(height: 20,),
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
            ]
        ),
      );     
    }
     _loadingView(String titulo,String msgError){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(titulo),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: 
        InfoView(type: InfoView.LOADING_VIEW, context: context,)
            )
            );
  }
  _errorView(String titulo,String msgError){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(titulo),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child:InfoView(type: InfoView.ERROR_VIEW, context: context,msg: msgError,)
            )
            );
  }

  _dataDisplay(){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(_direccion.getNombre),
          backgroundColor: Colors.blueAccent,
      ),
      body: _body(),
      floatingActionButton: _getFAB(),
    );

  }
  
    Widget _getFAB() {
        return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Colors.blueAccent,
          visible: true,
          curve: Curves.bounceIn,
          children: [
                // FAB 1
                SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () { 
                  Navigator.pushNamed(context, EditarDireccion.id,arguments:_direccion); 
                 },
                label: 'Editar',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blueAccent),
                // FAB 2
                SpeedDialChild(
                child: Icon(Icons.delete, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () {
                    _eliminationDialog( _direccion.getNombre);
                },
                label: 'Eliminar',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor:  Colors.blueAccent)
          ],
        );
  }

  _eliminationDialog(String nombre){
                                                  Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${nombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: ()
                                                        {Navigator.pop(context);
                                                        _confirmaEliminacion();
                                                        },),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);
  }

  _confirmaEliminacion(){
  var res = Firestore.eliminaDireccion(uid: Auth.getUserId()!, rid: _direccion.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Eliminando ${_direccion.getNombre}'),
                          future: res, 
                          alTerminar: (resultado){
                                Fluttertoast.showToast(
                                msg: 'Datos Borrados',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.pop(context);
                          }, 
                          enError: (resultado){
                            Fluttertoast.showToast(
                                msg: 'Error: $resultado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                          }, );
  }


}



