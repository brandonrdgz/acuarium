import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/pantallas/cliente/editar_direccion_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DireccionVista extends StatefulWidget {
  static const String id = 'Direccion';
  const DireccionVista({ Key? key, }) : super(key: key);

  @override
  _DireccionVistaState createState() => _DireccionVistaState();
}

class _DireccionVistaState extends State<DireccionVista> {
  late final Direccion direccion;
  late GoogleMapController mapController;
  Set<Marker> _markers = Set();
  late LatLng _center;
  @override
  void initState() {
    super.initState();
   

  }
  init(){
    direccion = ModalRoute.of(context)!.settings.arguments as Direccion;
     _center = LatLng(direccion.getLat,direccion.getLng);
    _markers.add(
              Marker(
                markerId: MarkerId(direccion.getNombre),
                position: LatLng(direccion.getLat,direccion.getLng)
              )
            );
  }
  
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(direccion.getNombre),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [  
                  _iconLabel(Icon(FontAwesomeIcons.infoCircle, color: Colors.blueAccent),' Datos'),
                  _label('Calle', direccion.getCalle),
                  _label('Número', direccion.getNumero),
                  _label('Código Postal', direccion.getCodigoPostal),
                  _label('Municipio', direccion.getMunicipio),
                  _label('Estado', direccion.getEstado),    
                   Divider(thickness: 2,),  
                   _iconLabel(Icon(FontAwesomeIcons.mapMarker, color: Colors.blueAccent),' Posición'),  
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
      ),      
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
                  Navigator.pushNamed(context, EditarDireccion.id,arguments:direccion); 
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
                                              Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${direccion.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);
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
  _edit(BuildContext context, Direccion dir) async{
   //await Navigator.push(context, MaterialPageRoute(builder: (context) => DireccionNE(direccion:dir),));
  }

Row _iconLabel(Icon icon, String campo){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        child:icon,
      ),
      Flexible(
        child:
          Text("$campo: ",
                      style: TextStyle( fontWeight: FontWeight.bold, fontSize:20.0 ) 
              )
      ),
    ]
  );                  
}
Row _label(String campo,  val){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        child:
          Text("$campo:",
                      style: TextStyle( fontWeight: FontWeight.bold, fontSize:20.0 ) 
              ),
      ),
      Flexible(
        child:
          Text("$val",
                      style: TextStyle( fontWeight: FontWeight.normal, fontSize:18.0 ) 
              ),
      ),
    ]
  );                  
}
}

