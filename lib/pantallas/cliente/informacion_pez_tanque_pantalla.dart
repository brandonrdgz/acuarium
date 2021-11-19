import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/pantallas/cliente/editar_pez_tanque_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PezTanque extends StatefulWidget {
  static const String id = 'PezTanque';
  const PezTanque({ Key? key}) : super(key: key);

  @override
  _PezTanqueState createState() => _PezTanqueState();
}

class _PezTanqueState extends State<PezTanque> {
  late PezDeTanque _pez;


   @override
  void initState() {
      super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    _pez = ModalRoute.of(context)!.settings.arguments as PezDeTanque;
    return SafeArea(
      child: _dataFromStream()
    );
  }

  _dataFromStream(){
    return StreamBuilder(
      stream: Firestore.datosPezdeTanque(uid: Auth.getUserId()!, tid: _pez.getIdTanque,pid: _pez.getId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return _errorView('Error','Error al cargar los datos');
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

        _pez=PezDeTanque.fromSnapshot(snapshot.data!);
        return _dataDisplay(_pez);
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

  _dataDisplay(PezDeTanque pez){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(pez.getNombre),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [       
            CachedNetworkImage(
              imageUrl: pez.getImagen['imgUrl']!,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                  Divider(thickness: 2.0,),
                  IconLabel(icon:Icon(FontAwesomeIcons.infoCircle, color: Colors.blueAccent),text: ' Datos'),
                  TextLabel(label: 'Especie',text: '${pez.getNombre}'),
                  TextLabel(label: 'Número',text: '${pez.getNumero}'),
                  Divider(thickness: 2.0,),
                  IconLabel(icon:Icon(FontAwesomeIcons.leaf, color: Colors.blueAccent),text: ' Cuidados'),                          
                  Row(
                    children: [
                      Expanded(child: 
                          Text("${pez.getCuidados}",
                                style: TextStyle( fontWeight: FontWeight.normal, fontSize:16.0,),
                                textAlign: TextAlign.justify, 
                                )
                      ,),
                    ],
                  )
                            ,

                  ],
                ),
              )

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
                onTap: () { Navigator.pushNamed(context, EditarPezTanque.id,arguments:_pez);},
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
                                          contenido: Text('¿Eliminar ${_pez.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: (){
                                                        Navigator.pop(context);
                                                        _confirmaEliminacion(_pez);
                                                        },),
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

    _confirmaEliminacion(PezDeTanque p){
  var res = Firestore.eliminaPezdeTanque(uid: Auth.getUserId()!, tid: p.getIdTanque,pid: p.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Eliminando ${p.getNombre}'),
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




}