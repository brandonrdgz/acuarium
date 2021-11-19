import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FishList extends StatefulWidget {
  final String idTanque;
  const FishList({ Key? key ,required this.idTanque}) : super(key: key);

  @override
  _FishListState createState() => _FishListState();
}

class _FishListState extends State<FishList> {
  List<PezDeTanque> _items=[];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
          _listFromStream()      
    );
  }

  _listBuilder(List<PezDeTanque> items){
   return Column(
     children: [
      IconLabel(icon: Icon(FontAwesomeIcons.fish, color: Colors.blueAccent), text: ' Peces'),
     Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: 
              ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:5.0),
              itemBuilder: (context, position){
                return Tarjeta(color:Colors.white,
                  contenido:Column(
                  children:<Widget> [
                    Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('${items[position].getNombre}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Text('${items[position].getNumero}',
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
                        )
                        ),
                    ],)
                  ],
                ));
              }
              )
          ),
        ),]),

     TextLabel(label: 'Total Especies', text: '${items.length}'),
              ]);
}

  _view(int i){
    switch(i){
      case 1:
        return Column(
            children: [
              IconLabel(icon: Icon(FontAwesomeIcons.fish, color: Colors.blueAccent), text: ' Peces'),
              InfoView(type: InfoView.ERROR_VIEW, context: context,msg: 'Ocurrio un error'),
            ]);
      case 2:
        return Column(
            children: [
                IconLabel(icon: Icon(FontAwesomeIcons.fish, color: Colors.blueAccent), text: ' Peces'),
                InfoView(type: InfoView.LOADING_VIEW, context: context,),
            ]);
      case 3:
        return Column(
            children: [
                IconLabel(icon: Icon(FontAwesomeIcons.fish, color: Colors.blueAccent), text: ' Peces'),
                InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'Sin datos'),
            ]);
    }

  }


  _listFromStream(){
  return  StreamBuilder(
  stream: Firestore.listaPecesTanque(uid: Auth.getUserId()!,tid: widget.idTanque),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _view(1);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _view(2);
        }

        if (snapshot.data!.docs.isEmpty) {
          return _view(3);
        }

        _items.clear();
        snapshot.data!.docs.forEach((element) {
          _items.add(PezDeTanque.fromSnapshot(element));
        });
        return _listBuilder(_items);
  });

}
}