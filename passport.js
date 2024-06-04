const GoogleStrategy = require("passport-google-oauth20").Strategy;
const sql = require("./app/models/index");
require("dotenv").config();
const passport = require("passport");
passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: "http://localhost:5000/auth/google/callback",
    },
    function (accessToken, refreshToken, profile, cb) {
      try {
        // connect db
        sql.query(
          "SELECT * FROM tbluser WHERE id_google = ?",
          profile.id,
          (err, result) => {
            if (err) {
              console.log(err);
              return cb(err, null);
            } else {
              if (result.length) {
                return cb(null, result[0]);
              } else {
                const newUser = {
                  id_google: profile.id,
                  fullname: profile.displayName,
                  email: profile.emails[0].value,
                  typeLogin: profile.provider,
                };
                sql.query(
                  "INSERT INTO tbluser SET ?",
                  newUser,
                  (err, results) => {
                    if (err) {
                      return cb(err, null);
                    }
                    console.log(3);
                    return cb(null, newUser);
                  }
                );
              }
            }
          }
        );
        // return cb(null, profile);
      } catch (error) {
        console.log(error);
      }
    }
  )
);
