const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

const port = process.env.PORT || 3000;

app.use(express.json());

// REST API
app.get('/health', (req, res) => res.send('OK'));

// WebSockets
io.on('connection', (socket) => {
    console.log('A user connected:', socket.id);
    
    // TODO: Implement your real-time events here
    
    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
    });
});

server.listen(port, () => console.log(`Server running on port ${port}`));
