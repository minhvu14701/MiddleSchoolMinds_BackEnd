const sql = require("../models/index");
class kithiModel {
  static async getExamCourse(idCourse, result) {
    sql.query(
      "SELECT exams.id,`name`,time,COUNT(exams_question.id_exam) AS totalQuestion FROM exams INNER JOIN exams_question ON exams.id = exams_question.id_exam WHERE id_course = ? GROUP BY exams_question.id_exam",
      idCourse,
      (err, exam) => {
        if (err) {
          console.log("error query exam:", err);
          result(err, null);
        } else {
          result(null, exam[0]);
        }
      }
    );
  }
  static async resultExamUSer([idUser, idCourse], result) {
    sql.query(
      "SELECT users_exam.id,`status`,start_time,end_time,score FROM users_exam INNER JOIN exams ON users_exam.id_exam = exams.id WHERE users_exam.id_user = ? AND exams.id_course = ?",
      [idUser, idCourse],
      (err, info) => {
        if (err) {
          console.log("error query result exam:", err);
          result(err, null);
        } else {
          result(null, info);
        }
      }
    );
  }
  //Lấy thông tin kì thi thông qua id userExam
  static async getExamCourseUser(idUserExam, result) {
    sql.query(
      "SELECT exams.id,`name`,tenmon,time,COUNT(exams_question.id_exam) AS totalQuestion FROM exams INNER JOIN exams_question ON exams.id = exams_question.id_exam INNER JOIN tblmon ON exams.id_subject = tblmon.id WHERE exams.id = (SELECT users_exam.id_exam FROM users_exam WHERE users_exam.id = ? ) GROUP BY exams_question.id_exam",
      idUserExam,
      (err, exam) => {
        if (err) {
          console.log("error query exam:", err);
          result(err, null);
        } else {
          result(null, exam[0]);
        }
      }
    );
  }
  //lấy list câu hỏi
  static async listQuestions(idExam, result) {
    sql.query(
      "SELECT * FROM exams_question WHERE id_exam = ? ORDER BY RAND()",
      idExam,
      (err, info) => {
        if (err) {
          console.log("error query list question exam:", err);
          result(err, null);
        } else {
          result(null, info);
        }
      }
    );
  }
  //lấy list câu trả lời
  static async listAnswers(idQues, result) {
    sql.query(
      "SELECT * FROM exams_answer WHERE exams_answer.id_ques = ? ORDER BY RAND()",
      idQues,
      (err, info) => {
        if (err) {
          console.log("error query list answer exam:", err);
          result(err, null);
        } else {
          result(null, info);
        }
      }
    );
  }
  //update time start
  static async updateStartTimeStatus([startTime, idUserQues], result) {
    sql.query(
      "UPDATE users_exam SET `status` = 1, users_exam.start_time = ? WHERE id = ?",
      [startTime, idUserQues],
      (err, info) => {
        if (err) {
          console.log("error query update startTime exam:", err);
          result(err, null);
        } else {
          result(null, info);
        }
      }
    );
  }
  //nop bai
  static async saveAnsMysql(values, result) {
    sql.query(
      "INSERT INTO users_answers(id_userExam,id_ques,id_answer,selected) VALUES ?",
      [values],
      (err, res) => {
        if (err) {
          console.log("Loi them dap an vao data:" + err);
          result(err, null);
        } else {
          result(null, true);
        }
      }
    );
  }
  static async computedScore(idUserExam, result) {
    sql.query("CALL computedScore(?)", idUserExam, (err, res) => {
      if (err) {
        console.log("Loi tinh diem:" + err);
        result(err, null);
      } else {
        result(null, true);
      }
    });
  }
  // hien thi exam user
  static async listExamUser([idUser, pageNumber], result) {
    sql.query(
      "SELECT exams.id,tenlop,exams.id_subject,tenmon,`name`,time,id_course,tongCauHoi.totalQues FROM users_exam INNER JOIN exams ON users_exam.id_exam = exams.id LEFT JOIN (SELECT exams.id,COUNT(exams.id) AS totalQues FROM exams INNER JOIN exams_question ON exams.id = exams_question.id_exam) AS tongCauHoi ON users_exam.id_exam = tongCauHoi.id INNER JOIN tblmon ON tblmon.id = exams.id_subject INNER JOIN tbllop ON tbllop.id = exams.id_class WHERE users_exam.id_user = ? GROUP BY users_exam.id_exam ORDER BY users_exam.id_exam ASC LIMIT ?,6",
      [idUser, pageNumber],
      (err, info) => {
        if (err) {
          console.log("error query list exam user:", err);
          result(err, null);
        } else {
          result(null, info);
        }
      }
    );
  }
  static async totalPageExamUser(idUser, result) {
    sql.query(
      "SELECT CEIL(COUNT(total.dem)/6) AS totolPage FROM (SELECT COUNT(users_exam.id) AS dem FROM users_exam INNER JOIN exams ON users_exam.id_exam = exams.id WHERE id_user = ? GROUP BY id_exam) AS total",
      idUser,
      (err, res) => {
        if (err) {
          console.log("error total user exam page:", err);
          result(err, null);
        } else {
          result(null, res[0]);
        }
      }
    );
  }
  // hien thi exam khac
  static async listExamAnother([idUser, pageNumber], result) {
    sql.query(
      "SELECT exams.id,tenlop,exams.id_subject,tenmon,`name`,time,id_course,tongCauHoi.totalQues FROM users_exam RIGHT JOIN exams ON users_exam.id_exam = exams.id LEFT JOIN (SELECT exams.id,COUNT(exams.id) AS totalQues FROM exams INNER JOIN exams_question ON exams.id = exams_question.id_exam) AS tongCauHoi ON users_exam.id_exam = tongCauHoi.id INNER JOIN tblmon ON tblmon.id = exams.id_subject INNER JOIN tbllop ON tbllop.id = exams.id_class WHERE exams.id NOT IN (SELECT users_exam.id_exam FROM users_exam WHERE users_exam.id_user = ?) GROUP BY exams.id ORDER BY exams.id ASC LIMIT ?,6",
      [idUser, pageNumber],
      (err, info) => {
        if (err) {
          console.log("error query list exam user:", err);
          result(err, null);
        } else {
          result(null, info);
        }
      }
    );
  }
  static async totalPageExamAnother(idUser, result) {
    sql.query(
      "SELECT CEIL(COUNT(total.dem)/6) AS totalPage FROM (SELECT COUNT(exams.id) AS dem FROM users_exam RIGHT JOIN exams ON users_exam.id_exam = exams.id WHERE exams.id NOT IN (SELECT users_exam.id_exam FROM users_exam WHERE users_exam.id_user = ?) GROUP BY exams.id) AS total",
      idUser,
      (err, res) => {
        if (err) {
          console.log("error total user exam page:", err);
          result(err, null);
        } else {
          result(null, res[0]);
        }
      }
    );
  }
  //them kki thi tu trang exam
  static async insertUserExam([idUser, idExam], result) {
    sql.query(
      "INSERT INTO users_exam SET users_exam.id_user = ?, users_exam.id_exam = ?",
      [idUser, idExam],
      (err, res) => {
        if (err) {
          console.log("error insert userExam:", err);
          result(err, null);
        } else {
          result(null, res);
        }
      }
    );
  }
  //lấy thông tin kì thi qua id kì thi
  static async getResultExamUser([idUser, idExam], result) {
    sql.query(
      "SELECT * FROM users_exam WHERE id_user = ? AND id_exam = ?",
      [idUser, idExam],
      (err, res) => {
        if (err) {
          console.log("error result exam user:", err);
          result(err, null);
        } else {
          result(null, res);
        }
      }
    );
  }
  //láy thông tin kì thi qua id
  static async getInfoExam(idExam, result) {
    sql.query(
      "SELECT `name`,time,tenmon,tenlop,COUNT(exams.id) AS totalQues FROM exams INNER JOIN tblmon ON tblmon.id = exams.id_subject INNER JOIN tbllop ON tbllop.id = exams.id_class INNER JOIN exams_question ON exams.id = exams_question.id_exam WHERE exams.id = ?",
      idExam,
      (err, res) => {
        if (err) {
          console.log("error result exam user:", err);
          result(err, null);
        } else {
          result(null, res[0]);
        }
      }
    );
  }
  // hien thi exam user search name exam
  static async listExamUserSearch([idUser, querySearch, pageNumber], result) {
    const queryText =
      "SELECT exams.id,tenlop,exams.id_subject,tenmon,`name`,time,id_course,tongCauHoi.totalQues FROM users_exam INNER JOIN exams ON users_exam.id_exam = exams.id LEFT JOIN (SELECT exams.id,COUNT(exams.id) AS totalQues FROM exams INNER JOIN exams_question ON exams.id = exams_question.id_exam) AS tongCauHoi ON users_exam.id_exam = tongCauHoi.id INNER JOIN tblmon ON tblmon.id = exams.id_subject INNER JOIN tbllop ON tbllop.id = exams.id_class WHERE users_exam.id_user = ?" +
      " " +
      querySearch +
      " " +
      "GROUP BY users_exam.id_exam ORDER BY users_exam.id_exam ASC LIMIT ?,6";
    sql.query(queryText, [idUser, pageNumber], (err, info) => {
      if (err) {
        console.log("error query list exam user search:", err);
        result(err, null);
      } else {
        result(null, info);
      }
    });
  }
  static async totalPageExamUserSearch([idUser, querySearch], result) {
    const queryText =
      "SELECT CEIL(COUNT(total.dem)/6) AS totolPage FROM (SELECT COUNT(users_exam.id) AS dem FROM users_exam INNER JOIN exams ON users_exam.id_exam = exams.id WHERE id_user = ?" +
      " " +
      querySearch +
      " " +
      "GROUP BY id_exam) AS total";
    sql.query(queryText, idUser, (err, res) => {
      if (err) {
        console.log("error total user exam search page:", err);
        result(err, null);
      } else {
        result(null, res[0]);
      }
    });
  }
  // hien thi exam another search exam name
  static async listExamAnotherSearch(
    [idUser, querySearch, pageNumber],
    result
  ) {
    const queryText =
      "SELECT exams.id,tenlop,exams.id_subject,tenmon,`name`,time,id_course,tongCauHoi.totalQues FROM users_exam RIGHT JOIN exams ON users_exam.id_exam = exams.id LEFT JOIN (SELECT exams.id,COUNT(exams.id) AS totalQues FROM exams INNER JOIN exams_question ON exams.id = exams_question.id_exam) AS tongCauHoi ON users_exam.id_exam = tongCauHoi.id INNER JOIN tblmon ON tblmon.id = exams.id_subject INNER JOIN tbllop ON tbllop.id = exams.id_class WHERE exams.id NOT IN (SELECT users_exam.id_exam FROM users_exam WHERE users_exam.id_user = ?)" +
      " " +
      querySearch +
      " " +
      "GROUP BY exams.id ORDER BY exams.id ASC LIMIT ?,6";
    sql.query(queryText, [idUser, pageNumber], (err, info) => {
      if (err) {
        console.log("error query list exam user:", err);
        result(err, null);
      } else {
        result(null, info);
      }
    });
  }
  static async totalPageExamAnotherSearch([idUser, querySearch], result) {
    const queryText =
      "SELECT CEIL(COUNT(total.dem)/6) AS totalPage FROM (SELECT COUNT(exams.id) AS dem FROM users_exam RIGHT JOIN exams ON users_exam.id_exam = exams.id WHERE exams.id NOT IN (SELECT users_exam.id_exam FROM users_exam WHERE users_exam.id_user = ?)" +
      " " +
      querySearch +
      " " +
      "GROUP BY exams.id) AS total";
    sql.query(queryText, idUser, (err, res) => {
      if (err) {
        console.log("error total user exam page:", err);
        result(err, null);
      } else {
        result(null, res[0]);
      }
    });
  }
}
module.exports = kithiModel;
