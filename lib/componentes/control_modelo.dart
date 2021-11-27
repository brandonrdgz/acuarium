import 'package:flutter/material.dart';

class ModeloPicker extends StatefulWidget {
  final TextEditingController modelCont;
  const ModeloPicker({ Key? key,required this.modelCont }) : super(key: key);

  @override
  _ModeloPickerState createState() => _ModeloPickerState();
}

class _ModeloPickerState extends State<ModeloPicker> {
    static const Map<String,String> _imgObjects={
                              'Pez1':'fish01',
                              'Pez2':'fish02',
                              'Pez3':'fish03',
                              'Pez4':'fish04',
                              'Pez5':'fish05',
                              'Pez6':'fish06',
                              'Pez7':'fish07',
                              'Pez8':'fish08',
                              'Pez9':'fish09',
                              'Pez10':'fish10',
                              'Pez11':'fish11',
                              'Pez12':'fish12',
                              'Pez13':'fish13',
                              'Pez14':'fish14',
                              'Pez15':'fish15',
                          };
    String _currentModel='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.modelCont.text.isEmpty){
    widget.modelCont.text=_imgObjects['Pez1']!;
    _currentModel='Pez1';
    }else if(_imgObjects.containsValue(widget.modelCont.text)){
      _imgObjects.forEach((key, value) { 
        if(value==widget.modelCont.text){
          _currentModel=key;
        }
      });      
    }else{
    widget.modelCont.text=_imgObjects['Pez1']!;
    _currentModel='Pez1';

    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: const EdgeInsets.all(8.0),
      child:
        Column(
          children: [
            SizedBox(height: 20,),
            Row(      
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Text("Modelo",
              style: TextStyle( fontWeight: FontWeight.bold, fontSize:18.0 ) 
            ),]),
            Row(      
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child:
                      DropdownButton<String>(   
                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),

                            value: _currentModel,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,                        
                            elevation: 16,
                            isExpanded: true,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.blueAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _currentModel=newValue!;
                                widget.modelCont.text = _imgObjects[_currentModel]!;
                              });
                            },
                            items: _imgObjects.keys.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
              ),
            ]
          ),
          ],
        ),
 
    );
       
  }


}