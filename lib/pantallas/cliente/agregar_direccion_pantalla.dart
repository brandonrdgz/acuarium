import 'package:acuarium/componentes/control_estado_municipio.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NuevaDireccion extends StatefulWidget {
  static const String id = 'NuevaDireccion';
  const NuevaDireccion({ Key? key  }) : super(key: key);

  @override
  _NuevaDireccionState createState() => _NuevaDireccionState();
}

class _NuevaDireccionState extends State<NuevaDireccion> with TickerProviderStateMixin {
  TextEditingController nombreCont = new TextEditingController();
  TextEditingController calleCont = new TextEditingController();
  TextEditingController numeroCont = new TextEditingController();
  TextEditingController codigoPostalCont = new TextEditingController();
  TextEditingController municipioCont = new TextEditingController();
  TextEditingController estadoCont = new TextEditingController();
  //final CouldFireStoreService _db= CouldFireStoreService();
  final _formKey = GlobalKey<FormState>();
  late GoogleMapController mapController;
  Set<Marker> _markers = Set();
  late LatLng _center;
  bool positionLoaded=false;
  static const String _uid='UE6kbvXbLpFWCVBSzsF2';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();       
  }

  @override
  void dispose(){
    super.dispose();

  }

_determinePosition() async {
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
            positionLoaded=true;
  });
}

_saveNew() async {
  /*
  GeoPoint geoPoint = new GeoPoint(_center.latitude, _center.longitude); 
  var data = Direccion.toMapFromControl(_uid, nombreCont, calleCont, numeroCont, codigoPostalCont, municipioCont, estadoCont, geoPoint);
  var res = await _db.newDireccion(_uid,data);
    Fluttertoast.showToast(
        msg: res['mensaje'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: res['estado']==0?Colors.blue:Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    if(res['estado']==0){
      Navigator.pop(context);
    }*/
}
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('Nueva Dirección'),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
          child: Center(
            child:Form(
              key:_formKey,
            child: Column(
              children: <Widget>[
                _formField('Nombre', nombreCont,TextInputType.name,Icons.home),
                _formField('Calle', calleCont,TextInputType.name,Icons.horizontal_distribute),
                _formField('Número', numeroCont,TextInputType.number,Icons.tag_sharp),
                _formField('Código Postal', codigoPostalCont,TextInputType.number,Icons.mail),
                EstadoMunicipoInput(estadoCont:estadoCont,municipioCont:municipioCont),
                Divider(),
                                      ElevatedButton(
                        child: const Text(
                          'Posición',
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
                positionLoaded?
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
            ):
                Text('Determinando Ubicacion'),

              ]
            )
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async => {
          if(_formKey.currentState!.validate()){
                  //await confirmationDialog(()async=>{await _saveNew()},'Confirmación','¿Guardar dirección ${nombreCont.text}?',context)
              
          }else{
            /*Fluttertoast.showToast(
                msg: 'Datos no validos',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            )*/
          }
        },
        tooltip: 'Guardar',
        child: const Icon(Icons.save),
      ),
    );
  
  }

    void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

