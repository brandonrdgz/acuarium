
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/fish_list.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/module_reader.dart';
import 'package:acuarium/modelos/tanque.dart';
import 'package:acuarium/pantallas/cliente/editar_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_peces_tanque_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TanqueVista extends StatefulWidget {
  static const String id = 'vistaTanque';
  const TanqueVista({ Key? key }) : super(key: key);

  @override
  _TanqueVistaState createState() => _TanqueVistaState();
}

class _TanqueVistaState extends State<TanqueVista> {
 late Tanque _tanque ;
  
  TextEditingController _moduloCont = new TextEditingController();

      @override
  void initState() {
    
    super.initState();
    
  }

  _dataFromStream(){
    return StreamBuilder(
      stream: Firestore.datosTanque(uid: Auth.getUserId()!, tid: _tanque.getId),
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

        _tanque=Tanque.fromSnapshot(snapshot.data!);
        return _dataDisplay(_tanque);
  });
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

  _dataDisplay(Tanque tanque){
    _moduloCont.text=tanque.getIdModulo;
    return       Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('${tanque.getNombre}'),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [  
              SizedBox(height: 20,),
                  CarouselSlider(
                    options: CarouselOptions(height: 200.0,autoPlay: true),
                    items: tanque.getGaleriaImgs(),
                  ),  
                      Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [

                  IconLabel(icon:Icon(FontAwesomeIcons.infoCircle, color: Colors.blueAccent),text: ' Datos'),
                  TextLabel(label: 'Alto',text: '${tanque.getAlto}cm'),
                  TextLabel(label: 'Ancho',text: '${tanque.getAncho}cm'),
                  TextLabel(label: 'Profundo',text: '${tanque.getProfundo}cm'),
                  TextLabel(label:'Litros', text:'${tanque.getLitros}l'),
                  TextLabel(label:'Temperatura ideal',text:'${tanque.getTemperaturaMin}° c-${tanque.getTemperaturaMax}° c'),
                  TextLabel(label:'Luminocidad ideal',text:'${tanque.getLuminocidadMin}l-${tanque.getLuminocidadMax}l'),
                  TextLabel(label:'Fecha Montaje', text:tanque.getFechaMontaje),                  
                  Divider(thickness: 2.0,),
                  ModuleReader(moduloCont: _moduloCont,
                              readAv: false,
                              tempMax: tanque.getTemperaturaMax,
                              tempMin: tanque.getTemperaturaMin,
                              lumMax: tanque.getLuminocidadMax,
                              lumMin: tanque.getLuminocidadMin,),
                  Divider(thickness: 2.0,),
                  FishList(idTanque: tanque.getId),

                  ],
                ),
              ) 

            ]
        ),
      ),      
      floatingActionButton: _getFAB(),
    );
    

  }
  
  @override
  Widget build(BuildContext context) {

    _tanque = ModalRoute.of(context)!.settings.arguments as Tanque;
    
    return SafeArea(
      child: _dataFromStream()
    );
  }

  _confirmaEliminacion(Tanque t){
  var res = Firestore.eliminaTanque(uid: Auth.getUserId()!, rid: t.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Eliminando ${t.getNombre}'),
                          future: res, 
                          alTerminar: (resultado){                                
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                msg: 'Datos Borrados',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
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
                onTap: () { Navigator.pushNamed(context, TanqueEditar.id,arguments:_tanque); },
                label: 'Editar tanque',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blueAccent),
              SpeedDialChild(
                child: Icon(Icons.delete, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () { 
                                        Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${_tanque.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: (){
                                                        Navigator.pop(context);
                                                        _confirmaEliminacion(_tanque);
                                                        },),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);
                 },
                label: 'Eliminar tanque',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blueAccent),
                // FAB 2
                SpeedDialChild(
                child: Icon(FontAwesomeIcons.leaf, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                onTap: () {
                  Navigator.pushNamed(context, PecesTanque.id,arguments:_tanque); 
                },
                label: 'Administrar peces',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor:  Colors.blueAccent)
          ],
        );
  }

 
}