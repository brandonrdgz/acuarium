import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final Icon icon; 
  final String text;
  const IconLabel({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        flex: 1,
        child:icon,
      ),
      Flexible(
        flex: 4,
        child:        
          Text(text,
                      style: TextStyle( fontWeight: FontWeight.bold, fontSize:20.0 ) 
              )
      ),
    ]
  );    
  }
}

class TextLabel extends StatelessWidget {
  final String label;
  final String text;
  const TextLabel({Key? key, required this.label,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        flex: 2,
        child:
          Text("$label:",
                      style: TextStyle( fontWeight: FontWeight.bold, fontSize:20.0 ) 
              ),
      ),
      Flexible(
        flex: 3,
        child:
          Text(text,
                      style: TextStyle( fontWeight: FontWeight.normal, fontSize:18.0 ) 
              ),
      ),
    ]
  ); 
  }
}
