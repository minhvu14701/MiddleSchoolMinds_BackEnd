const client = require("../config/InitRedis");
class socketIo {
  connection(socket) {
    console.log("User connection");
    socket.on("disconnect", () => {
      console.log("User disconnected:");
    });
  }
}

module.exports = new socketIo();
