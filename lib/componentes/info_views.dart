import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoView extends StatelessWidget {
  static const String ERROR_VIEW='ERROR';
  static const String INFO_VIEW='INFO';
  static const String LOADING_VIEW='LOADING';
  final BuildContext context;
  final String type;
  final String? msg;
  const InfoView({ Key? key,required this.type,required this.context,this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildView(),
            )
            );
  }

  _buildView(){
    switch(type){
      case ERROR_VIEW:
        return [  
              Icon(FontAwesomeIcons.exclamationTriangle,
                    color: Colors.blueGrey,
                    size: MediaQuery.of(context).size.height/10,),
              SizedBox(height: 20,),
              Text(msg!,style: TextStyle(fontSize: 21,), textAlign: TextAlign.center,)             
            ];
      case INFO_VIEW:
          return [
              Icon(FontAwesomeIcons.exclamationCircle,
                    color: Colors.blueGrey,
                    size: MediaQuery.of(context).size.height/10 ,),
                    SizedBox(height: 20,),
              Text(msg!,style: TextStyle(fontSize: 21,), textAlign: TextAlign.center,)             
          ];
      case LOADING_VIEW:
        return [              
              CircularProgressIndicator(),
              SizedBox(height: 20,),
              Text('Cargando',style: TextStyle(fontSize: 21,), textAlign: TextAlign.center,)  
              ];

    }
  }
}