const sql = require("../models/index");
class quesAnsModel {
  //Lấy câu hỏi đã phân trang
  static async getQuesion(pageNumber, result) {
    sql.query(
      "SELECT question.id,fullname,avatar,tenmon,question.content,image,date_ques,COUNT(answer.id) AS SumAnswer FROM question INNER JOIN tblmon ON question.id_mon = tblmon.id INNER JOIN tbluser ON question.id_user = tbluser.id LEFT JOIN answer ON question.id = answer.id_ques GROUP BY question.id ORDER BY question.date_ques DESC LIMIT ?,6",
      pageNumber,
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
  //Lấy tổng số trang
  static async getTotalPage(result) {
    sql.query(
      "SELECT CEIL(COUNT(id)/6) AS totalPage FROM question",
      (err, res) => {
        if (err) {
          console.log("ERROR:", err);
          result(err, null);
          return;
        } else {
          result(null, res[0]);
          return;
        }
      }
    );
  }
  //Lọc câu hỏi theo môn đã phân trang
  static async getQuesSub([subjectId, pageNumber], result) {
    sql.query(
      "SELECT question.id,fullname,avatar,tenmon,question.content,image,date_ques,COUNT(answer.id) AS SumAnswer FROM question INNER JOIN tblmon ON question.id_mon = tblmon.id INNER JOIN tbluser ON question.id_user = tbluser.id LEFT JOIN answer ON question.id = answer.id_ques WHERE tblmon.id = ? GROUP BY question.id ORDER BY question.id DESC LIMIT ?,6",
      [subjectId, pageNumber],
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
  //Lấy tổng số trang của môn học
  static async getTotalSub(subjectId, result) {
    sql.query(
      "SELECT CEIL(COUNT(question.id)/6) AS totalPage FROM question INNER JOIN tblmon ON question.id_mon = tblmon.id WHERE tblmon.id = ?",
      subjectId,
      (err, res) => {
        if (err) {
          console.log("ERROR:", err);
          result(err, null);
          return;
        } else {
          result(null, res[0]);
          return;
        }
      }
    );
  }
  //Lọc câu hỏi theo tìm kiếm đã phân trang
  static async getQuesSearch([textSearch, pageNumber], result) {
    sql.query(
      "SELECT question.id,fullname,avatar,tenmon,question.content,image,date_ques,COUNT(answer.id) AS SumAnswer FROM question INNER JOIN tblmon ON question.id_mon = tblmon.id INNER JOIN tbluser ON question.id_user = tbluser.id LEFT JOIN answer ON question.id = answer.id_ques WHERE MATCH(question.content) AGAINST (?) GROUP BY question.id ORDER BY question.id DESC LIMIT ?,6",
      [textSearch, pageNumber],
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
  //Lấy tổng số trang của tìm kiếm
  static async getTotalSearch(textSearch, result) {
    sql.query(
      "SELECT CEIL(COUNT(question.id)/6) AS totalPage FROM question INNER JOIN tblmon ON question.id_mon = tblmon.id WHERE MATCH(content) AGAINST (?);",
      textSearch,
      (err, res) => {
        if (err) {
          console.log("ERROR:", err);
          result(err, null);
          return;
        } else {
          result(null, res[0]);
          return;
        }
      }
    );
  }
  //Lấy tiêu đề câu hỏi
  static async getTitle(quesId, result) {
    sql.query(
      "SELECT fullname,avatar,tenmon,content,image,date_ques FROM question INNER JOIN tblmon ON question.id_mon = tblmon.id INNER JOIN tbluser ON question.id_user = tbluser.id WHERE question.id = ?",
      quesId,
      (err, res) => {
        if (err) {
          console.log("ERROR:", err);
          result(err, null);
          return;
        } else {
          result(null, res[0]);
          return;
        }
      }
    );
  }
  //Lấy list câu trả lời
  static async getAnswer(quesId, result) {
    sql.query(
      "SELECT fullname,avatar,content,imageAns,date FROM answer INNER JOIN tbluser ON answer.id_user = tbluser.id WHERE id_ques = ? ORDER BY answer.date DESC",
      quesId,
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
  //Thêm câu hỏi
  static async addQuestion(
    [idUser, idMon, contentAdd, imageQues, dateQues],
    result
  ) {
    sql.query(
      "INSERT INTO question SET id_user = ?, id_mon = ?, content = ?,image = ? ,date_ques = ?",
      [idUser, idMon, contentAdd, imageQues, dateQues],
      (err, res) => {
        if (err) {
          console.log("ERROR: ", err);
          result(err, null);
          return;
        } else {
          result(null, res);
        }
      }
    );
  }
  //Thêm câu trả lời
  static async addAnswer([idUser, idQues, content, image, dateAns], result) {
    sql.query(
      "INSERT INTO answer SET id_user = ?, id_ques = ?, content = ?, imageAns = ?, date = ?",
      [idUser, idQues, content, image, dateAns],
      (err, res) => {
        if (err) {
          console.log("ERROR: ", err);
          result(err, null);
          return;
        } else {
          result(null, res);
        }
      }
    );
  }
}

module.exports = quesAnsModel;
