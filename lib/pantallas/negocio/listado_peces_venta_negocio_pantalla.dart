import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/pantallas/negocio/agregar_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/editar_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/menu_negocio_drawer.dart';
import 'package:acuarium/pantallas/negocio/informacion_pez_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ListadoPecesVentaNegocioPantalla extends StatefulWidget {
  static const String id = 'ListadoPecesVentaNegocioPantalla';

 ListadoPecesVentaNegocioPantalla({Key? key}) : super(key: key);

  @override
   ListadoPecesVentaNegocioPantallaState createState() =>  ListadoPecesVentaNegocioPantallaState();
}



class  ListadoPecesVentaNegocioPantallaState extends State <ListadoPecesVentaNegocioPantalla> {
  TextEditingController _searchController= new TextEditingController();
  List<PezVenta> _items=[];
  List<PezVenta> _filterItems=[];
  static final String _title ='Peces en venta';
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
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(_title),
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
  stream: Firestore.listaPecesVenta(uid: Auth.getUserId()!),
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
          _items.add(PezVenta.fromSnapshot(element));
        });
        
        return _listBuilder(_items);
  });

}

  _listBuilder(List<PezVenta> items){
   return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:12.0),
              itemBuilder: (context, position){
                return 
                 Tarjeta(contenido: _cardBody(items[position]),color:Colors.white);
              }
              );
}


  _cardBody(PezVenta pez){
   return Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(    
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: pez.getCardImgs()
                          )
                          ]
                    ),
                      Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('${pez.getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('Precio: ${pez.getPrecio}l',
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          
                        onTap: () =>_see(context,pez),
                        )
                        ),
                        IconButton(
                          onPressed: ()=>{
                            Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Eliminar ${pez.getNombre}?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: (){
                                                        Navigator.pop(context);
                                                        _confirmaEliminacion(pez);
                                                        },),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ])
                                            },
                          icon: Icon(Icons.delete, color: Colors.blueGrey)),
                        IconButton(
                          onPressed: () =>{_edit(context, pez)}, 
                          icon: Icon(Icons.edit, color: Colors.blueAccent)),

                        ]
                        ),

                    ],
                  );


 }

  _confirmaEliminacion(PezVenta p){
  var res = Firestore.eliminaPezVenta(did: p.getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Eliminando ${p.getNombre}'),
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

  _new(BuildContext context) {
    Navigator.pushNamed(context, AgregarPezPantalla.id);
  }

  _see(BuildContext context, PezVenta p) {
    Navigator.pushNamed(context, InformacionPezPantalla.id,arguments:p);
  }

  _edit(BuildContext context, PezVenta p) {
    Navigator.pushNamed(context, EditarPezPantalla.id,arguments:p);
  }
}