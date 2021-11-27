import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SeleccionDireccion extends StatefulWidget {
  final Direccion dir;
  SeleccionDireccion({ Key? key,required this.dir }) : super(key: key);

  @override
  _SeleccionDireccionState createState() => _SeleccionDireccionState();
}

class _SeleccionDireccionState extends State<SeleccionDireccion> {

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
            color: Colors.white,
            contenido: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _getTitle()
              ],
            ),
          );
  }

  _getTitle(){
    return widget.dir.getId.isEmpty?
                  ListTile(
                  leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 17.0,
                              child: Icon(FontAwesomeIcons.mapMarkedAlt,color: Colors.white),
                              ),
                          ],),
                  title: Text('No ha seleccionado ninguna dirección'),
                  subtitle: Text('Seleccionar'),
                  onTap: (){
                    _selectDialog();
                  },
                ):
                    ListTile(
                          title: Text('${widget.dir.getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('${widget.dir.getCalle}, ${widget.dir.getMunicipio} ${widget.dir.getEstado}',
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 17.0,
                              child: Icon(FontAwesomeIcons.mapMarkedAlt,color: Colors.white),
                              ),
                          ],),
                          onTap: () {
                            _selectDialog();
                          },
                        );
  }

  _selectDialog(){
         Dialogo.dialogo(
                        context,                                     
                        titulo:Text('Direcciones'),
                        contenido: SingleChildScrollView(
                        child:
                              Container(  
                                height: MediaQuery.of(context).size.height/2,                              
                                child:_direccionesFromStream(), 
                              )
                      ),
                        acciones: [
                          IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                          onPressed: ()=>{Navigator.pop(context)},),
                     ]);

 }

   _direccionesFromStream(){
    return StreamBuilder(
      stream: Firestore.listaDirecciones(uid: Auth.getUserId()!),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return InfoView(type: InfoView.ERROR_VIEW, context: context,msg: 'Ocurrio un error');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return InfoView(type: InfoView.LOADING_VIEW, context: context,);
            }

            if (snapshot.data!.docs.isEmpty) {
              return InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'No hay direcciones');
            }

            List<Direccion> _items=[];
            snapshot.data!.docs.forEach((element) {
              _items.add(Direccion.fromSnapshot(element));
            });
            
            return _listBuilder(_items);
          }
          );

  }




    _listBuilder(List<Direccion> items){
   return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:12.0),
              itemBuilder: (context, position){
                return Tarjeta(color:Colors.white,
                  contenido:Column(
                  children:<Widget> [
                    Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('${items[position].getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('${items[position].getCalle}, ${items[position].getMunicipio} ${items[position].getEstado}',
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 17.0,
                              child: Text('${position+1}',
                          style:TextStyle(color: Colors.white,fontSize: 21.0)),
                          )
                          ],),
                          onTap: (){
                            setState(() {
                            Direccion dir =  items[position];
                            widget.dir.setCalle=dir.getCalle;
                            widget.dir.setCodigoPostal=dir.getCodigoPostal;
                            widget.dir.setEstado=dir.getEstado;
                            widget.dir.setId=dir.getId;
                            widget.dir.setIdCliente=dir.getidCliente;
                            widget.dir.setLat=dir.getLat;
                            widget.dir.setLng=dir.getLng;
                            widget.dir.setMunicipio=dir.getMunicipio;
                            widget.dir.setNombre=dir.getNombre;
                            widget.dir.setNumero=dir.getNumero;
                            

                            Navigator.pop(context);                             
                            });

                          },
                        )
                        ),
                    ],)
                  ],
                ));
              }
              );
}
}