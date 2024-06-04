const sql = require("../models/index");

class userModel {
  static async getIdGoogle(idGoogle, result) {
    sql.query(
      "SELECT * FROM tbluser WHERE id_google = ?",
      idGoogle,
      (err, res) => {
        if (err) {
          console.log("ERROR: ", err);
          result(err, null);
          return;
        }
        //Hiển thị vào teminal
        result(null, res[0]);
      }
    );
  }
  static async register(newUser, result) {
    sql.query(`INSERT INTO tbluser SET ?`, newUser, (err, res) => {
      if (err) {
        console.log("ERROR: ", err);
        result(err, null);
        return;
      }
      //Hiển thị vào teminal
      console.log("New user: ", { id: res.insertId, ...newUser });
      result(null, { id: res.insertId, ...newUser });
    });
  }
  static async login(username, result) {
    sql.query(
      `SELECT * FROM tbluser WHERE username = ?`,
      username,
      (err, res) => {
        if (err) {
          console.log("ERROR: ", err);
          result(err, null);
        } else {
          console.log("User: ", res[0]);
          result(null, res[0]);
          return;
        }
      }
    );
  }
  //get user info
  static async infoUser(idUser, result) {
    sql.query(`SELECT * FROM tbluser WHERE id = ?`, idUser, (err, res) => {
      if (err) {
        console.log("ERROR: ", err);
        result(err, null);
      } else {
        console.log("User: ", res[0]);
        result(null, res[0]);
        return;
      }
    });
  }
  static async editInfo(
    [
      fullname,
      username,
      email,
      school,
      birthday,
      ip_class,
      phone,
      sex,
      avatarName,
      idUser,
    ],
    result
  ) {
    sql.query(
      "UPDATE tbluser SET fullname = ?, username = ?, email = ?,school = ?, birthday = ?, class = ?, phone = ?, sex = ?,avatar = ? WHERE id = ?",
      [
        fullname,
        username,
        email,
        school,
        birthday,
        ip_class,
        phone,
        sex,
        avatarName,
        idUser,
      ],
      (err, res) => {
        if (err) {
          console.log("ERROR sql: ", err);
          result(err, null);
        } else {
          console.log("Update success: ");
          result(null, true);
          return;
        }
      }
    );
  }
}
module.exports = userModel;
