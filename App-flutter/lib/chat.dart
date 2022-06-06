import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String nombreU = '';
class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, @required this.title}): super(key: key){
    nombreU = this.title;
  }


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _controller = TextEditingController();

  WebSocketsNotifications socketsNotifications ;
  _MyHomePageState(){
    print("/////////////////////");
    socketsNotifications = new WebSocketsNotifications( new Usuario( nombreU ),this );
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text(widget.title),
        ),


        body: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                for( int i = 0 ; i < socketsNotifications.allMsg.length ; i++ )
                  getMsgInterface(
                    socketsNotifications.allMsg[i].mensaje,
                    socketsNotifications.allMsg[i].fecha,
                    socketsNotifications.allMsg[i].creadorName,
                    socketsNotifications.usuario.nombre,
                  ),

                SizedBox(height: 870,)

                /*  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( socketsNotifications.allMsg[i].mensaje, style: TextStyle( color: Colors.blue, fontSize: 25 ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( socketsNotifications.allMsg[i].creadorName, ),
                        Text( socketsNotifications.allMsg[i].fecha, ),
                      ],
                    ),
                  ],
                ),  */
              ],
            ),
          ) ,
        ),



        floatingActionButton: Container(
          color: Colors.transparent,
          height: 53,
          width: MediaQuery.of(context).size.width-30,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100) ,topLeft: Radius.circular(100) ),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.orangeAccent,
                      offset: new Offset(0.0, 5.0),
                      blurRadius: 7.0,
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width-120,
                child: Form(
                  child: TextFormField(
                    controller: _controller,
                    cursorColor: Colors.orangeAccent,
                    decoration: InputDecoration(
                      helperStyle: TextStyle(color: Colors.orangeAccent),
                      counterStyle: TextStyle(color: Colors.orangeAccent),
                      errorStyle: TextStyle(color: Colors.red),
                      hintStyle: TextStyle(color: Colors.orangeAccent),
                      suffixStyle: TextStyle(color: Colors.orangeAccent),
                      prefixStyle: TextStyle(color: Colors.orangeAccent),
                      labelStyle: TextStyle(color: Colors.black54),
                      labelText: 'Enviar mensaje',
                      border: InputBorder.none,
                      focusColor: Colors.orangeAccent,
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  _sendMessage();
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(100) ,topRight: Radius.circular(100) ),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.orangeAccent,
                        offset: new Offset(0.0, 5.0),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Icon(Icons.send,size: 26,color: Colors.white,),
                ),
              ),
            ],
          ),

        )


      /* FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: "Enviar",
        child: Icon(Icons.send),
      ), */// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      socketsNotifications.sendMsg( _controller.text, DateTime.now().toString() );
      _controller.text = '';
    }
  }

  @override
  void dispose() {
    //  widget.channel.sink.close();
    super.dispose();

  }

  void updateMsg(){
    setState(() {

      socketsNotifications = socketsNotifications;
    });
  }

  Widget getMsgInterface( String msg, String date, String usu, String mio ){
    if( mio == usu ){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [

            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all( Radius.circular(7) ),
                          color: Colors.orange.withOpacity(0.5)
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text( msg, style: TextStyle(color: Colors.white), ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text( date.split(".")[0].split(" ")[1].split(":")[0]+":"+date.split(".")[0].split(" ")[1].split(":")[1] ),
                        ),
                        Container(
                          child: Text(usu),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10,),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all( Radius.circular(90) ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage( "assets/asdsadsadas.png"),
                ),
              ),
              height: 60,
              width: 60,

            )
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all( Radius.circular(90) ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage( "assets/asdsadsadas.png"),
              ),
            ),
            height: 60,
            width: 60,

          ),
          SizedBox(width: 10,),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all( Radius.circular(7) ),
                        color: Colors.black.withOpacity(0.5)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text( msg, style: TextStyle(color: Colors.white), ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(usu),
                      ),
                      Container(
                        child: Text( date.split(".")[0].split(" ")[1].split(":")[0]+":"+date.split(".")[0].split(" ")[1].split(":")[1] ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}





/*
*
* Clase que define como tienen que ser los mensajes
*
* */
class Mensajes {
  String mensaje;
  String fecha;
  String creadorName;

  Mensajes( String mensaje, String fecha , String creadorName ){
    this.mensaje = mensaje;
    this.fecha = fecha;
    this.creadorName = creadorName;
  }
}


/*
*
* Clase que define a un usuario
*
* */
class Usuario{
  String nombre;
  String id;
  Usuario(  String nombre ){
    this.nombre = nombre;
  }
}


/*
 *
 *  Clase que define el Socket
 *
 * */
class WebSocketsNotifications{
  WebSocketChannel channel;
  Usuario usuario;
  List<Mensajes> allMsg;
  _MyHomePageState _myHomePageState;

  WebSocketsNotifications( Usuario usuario, _MyHomePageState _myHomePageState ){
    this.usuario = usuario;
    this.channel = WebSocketChannel.connect( Uri.parse('wss://127.0.0.1:34264') ) ; // wss://95.39.246.240:34263
    this.allMsg = [];
    this._myHomePageState = _myHomePageState;
    channel.stream.listen( //Leer el mesnaje enviado
            (message) {

          message = jsonDecode(message);

          // Añadimos el id del usuario
          if( message.length != 0 && message[0] == 'UserId' ){
            this.usuario.id = message[1];  // Una vez guardado el id del usuario que es igual que el id de la conexion
            channel.sink.add( jsonEncode( [ "UserId", [ usuario.id, usuario.nombre ] ] ) ); // Enviamos el nombre del usuario
          }

          if( message.length != 0 && message[0] == 'sendAllMsg' ){ // Recoger todos los mensajes

            this.allMsg = [];
            for( int i = 0  ; i < message[1].length; i++  ){
              allMsg.add( new Mensajes( message[1][i][1], message[1][i][2] , message[1][i][0] ) );  // Añadimos todos los mensajes como obejtos
            }
            this._myHomePageState.updateMsg();
            print(allMsg);
          }

        }, onError: (error, StackTrace stackTrace){
      print("Error en el socket");
      print( error );
    },onDone: (){
      print( "Comunicacion cerrada" ) ;
    });
  }

  sendMsg( String mensaje, String fecha ){   // Metodo para añadir un nuevo mensaje al socket
    channel.sink.add( jsonEncode( [ "addMsg", [ usuario.id, mensaje, fecha ] ] ) );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}



