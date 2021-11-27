import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AcercaDe extends StatelessWidget {
  static const String id = 'AcercaDe';    
  const AcercaDe({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('Acerca de'),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          ListTile(
                        title: Text('Tecnológico Nacional de México',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                        subtitle: Text('Instituto Tecnológico de Toluca',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18)
                                ),
                      ),
            Image(
              image: AssetImage('images/logo.png'),
              height: MediaQuery.of(context).size.height/4,

              ),
               ListTile(
                        leading: Icon(
                          FontAwesomeIcons.tools,
                          color: Colors.blueAccent
                        ),
                        title: Text('Proyecto'),
                        subtitle: Text('Acuarium'),
                      ),
            ListTile(
                        leading: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.blueAccent
                        ),
                        title: Text('Rodriguez Duarte Brandon Ivan '),
                        subtitle: Text('17280311'),
                      ),
            ListTile(
                        leading: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.blueAccent
                        ),
                        title: Text('Reyes Montiel Fernando Braulio '),
                        subtitle: Text('17280312'),
                      ),
              ListTile(
                        leading: Icon(
                          FontAwesomeIcons.graduationCap,
                          color: Colors.blueAccent
                        ),
                        title: Text('PROGR. AVANZ. DESARROLLO DE APLICACIONES PARA DIS. MOV.'),
                        subtitle: Text('M.C. C. Rocío Elizabeth Pulido Alba'),
                      ),
            Divider(thickness: 2,),
            ListTile(
                        title: Text('Metepec, Estado de México',
                                textAlign: TextAlign.center,
                                ),
                        subtitle: Text('Noviembre 2021',
                                textAlign: TextAlign.center,
                                ),
                      ),

          ],
        ),
      )
    );
  }
}