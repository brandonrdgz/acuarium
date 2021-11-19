import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/qr_reader.dart';
import 'package:acuarium/modelos/modulo.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';



class ModuleReader extends StatefulWidget {
  TextEditingController moduloCont;
  bool readAv;
  double? temp=0.0;
  double? lum=0.0;
  ModuleReader({Key? key, required this.moduloCont, required this.readAv,this.temp,this.lum}) : super(key: key);

  @override
  _ModuleReaderState createState() => _ModuleReaderState();
}

class _ModuleReaderState extends State<ModuleReader> {
  final String _noConected= "Moludo no vinculado";
  final String _conected="Modulo vinculado";
  final String _tempBaja=' Temperatura baja';
  final String _tempAlta=' Temperatura alta';
  final String _lumBaja=' Luminocidad baja';
  final String _lumAlta=' Luminocidad alta';
  final DateFormat _formatter = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(                      
                      children: [
                      Expanded(                                                    
                            child:  
                            widget.moduloCont.text.isEmpty? 
                            IconLabel(icon:Icon(FontAwesomeIcons.microchip, color: Colors.blueAccent),text:_noConected)                     
                            :
                            IconLabel(icon:Icon(FontAwesomeIcons.microchip, color: Colors.blueAccent),text:_conected),
                             )
                    ],),
                    widget.moduloCont.text.isNotEmpty?_dataFromStream(widget.moduloCont.text):Text(''),
                    widget.readAv?IconButton(
                                    tooltip: 'Vincular Modulo',
                                    onPressed: ()async=>{await _qr()},
                                    icon: Icon(Icons.qr_code_scanner,color: Colors.blueAccent),
                                    iconSize: MediaQuery.of(context).size.width/2,):
                                    SizedBox(height: 20,),
                  ]

                  ),
    );
  }

  _qr()async {
  await Navigator.push(context, 
    MaterialPageRoute(
    builder: (context) => QrReader(moduloCont: widget.moduloCont,)));
    setState((){
    });

  }

  _dataDisplay(Modulo m){
    return Column(
      children: [
            TextLabel(label: 'Temperatura',text: '${m.getTemperatura.toStringAsFixed(2)}° C' ),                
            _displayWarning(double.parse(m.getTemperatura.toStringAsFixed(2)),1),
            TextLabel(label: 'Luminocidad', text:'${m.getLuminocidad.toStringAsFixed(2)} I'),
            _displayWarning(double.parse(m.getLuminocidad.toStringAsFixed(2)),2),
            TextLabel(label: 'Ultima Lectura',text:'${_formatter.format(m.getUltimaLectura.toDate())}'),
      ],
    );
  }

  _displayWarning(double lectura, int m){
    double? comp = m==1?widget.temp:widget.lum;

    if(comp != null){
    if(comp == 0.0){
      return SizedBox();
    }else if(comp > lectura){
      return  IconLabel(icon:Icon(FontAwesomeIcons.exclamationTriangle, color: Colors.blueGrey),
                        text: m==1?_tempBaja:_lumBaja,
                        );
    } else if(comp < lectura){
      return  IconLabel(icon:Icon(FontAwesomeIcons.exclamationTriangle, color: Colors.blueGrey),
                        text: m==1?_tempAlta:_lumAlta,
                        );
    }else{
      return SizedBox();
    }
    }else{
      return SizedBox();
    }
           

  }

  

  _dataFromStream(String mid){
  return  StreamBuilder(
  stream: Firestore.datosModulo(mid: mid),
  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Ocurrio un error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Cargando datos');
        }

        if (!snapshot.data!.exists){
          widget.moduloCont.text='';
          return Text('El código no es valido');
        }

        if (snapshot.data!.data()!.length==0) {
          return Text('Sin datos');
        }

        return _dataDisplay(Modulo.fromSnapshot(snapshot.data!));
  });

}

}

