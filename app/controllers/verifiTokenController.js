const jwt = require("jsonwebtoken");
const verifiTokenController = {
  verifiToken: (req, res, next) => {
    const token = req.headers.token;
    if (token) {
      const accessToken = token.split(" ")[1];
      jwt.verify(accessToken, process.env.JWT_ACCESS_KEY, (err, user) => {
        if (err) {
          return res.status(403).send("Token is not invalid");
        }
        req.user = user;
        next();
      });
    } else {
      return res.status(401).send("Chưa đăng nhập hoặc chưa được xác thực");
    }
  },
  verifiTokenAdmin: (req, res, next) => {
    verifiTokenController.verifiToken(req, res, () => {
      if (req.params.admin == 1) {
        next();
      } else {
        res.status(403).send("You are not admin");
      }
    });
  },
};
module.exports = verifiTokenController;
