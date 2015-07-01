var express   =     require("express");
var app       =     express();
var mysql	=	require("mysql");
var http 	= 	require('http').Server(app);
var io		=	require("socket.io")(http);
var AWS		=	require('aws-sdk');
var fs		=	require('fs');

/* Creating POOL MySQL connection.*/

var pool    =    mysql.createPool({
      connectionLimit   :   100,
      host              :   'test-24g.cuwafg6txpdf.us-west-2.rds.amazonaws.com',
      user              :   'josephryan',
      password          :   '81mqg7ysr8n',
      port				:	3306,
      database          :   'Status',
      debug             :   false
});

/* Hard coded credentials - Don't use for final product! */
AWS.config.update ({accessKeyId: 'akid', 
	secretAccessKey: 'secret',
	region: 'us-west-1'
	});
	
// Location to index.html	
app.get("/", function(req,res){
    res.sendFile(__dirname + '/index.html');
});
app.get('/images', function(req, res) { 
	res.sendFile(__dirname + '/images.html');
});  

/*  This is auto initiated event when Client connects to your machine  */

io.on('connection',function(socket) {  
	
	console.log("A user is connected: "  + socket.id);
	
	socket.on('disconnect', function(){
        console.log( socket.name + ' has disconnected from the chat.' + socket.id);
    });
    
	socket.on('status added', function(status) {
		add_status(status, function(res) { 
			if(res) {
				io.emit("name", status);
				// io.sockets.emit("time", status); /* Same as above line */
			} 
			else {
				io.emit('error');
			}
		});
	});
	
	socket.on('player name', function(status) {
		add_tweet(status, function(res) { 
			if(res) {
				io.emit("playerMove", 
					status.title, 
					status.at,
					status.tweet, 
					status.date,
					status.icon,
					status.asset);
			} 
			else {
				io.emit('error');
			}
		});
	});
	
	socket.on('asset image', function(status) {
		add_asset_image(status, function(res) { 
			if(res) {
				io.emit("assetImage", status.image, status.user);
			} 
			else {
				io.emit('error');
			}
		});
	});
});

var add_tweet = function (status, callback) {
    pool.getConnection (function (err, connection) {
        if (err) {
          connection.release();
          callback(false);
          return;
        }
        connection.query("INSERT INTO `twitterFeed` (user_icon, user_name, user_at, user_tweet, user_asset) VALUES ('" + status.icon + "', '" + status.title + "', '" + status.at + "', '" + status.tweet + "', '" + status.asset + "')", function(err, rows) {	
            connection.release();
            if(!err) {
              callback(true);
            }
    	});
		connection.on('error', function(err) {
			callback(false);
			return;
		});
    });
}

var add_status = function (status, callback) {
    pool.getConnection (function (err, connection) {
        if (err) {
          connection.release();
          callback(false);
          return;
        }
    	connection.query("INSERT INTO `randomNum` (`randomNo`) VALUES ('" + status + "')", function(err, rows) {
            connection.release();
            if(!err) {
              callback(true);
            }
    	});
		connection.on('error', function(err) {
			callback(false);
			return;
		});
    });
}

var add_asset_image = function (status, callback) {

 pool.getConnection (function (err, connection) {
        if (err) {
          connection.release();
          callback(false);
          return;
        }
    	connection.query("INSERT INTO `assetImage` (image, user_title) VALUES ('" + status.image + "', '" + status.user + "')", function(err, rows) {
            connection.release();
            if(!err) {
              callback(true);
            }
    	});
		connection.on('error', function(err) {
			callback(false);
			return;
		});
    });
}

// Gets static images
app.use(express.static(__dirname + '/public'));

http.listen(3000,function(){
    console.log("Listening on 3000");
});