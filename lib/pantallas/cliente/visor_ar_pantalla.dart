import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VisorAr extends StatefulWidget {
  static const String id = 'visorAR';
  const VisorAr({ Key? key }) : super(key: key);

  @override
  _VisorArState createState() => _VisorArState();
}

class _VisorArState extends State<VisorAr> {
  String _model='';
  GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  late UnityWidgetController _unityWidgetController;
  static const String _trackedLost='T_P';
  static const String _trackedFound='T_E';
  static const String _trackedLostMsg='Target Perdida';
  static const String _trackedFoundMsg='Target Encontrada';
  static const String _targetObject ='ImageTarget';
  static const String _targetMethod='Show';
  static const List<String> _imgObjects=[
                              'fish01',
                              'fish02',
                              'fish03',
                              'fish04',
                              'fish05',
                              'fish06',
                              'fish07',
                              'fish08',
                              'fish09',
                              'fish10',
                              'fish11',
                              'fish12',
                              'fish13',
                              'fish14',
                              'fish15',
                            ];
  static const List<String> _fishNames=[
                              'Pez1',
                              'Pez2',
                              'Pez3',
                              'Pez4',
                              'Pez5',
                              'Pez6',
                              'Pez7',
                              'Pez8',
                              'Pez9',
                              'Pez10',
                              'Pez11',
                              'Pez12',
                              'Pez13',
                              'Pez14',
                              'Pez15',
                            ];
  TextEditingController _labelcont= TextEditingController();
  int _currentIndex=0;

  _next(){
    _currentIndex++;
    if(_currentIndex>=_imgObjects.length){
      _currentIndex=0;
    }
    _model=_imgObjects[_currentIndex];
    _unityWidgetController.postMessage(_targetObject, 
                                       _targetMethod,
                                       _model);
    _labelcont.text=_fishNames[_currentIndex];
  }

  _back(){
    _currentIndex--;
    if(_currentIndex<0){
      _currentIndex=_imgObjects.length-1;
    }
    _model=_imgObjects[_currentIndex];
    _unityWidgetController.postMessage(_targetObject, 
                                       _targetMethod,
                                       _model);
    _labelcont.text=_fishNames[_currentIndex];                                   

  }
                      

@protected
@mustCallSuper
void dispose() {
  super.dispose();
  _unityWidgetController.quit();
  _unityWidgetController.dispose();
}

  @override
  Widget build(BuildContext context) {
    if(_model.isEmpty){
      _model=ModalRoute.of(context)!.settings.arguments as String;
      }

    return SafeArea(
      child:Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Visor Acuarium'),
      ),
      body: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              UnityWidget(
                 borderRadius: BorderRadius.zero,
                  onUnityCreated: onUnityCreated,
                  onUnityMessage: onUnityMessage,
                  fullscreen: false,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child:Tarjeta(
                  color: Colors.blueAccent,
                  contenido: Column(
                    children: <Widget>[
                      Row(
                        children: [
                        Expanded(
                          flex: 3, // 60% of space => (6/(6 + 4))
                          child: Container(
                            child:IconButton(
                              icon: Icon(Icons.arrow_back,color: Colors.white,) ,
                              onPressed: (){
                                _back();
                              },
                              )  ),
                        ),
                        Expanded(
                          flex: 3, // 60% of space => (6/(6 + 4))
                          child: Container(
                            child: StatefulLabel(cont: _labelcont,)
                             ),
                        ),
                        Expanded(
                          flex: 3, // 60% of space => (6/(6 + 4))
                          child: Container(
                            child:IconButton(
                              icon: Icon(Icons.arrow_forward,color: Colors.white,) ,
                              onPressed: (){
                                _next();
                              },
                              )  ),
                        ),
                        ],
                      ),],
                  ),
                )
              )
         ]
          ),
      ),
    ));
  }

  
  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    if(message.toString()==_trackedFound){
          Fluttertoast.showToast(
                msg: _trackedFoundMsg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueAccent.shade400,
                textColor: Colors.white,
                fontSize: 16.0
            );
    }else if(message.toString()==_trackedLost){
          Fluttertoast.showToast(
                msg: _trackedLostMsg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueAccent.shade400,
                textColor: Colors.white,
                fontSize: 16.0
            );
    }

    }
  

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
        Fluttertoast.showToast(
                msg: 'Unity Listo',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueAccent.shade400,
                textColor: Colors.white,
                fontSize: 16.0
            );
    _currentIndex=_imgObjects.indexOf(_model);
    if(_currentIndex<0){
      _currentIndex=0;
      _model=_imgObjects[_currentIndex];
              Fluttertoast.showToast(
                msg: 'El modelo no valido',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueAccent.shade400,
                textColor: Colors.white,
                fontSize: 16.0
            );
      
    }
    _unityWidgetController.postMessage(_targetObject, 
                                       _targetMethod,
                                       _model);
    _labelcont.text=_fishNames[_currentIndex];                                   

  }


}



class StatefulLabel extends StatefulWidget {
  final TextEditingController cont;
  const StatefulLabel({ Key? key,required this.cont }) : super(key: key);

  @override
  _StatefulLabelState createState() => _StatefulLabelState();
}

class _StatefulLabelState extends State<StatefulLabel> {
  bool _hasChange=false;

  @override
  Widget build(BuildContext context) {
    return Text(widget.cont.text, 
                style: TextStyle(fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.cont.addListener(() { 
      setState(() {
        _hasChange=true;        
      });
    });
  }
}