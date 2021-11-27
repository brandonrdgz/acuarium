import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/pantallas/cliente/carrito_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_pez_venta_pantalla.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListadoPecesVentaClientePantalla extends StatefulWidget {
  static const String id = 'ListadoPecesVentaClientePantalla';
  ListadoPecesVentaClientePantalla({Key? key}) : super(key: key);

  @override
   ListadoPecesVentaClientePantallaState createState() =>  ListadoPecesVentaClientePantallaState();
}



class  ListadoPecesVentaClientePantallaState extends State <ListadoPecesVentaClientePantalla> {
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
        onPressed: () => { 
          Navigator.pushNamed(context, CarritoPantalla.id)
        },
        tooltip: 'Carrito',
        child: const Icon(FontAwesomeIcons.shoppingCart),
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
  stream: Firestore.listaPecesVentaCliente(),
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
                        ]
                        ),

                    ],
                  );


 }



  _see(BuildContext context, PezVenta p) {
    Navigator.pushNamed(context, InformacionPezVentaPantalla.id,arguments:p);
  }


} 
