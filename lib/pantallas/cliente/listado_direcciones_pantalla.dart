import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/pantallas/cliente/agregar_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DireccionesLista extends StatefulWidget {
  static const String id = 'Direcciones';
  const DireccionesLista({ Key? key }) : super(key: key);

  @override
  _DireccionesListaState createState() => _DireccionesListaState();
}

class _DireccionesListaState extends State<DireccionesLista> with TickerProviderStateMixin {
  static const String _titulo = 'Direcciónes';
  List<Direccion> _items=[]; 
  List<Direccion> _filterItems=[];  
  late TextEditingController _searchControler;
  bool _isSearching =false;

  
  @override
  void initState() {
      super.initState();
      _searchControler= new TextEditingController();
  }
@override
  void dispose(){
    super.dispose();
    _searchControler.dispose();

  }

  _searchField(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: 
                    RoundedIconTextFormField(
                      validator: (val) => val!.isEmpty ?' vacio':null,
                      labelText: 'Búsqueda',
                      controller: _searchControler,
                      prefixIcon:Icons.search,
                      keyboardType: TextInputType.text,
                      onChanged: (string) {
                          setState(() {
                            _searchControler.text.isNotEmpty?_isSearching=true:_isSearching=false;
                            if(_isSearching){
                              _filterItems.clear();
                              _items.forEach((element) {
                                if(element.getNombre.startsWith(_searchControler.text)){
                                  _filterItems.add(element);
                                }
                               });
                            }

                          });
                        },
                    ),
                    )
                  ]);               
}

  _listFromStream(){
  return  StreamBuilder(
  stream: Firestore.listaDirecciones(uid: Auth.getUserId()!),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return InfoView(type: InfoView.ERROR_VIEW, context: context,msg: 'Ocurrio un error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return InfoView(type: InfoView.LOADING_VIEW, context: context,);
        }

        if (snapshot.data!.docs.isEmpty) {
          return InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'Sin datos');
        }

        _items.clear();
        snapshot.data!.docs.forEach((element) {
          _items.add(Direccion.fromSnapshot(element));
        });
        return _listBuilder(_items);
  });

}
  _listFromFilter(){
        if (_filterItems.length==0) {
          return InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'Sin resultados');
        }else{
          return _listBuilder(_filterItems);
        }
        
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
                          onTap: () =>_see(context,items[position]),
                        )
                        ),
                        IconButton(
                          onPressed: ()=> {
                            Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${items[position].getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        _confirmaEliminacion(items[position]);
                                                        },),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ])

                          },
                          icon: Icon(Icons.delete, color: Colors.blueGrey)),
                        IconButton(
                          onPressed: () =>_edit(context, items[position]), 
                          icon: Icon(Icons.edit, color: Colors.blueAccent)),

                    ],)
                  ],
                ));
              }
              );
}

   _see(BuildContext context, Direccion dir) async{
   Navigator.pushNamed(context, DireccionVista.id,arguments:dir); 
  }

  _edit(BuildContext context, Direccion dir) async{
   Navigator.pushNamed(context, EditarDireccion.id,arguments:dir); 
  }

  _new(BuildContext context) async{
   Navigator.pushNamed(context, NuevaDireccion.id,); 
  }

 _confirmaEliminacion(Direccion d){
  var res = Firestore.eliminaDireccion(uid: Auth.getUserId()!, rid: d.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Eliminando ${d.getNombre}'),
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(_titulo),
          backgroundColor: Colors.blueAccent,
      ),
      body: Column(children: [
            _searchField(),
            Divider(),
            Flexible(
              child:_isSearching?_listFromFilter():_listFromStream()
              )
            ],
          ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => _new(context),
        tooltip: 'Nuevo',
        child: const Icon(Icons.add),
      ),
    );
  }
}