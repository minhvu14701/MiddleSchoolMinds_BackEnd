const redis = require("ioredis");
const client = new redis(
  "redis://default:Pjj06VmH23IVoJlyyfhqB8JnU7RmCdye@redis-13108.c252.ap-southeast-1-1.ec2.cloud.redislabs.com:13108"
);

client.ping(function (err, result) {
  if (err) {
    console.error("Error pinging Redis:", err);
  } else {
    console.log("Redis ping result:", result);
  }
});

client.on("connect", () => {
  console.log("Redis client connected");
});

client.on("error", (error) => {
  console.error("redis Error:", error);
});
// };
module.exports = client;
