var io = require('socket.io')();
var axios = require('axios');
let users = [];
let url = 'http://localhost:3000/api/v1/chat';
let authToken;

function getNameByID(Id) {
    for (const user of users) {
        if (user.id == Id) {
            return user.name;
        }
    }
}
function getIDByName(name) {
    for (const user of users) {
        if (user.name == name) {
            return user.id;
        }
    }
}

io.on('connection', (socket) => {
    console.log(socket.id + " connected");
    socket.on('CLIENT_SEND_USERNAME', function (data) {
        users.push({
            id: socket.id,
            name: data
        });
        io.emit('SERVER_SEND_JOIN_GROUP', {
            message: data+" đã tham gia phòng",
            members: users
        });
        socket.on('SET_AUTH_TOKEN', function (token) {
            authToken = token;
        });
    })
    socket.on('CLIENT_SEND_GROUP', function (data) {
        socket.join(data);
        io.emit('SERVER_SEND_JOIN_GROUP', {
            message: getNameByID(socket.id)+" đã tham gia phòng",
            members: users
        });
    }
    );
    socket.on('CLIENT_SEND_MESSAGE', function (data) {
        if (typeof data === 'string' && data.startsWith('/')) {
            let name = data.split(' ')[0];
            name  = name.substr(1,name.length);
            let message = data.substr(name.length+2,data.length);
            socket.to(getIDByName(name)).emit('SERVER_SEND_MESSAGE',{
                message: message,
                from: getNameByID(socket.id),
                createAt: new Date().toLocaleTimeString(),
                to: name
            });
            socket.emit('SERVER_SEND_MESSAGE',{
                message: message,
                from: getNameByID(socket.id),
                createAt: new Date().toLocaleTimeString(),
                to: name
            });

            try{
                const messRes = axios.post(url + '/messages' , {
                    from: getNameByID(socket.id),
                    to: name['name'],
                    message: message['message']
                }, {
                    headers: {
                        'x-auth-token': authToken
                    }
                });
                console.log(messRes);

            }catch(e){
                console.log(e);
            }
    
        } else {
            io.emit('SERVER_SEND_MESSAGE', {
                message: data,
                from: getNameByID(socket.id),
                createAt: new Date().toLocaleTimeString()
            });
            try{
                const messRes = axios.post(url + '/messages' , {
                    from: getNameByID(socket.id),
                    message: data,
                    group: 'room'
                }, {
                    headers: {
                        'x-auth-token': authToken
                    }
                });
                console.log('Đã gửi tin nhắn' + messRes);
            }
            catch(e){
                console.log(e);
            }
            
        }
    });
    
    socket.on('disconnect', function () {
        let username;
        for (let index = 0; index < users.length; index++) {
            const element = users[index];
            if (element.id == socket.id) {
                username = element.name;
                users.splice(index, 1);
                break;
            }
        }
        io.emit('SERVER_SEND_DISCONNECT', {
            message: username+" da roi phong",
            members: users
        }); 
    })
});

module.exports = io;