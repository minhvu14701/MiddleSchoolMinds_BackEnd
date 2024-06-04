const sql = require("../models/index");
class otherModel {
  static async getSubject(result) {
    sql.query("SELECT * FROM tblmon", (err, res) => {
      if (err) {
        console.log("ERROR:", err);
        result(err, null);
        return;
      } else {
        result(null, res);
        return;
      }
    });
  }
  static async getClass(result) {
    sql.query("SELECT * FROM tbllop", (err, res) => {
      if (err) {
        console.log("ERROR:", err);
        result(err, null);
        return;
      } else {
        result(null, res);
        return;
      }
    });
  }
  //Notify
  static async getNotify(idUser, result) {
    sql.query(
      "SELECT question.id AS idQues,answer.id AS idAnswer,tbluser.fullname,tenmon,answer.statusNo,tbluser.avatar FROM question INNER JOIN answer ON question.id = answer.id_ques INNER JOIN tbluser ON tbluser.id = answer.id_user INNER JOIN tblmon ON tblmon.id = question.id_mon WHERE question.id_user = ? ORDER BY answer.date DESC",
      idUser,
      (err, res) => {
        if (err) {
          console.log("ERROR:", err);
          result(err, null);
          return;
        } else {
          result(null, res);
          return;
        }
      }
    );
  }
  //update notify
  static async updateNotify(idAns, result) {
    sql.query(
      "UPDATE answer SET answer.statusNo = 1 WHERE id = ?",
      idAns,
      (err, res) => {
        if (err) {
          console.log("ERROR:", err);
          result(err, null);
          return;
        } else {
          result(null, res);
          return;
        }
      }
    );
  }
}

module.exports = otherModel;
