/**
* Parameters
*/
var webSocketsServerPort = 34263; // Adapt to the listening port number you want to use
/**
* Global variables
*/
// websocket and http servers
//var webSocketServer = require('websocket').server;
var express = require('express');
var app = express();


var https  = require('https');
var fs = require('fs');
/**
* HTTP server to implement WebSockets
*/
const options = {
    key: fs.readFileSync('key.pem', 'utf8'),
    cert: fs.readFileSync('cert.pem', 'utf8')
  };
var httpsServer  = https .createServer( options, app )  ;
httpsServer .listen(webSocketsServerPort, function() {
    console.log((new Date()) + " Server is listening on port "
        + webSocketsServerPort);
  });

  
var webSocketServer = require('ws').Server;

/**
* WebSocket server
*/
var wsServer = new webSocketServer({
  // WebSocket server is tied to a HTTP server. WebSocket
  // request is just an enhanced HTTP request. For more info 
  // http://tools.ietf.org/html/rfc6455#page-6
  server: httpsServer

});

console.log(wsServer);

// This callback function is called every time someone
// tries to connect to the WebSocket server
var usuarios = [];
wsServer.on('connection', function connection(ws) {
    ws.on('message', function incoming(message) {
      console.log('received: %s', message);
    });

    ws.send('something');
  });

wsServer.on('request', function(request) {
    

    console.log("una conexion");
    
    var connection = request.accept(null, request.origin); 

	
  // usuarios = ddNewUser( usuarios, request.key ); 
   connection.sendUTF( JSON.stringify( [ "UserId" , request.key] )  );
   //connection.sendUTF( JSON.stringify( [ "UserId" ,mensajes] )  );

  
    
  //connection.sendUTF( JSON.stringify( [ "ArrayMsgAll" ,mensajes] )  );
  //console.log( mensajes )

    connection.on('message', function(data) {


        data =  JSON.parse( data.utf8Data );
        if( data.length != 0 && data[0] == "UserId" ){ // Comprobar si es el user ID
            ddNewUser( usuarios , data[1][0], data[1][1], connection ); 
            connection.sendUTF(  JSON.stringify( [ "sendAllMsg" ,  sendAllMsg() ] )    );   // Una vez añadido al usuario le enviamos todo el chat, para que lo pueda ver
         //   console.log(usuarios);
        }
        if( data.length != 0 && data[0] == "addMsg" ){ // Añadir un nuevo mensaje al array 
            addNewMensaje( mensajes, data[1][0], data[1][1], data[1][2] );

            sendBrodacstAllMsg( usuarios );  // Una vez que uno añade un mesnsaje les enviamos a todos por broadcast

            //connection.sendUTF(  JSON.stringify( [ "sendAllMsg" ,  sendAllMsg() ] )    );

            console.log(sendAllMsg());
            //console.log(mensajes);
        }

        //mensajes.push( data["utf8Data"] );

        //connection.sendUTF(data["utf8Data"]);


        //console.log( mensajes )

    });

    // user disconnected
    connection.on('close', function(connection) {
        console.log("Cliente a cerrado conexion");
    });
});



  
// -----------------------------------------------------------
// List of all players
// -----------------------------------------------------------
var mensajes = [];


function ddNewUser( usuarios , id, name, connection ){

    if( !usuarios.includes( id ) ){
        console.log( "add USER" );
        usuarios.push( [ id , name, connection ] ); 
    }

}

function addNewMensaje( mensajes, idUser, msg, date ){
    console.log( "add MSG" );
    mensajes.push( [ idUser, msg, date] );
  //  console.log( mensajes );
}


function sendAllMsg(){
    var msgReturn  = [];
    for( let i = mensajes.length-1  ; i >= 0 ; i-- ){
        msgReturn.push( [ getUserName( mensajes[i][0] ) ,mensajes[i][1], mensajes[i][2] ] ); 
    }
    return  msgReturn ;
}


function getUserName( id ){
    for (let index = 0; index < usuarios.length; index++) {
        if( id == usuarios[index][0] ){
            return usuarios[index][1];
        }
    }
    return "The cake is a live";
}



/**
 * funcion que envia todos los mensajes por brodacast a todos los sususarios conectados a la red
 * para esto vamos a usar el array que contiene a todos los usuarios y su id de conexion 
 * con ese ide se va a acrear una conexion en la que se va a enviar todos los mensajes
 */
function sendBrodacstAllMsg( usuarios ){
    for( let i = 0; i < usuarios.length; i++ ){
        usuarios[i][2].sendUTF( JSON.stringify( [ "sendAllMsg" ,  sendAllMsg() ] ) );
    }
}