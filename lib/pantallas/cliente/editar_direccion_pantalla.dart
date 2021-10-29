import 'package:acuarium/componentes/control_estado_municipio.dart';
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditarDireccion extends StatefulWidget {
  static const String id = 'EditarDireccion';
  const EditarDireccion({ Key? key}) : super(key: key);

  @override
  _EditarDireccionState createState() => _EditarDireccionState();
}

class _EditarDireccionState extends State<EditarDireccion> with TickerProviderStateMixin {
  TextEditingController _nombreCont = new TextEditingController();
  TextEditingController _calleCont = new TextEditingController();
  TextEditingController _numeroCont = new TextEditingController();
  TextEditingController _codigoPostalCont = new TextEditingController();
  TextEditingController _municipioCont = new TextEditingController();
  TextEditingController _estadoCont = new TextEditingController();
  late  Direccion _direccion;
  final String _titulo = 'Editando'; 
  final _formKey = GlobalKey<FormState>();
  late GoogleMapController _mapController;
  Set<Marker> _markers = Set();
  late LatLng _center;
  bool _positionLoaded=false;
  bool _direccionRecuperada=false;

  init(){
    if(!_direccionRecuperada){
    _direccion = ModalRoute.of(context)!.settings.arguments as Direccion;
    _center = LatLng(_direccion.getLat,_direccion.getLng);
    _markers.add(
              Marker(
                markerId: MarkerId(_direccion.getNombre),
                position: LatLng(_direccion.getLat,_direccion.getLng)
              )
            );
    _positionLoaded=true;
    _nombreCont.text=_direccion.getNombre;
    _calleCont.text=_direccion.getCalle;
    _numeroCont.text=_direccion.getNumero;
    _codigoPostalCont.text=_direccion.getCodigoPostal;
    _estadoCont.text= _direccion.getEstado;
    _municipioCont.text=_direccion.getMunicipio;
    _direccionRecuperada=true;
    }
  }
  @override
  void initState() {
    super.initState();
    
    
    
  }

  @override
  void dispose(){
    super.dispose();

  }

_position() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  var position = await Geolocator.getCurrentPosition();
  setState(() {
    _center = LatLng(position.latitude,position.longitude);
    _markers.add(
              Marker(
                markerId: MarkerId("Nueva Diseccion"),
                position: LatLng(position.latitude,position.longitude)
              )
            );
            _positionLoaded=true;
  });
}
_update() async {
   GeoPoint geoPoint = new GeoPoint(_center.latitude, _center.longitude); 
  var datos = Direccion.toMapFromControl(Auth.getUserId()!, 
                                        _nombreCont,
                                        _calleCont,
                                        _numeroCont, 
                                        _codigoPostalCont,
                                        _municipioCont, 
                                        _estadoCont, 
                                        geoPoint);
  var res = Firestore.actualizaDireccion(uid: Auth.getUserId()!, rid: _direccion.getId, datos: datos);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Actualizando ${_nombreCont.text}'),
                          future: res, 
                          alTerminar: (resultado){
                                Fluttertoast.showToast(
                                msg: 'Datos guardados',
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

  @override
  Widget build(BuildContext context) {
    init();
   return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('$_titulo ${_direccion.getNombre}'),
          backgroundColor: Colors.blueAccent,
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{_validaFormulario()},
        tooltip: 'Guardar',
        child: const Icon(Icons.save),
      ),
    );
  
  }
  _validaFormulario(){
    if(_formKey.currentState!.validate()){
      _updateDialog();
    }else{
      Fluttertoast.showToast(
                msg: 'Datos no validos',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
    }
  }
    _updateDialog()async{
      Dialogo.dialogo(
        context,                                     
        titulo:Text('Atención'),
        contenido: Text('¿Actualizar ${_nombreCont.text}?'),
        acciones: [
        IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                  onPressed: (){
                    Navigator.pop(context);
                    _update();
                    },),
        IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                  onPressed: ()=>{Navigator.pop(context)},),
        ]);
  }
  _body(){
    return SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
          child: Center(
            child:Form(
              key:_formKey,
            child: Column(
              children: <Widget>[
                _formField('Nombre', _nombreCont,TextInputType.name,Icons.home),
                _formField('Calle', _calleCont,TextInputType.name,Icons.horizontal_distribute),
                _formField('Número', _numeroCont,TextInputType.number,Icons.tag_sharp),
                _formField('Código Postal', _codigoPostalCont,TextInputType.number,Icons.mail),
                EstadoMunicipoInput(estadoCont:_estadoCont,municipioCont:_municipioCont),
                Divider(),
                _controlUbicacion(),
              ]
            )
            )
          )
      );
  }

    _controlUbicacion(){
      return    Tarjeta(color: Colors.white,
                        contenido: Container(
                          child:Column(
                            children: [
                              ElevatedButton(
                              child: const Text(
                                'Cambiar Posición',
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade200),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)
                                  )
                                ),
                              ),
                              onPressed: (){
                              }
                            ),
                SizedBox(height: 20,),
                _positionLoaded?
                SizedBox(
                    width: MediaQuery.of(context).size.width, // or use fixed size like 200
                    height: MediaQuery.of(context).size.height/1.5,
                    child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                      target: _center,            
                      zoom: 15.0,
                    ),
                )
                )
                :SizedBox(
                    width: MediaQuery.of(context).size.width, // or use fixed size like 200
                    height: MediaQuery.of(context).size.height/1.5,
                    child: Text('Determinando Ubicación')
                )
                            ],
                          ) 
                          ,)
                          ,);
            
    }

    void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _formField(String nombre,TextEditingController controller,TextInputType type,IconData icon ){
    return RoundedIconTextFormField(
                  controller: controller,
                  validator: (val) => val!.isEmpty ? nombre+' vacio':null,
                  labelText: nombre,
                  prefixIcon: icon,
                  keyboardType: type
                );
  }

  _positonPicker() async {
    /*
    LocationResult result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyCEeAztfspyIcjmz2bwsp8ip_y2kz_TTm8",
                        displayLocation: _center,
                        )));

    // Handle the result in your way
    setState(() {
      _center = LatLng(result.latLng!.latitude,result.latLng!.latitude);
    });*/
}
}

