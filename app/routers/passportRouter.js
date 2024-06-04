const router = require("express").Router();
const passport = require("passport");
const userController = require("../controllers/userController");
require("dotenv").config();
router.get(
  "/google",
  passport.authenticate("google", {
    scope: ["profile", "email"],
    session: false,
  })
);
router.get(
  "/google/callback",
  (req, res, next) => {
    passport.authenticate("google", (err, profile) => {
      if (err) {
        console.log(err);
      }
      req.user = profile;
      next();
    })(req, res, next);
  },
  (req, res) => {
    res.redirect(
      `${process.env.URL_CLIENT}/login-success/${req.user?.id_google}`
    );
  }
);
router.post("/login-success", userController.googleLogin);
module.exports = router;
