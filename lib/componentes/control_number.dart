import 'package:acuarium/componentes/tarjeta.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NumberPicker extends StatefulWidget {
  final TextEditingController cont;
  final int max;
  final int min; 
  const NumberPicker({ Key? key, required this.cont, required this.max, required this.min}) : super(key: key);

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int _count=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.cont.text=_count.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Tarjeta(
                color:  Colors.white,
                contenido: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text('Cantidad',                      
                          style:TextStyle(color: Colors.black,fontSize: 20.0)),
                          subtitle: Text('${widget.cont.text} u',
                          style:TextStyle(color: Colors.black,fontSize: 20.0)),
                        ),
                        ),
                      IconButton(
                          onPressed: (){
                            if(_count>widget.min){
                              setState(() {
                              _count--;
                              widget.cont.text=_count.toString();
                              });
                            }                                        
                                          },
                          icon: Icon(FontAwesomeIcons.minus, color: Colors.blueGrey)),
                        IconButton(
                          onPressed: (){
                            if(_count<widget.max){
                              setState(() {
                              _count++;
                              widget.cont.text=_count.toString();
                              });
                            }      
                          }, 
                          icon: Icon(FontAwesomeIcons.plus, color: Colors.blueAccent)),
                        ]
                        ),
                  ],
                ),
              );
  }
}