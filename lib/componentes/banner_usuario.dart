import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DatosCliente extends StatefulWidget {
  final String uid;
  const DatosCliente({ Key? key, required this.uid }) : super(key: key);

  @override
  _DatosClienteState createState() => _DatosClienteState();
}

class _DatosClienteState extends State<DatosCliente> {


  @override
  Widget build(BuildContext context) {

    return _dataFromStream();
  }

    _dataFromStream(){   
    return StreamBuilder(
      stream: Firestore.datosUsuario(uid:widget.uid),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
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



        return _dataDisplay(snapshot.data!);
  });
  }
  _dataDisplay(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    
    return ListTile(
                          title: Text('Cliente'),
                          subtitle: 
                            Text('${snapshot.get('nombre')} \n ${snapshot.get('correo')}'),
                       
                          leading:  Icon(FontAwesomeIcons.user, color:Colors.blue)          
                        );
}
 
}