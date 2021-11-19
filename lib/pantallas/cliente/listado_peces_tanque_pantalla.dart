import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/modelos/tanque.dart';
import 'package:acuarium/pantallas/cliente/agregar_pez_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_pez_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_pez_tanque_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PecesTanque extends StatefulWidget {
  static const String id = 'PecesTanque';
  PecesTanque({Key? key}) : super(key: key);

  @override
  _PecesTanqueState createState() => _PecesTanqueState();
}

class _PecesTanqueState extends State<PecesTanque> {
  late Tanque _tanque ;
  TextEditingController _searchController= new TextEditingController();
  List<PezDeTanque> _items=[];
  List<PezDeTanque> _filterItems=[];
  bool _isSearching=false;

    @override
  void initState() {
      super.initState();
  }


@override
  void dispose(){
    super.dispose();
    _searchController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    _tanque = ModalRoute.of(context)!.settings.arguments as Tanque;
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('${_tanque.getNombre}:Peces'),
          backgroundColor: Colors.blueAccent,
      ),
      body: Column(children: [
            _searchField(),
            Divider(),
            Flexible(
              child: _isSearching?_listFromFilter():_listFromStream()  
              )
            ],
          ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => _new(context, _tanque),
        tooltip: 'Nuevo',
        child: const Icon(Icons.add),
      ),
    ));
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
                      controller: _searchController,
                      prefixIcon:Icons.search,
                      keyboardType: TextInputType.text,
                      onChanged: (string) {
                          setState(() {
                            _searchController.text.isNotEmpty?_isSearching=true:_isSearching=false;
                            if(_isSearching){
                              _filterItems.clear();
                              _items.forEach((element) {
                                if(element.getNombre.startsWith(_searchController.text)){
                                  _filterItems.add(element);
                                }
                               });
                          }
                        });
                      }
                    ),
                    )
                  ]);               
}
  _listFromFilter(){
        if (_filterItems.length==0) {
          return InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'Sin resultados');
        }else{
          return _listBuilder(_filterItems);
        }
        
  }
  _listFromStream(){
  return  StreamBuilder(
  stream: Firestore.listaPecesTanque(uid: Auth.getUserId()!,tid: _tanque.getId),
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
          _items.add(PezDeTanque.fromSnapshot(element));
        });
        
        return _listBuilder(_items);
  });

}

  _listBuilder(List<PezDeTanque> items){
   return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:12.0),
              itemBuilder: (context, position){
                return Tarjeta(
                  color: Colors.white,
                  contenido: 
                  Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(    
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: CachedNetworkImage(
                              imageUrl: items[position].getImagen['imgUrl'],
                              placeholder: (context, url) => new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                            )
                          )
                          ]
                    ),
                      Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('${items[position].getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('Número: ${items[position].getNumero}',
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          
                        onTap: () =>_see(context,items[position]),
                        ),
                        ),
                      IconButton(
                          onPressed: ()=>{
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
                          onPressed: () =>{_edit(context, items[position])}, 
                          icon: Icon(Icons.edit, color: Colors.blueAccent)),

                        ]
                        ),

                    ],
                  ),
                );
              }
              );
}
   _confirmaEliminacion(PezDeTanque t){
  var res = Firestore.eliminaPezdeTanque(uid: Auth.getUserId()!, tid: _tanque.getId,pid:t.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Eliminando ${t.getNombre}'),
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

  _new(BuildContext context,Tanque item) {
    Navigator.pushNamed(context, NuevoPezTanque.id, arguments:item.getId);
  }

  _see(BuildContext context, PezDeTanque item) {
     Navigator.pushNamed(context, PezTanque.id,arguments:item);
  }

  _edit(BuildContext context, PezDeTanque item) {
     Navigator.pushNamed(context, EditarPezTanque.id,arguments:item);
  }
}