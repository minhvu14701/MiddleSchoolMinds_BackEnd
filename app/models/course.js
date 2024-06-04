const sql = require("../models/index");
class courseModel {
  //Danh sách khóa học khac
  static async getCourseAnother([idUser, pageNumber], result) {
    sql.query(
      "SELECT course.id, tenlop,tenmon,`name`,course.image,user_course.id_user,course.id_mon FROM course LEFT JOIN user_course ON course.id =  user_course.id_course INNER JOIN tbllop ON tbllop.id = course.id_lop INNER JOIN tblmon ON tblmon.id = course.id_mon WHERE course.id NOT IN (SELECT user_course.id_course FROM user_course WHERE user_course.id_user = ?) GROUP BY course.id ORDER BY course.id ASC LIMIT ?,6",
      [idUser, pageNumber],
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
          result(err, null);
          return;
        } else {
          result(null, res);
          return;
        }
      }
    );
  }
  static async totalCourseAnother(idUser, result) {
    sql.query(
      "SELECT CEIL(COUNT(total.dem)/6) AS totalPage FROM (SELECT COUNT(course.id) AS dem FROM course LEFT JOIN user_course ON course.id =  user_course.id_course WHERE course.id NOT IN (SELECT user_course.id_course FROM user_course WHERE user_course.id_user = ?) GROUP BY course.id) AS total",
      idUser,
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
          result(err, null);
          return;
        } else {
          result(null, res[0]);
          return;
        }
      }
    );
  }
  //Danh sách khóa học khac timf kiem
  static async getCourseAnotherSearch(
    [idUser, dataSearchFilter, pageNumber],
    result
  ) {
    const queryText =
      "SELECT course.id, tenlop,tenmon,`name`,course.image,user_course.id_user,course.id_mon FROM course LEFT JOIN user_course ON course.id =  user_course.id_course INNER JOIN tbllop ON tbllop.id = course.id_lop INNER JOIN tblmon ON tblmon.id = course.id_mon WHERE course.id NOT IN (SELECT user_course.id_course FROM user_course WHERE user_course.id_user = ?)" +
      " " +
      dataSearchFilter +
      " " +
      "GROUP BY course.id ORDER BY course.id ASC LIMIT ?,6";
    sql.query(queryText, [idUser, pageNumber], (err, res) => {
      if (err) {
        console.log("ERROR mySql:", err);
        result(err, null);
        return;
      } else {
        result(null, res);
        return;
      }
    });
  }
  static async totalCourseAnotherSearch([idUser, dataSearchFilter], result) {
    const queryText =
      "SELECT CEIL(COUNT(total.dem)/6) AS totalPage FROM (SELECT COUNT(course.id) AS dem FROM course LEFT JOIN user_course ON course.id =  user_course.id_course WHERE course.id NOT IN (SELECT user_course.id_course FROM user_course WHERE user_course.id_user = ?)" +
      " " +
      dataSearchFilter +
      " " +
      "GROUP BY course.id) AS total";
    sql.query(queryText, idUser, (err, res) => {
      if (err) {
        console.log("ERROR mySql:", err);
        result(err, null);
        return;
      } else {
        result(null, res[0]);
        return;
      }
    });
  }
  //them khoa hoc
  static async addUserCourse(data, result) {
    sql.query("INSERT INTO user_course SET ?", data, (err, res) => {
      if (err) {
        console.log("ERROR mySql:", err);
        result(err, null);
        return;
      } else {
        result(null, res);
        sql.query("CALL addUseCM(?, ?)", [data.id_user, data.id_course]);
        return;
      }
    });
  }
  static async addUserExam([id_course, id_user], result) {
    sql.getConnection((err, conn) => {
      if (err) {
        console.log("error: ", err);
      } else {
        conn.query(
          "SELECT id FROM exams WHERE id_course = ?",
          id_course,
          (error, res) => {
            if (error) {
              console.log("error query: ", error);
              result(error, null);
            } else {
              var idExam = res[0].id;
              conn.query(
                "INSERT INTO users_exam SET users_exam.id_user = ?, users_exam.id_exam = ?",
                [id_user, idExam],
                (loi, insert) => {
                  if (loi) {
                    console.log("error query: ", loi);
                    result(loi, null);
                  } else {
                    console.log("Insert course exam successfully");
                    result(null, true);
                  }
                  conn.release();
                }
              );
            }
          }
        );
      }
    });
  }
  //khoa hoc da dang ky
  static async getCourse([idUser, pageNumber], result) {
    sql.query(
      "SELECT course.id, tenlop,tenmon,`name`,course.image,user_course.id_user,course.id_mon,user_course.percent FROM course INNER JOIN user_course ON course.id =  user_course.id_course INNER JOIN tbllop ON tbllop.id = course.id_lop INNER JOIN tblmon ON tblmon.id = course.id_mon WHERE user_course.id_user = ? ORDER BY course.id ASC LIMIT ?,6",
      [idUser, pageNumber],
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
          result(err, null);
          return;
        } else {
          if (res[0] == null) {
            result(null, false);
          } else {
            result(null, res);
          }
          return;
        }
      }
    );
  }
  static async totalCourse(idUser, result) {
    sql.query(
      "SELECT CEIL(COUNT(course.id)/6) AS totalPage FROM course INNER JOIN user_course ON course.id =  user_course.id_course WHERE user_course.id_user = ? ",
      idUser,
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
          result(err, null);
          return;
        } else {
          result(null, res[0]);
          return;
        }
      }
    );
  }
  //Tìm kiếm theo khóa học đã đăng ký
  static async getCourseUserSearch(
    [idUser, dataSearchFilter, pageNumber],
    result
  ) {
    const queryText =
      "SELECT course.id, tenlop,tenmon,`name`,course.image,user_course.id_user, course.id_mon,user_course.percent FROM course INNER JOIN user_course ON course.id =  user_course.id_course INNER JOIN tbllop ON tbllop.id = course.id_lop INNER JOIN tblmon ON tblmon.id = course.id_mon WHERE user_course.id_user = ?" +
      " " +
      dataSearchFilter +
      " " +
      "ORDER BY course.id ASC LIMIT ?,6";
    sql.query(queryText, [idUser, pageNumber], (err, res) => {
      if (err) {
        console.log("ERROR mySql:", err);
        result(err, null);
        return;
      } else {
        if (res[0] == null) {
          result(null, false);
        } else {
          result(null, res);
        }
        return;
      }
    });
  }
  static async totalCourseUserSearch([idUser, dataSearchFilter], result) {
    const queryText =
      "SELECT CEIL(COUNT(course.id)/6) AS totalPage FROM course INNER JOIN user_course ON course.id =  user_course.id_course WHERE user_course.id_user = ?" +
      " " +
      dataSearchFilter;
    console.log(queryText);
    sql.query(queryText, idUser, (err, res) => {
      if (err) {
        console.log("ERROR mySql:", err);
        result(err, null);
        return;
      } else {
        result(null, res[0]);
        return;
      }
    });
  }
  //Hiển thị nội dung khóa học
  //thông tin khóa học
  static async course(idCourse, result) {
    sql.query("SELECT * FROM course WHERE id = ? ", idCourse, (err, res) => {
      if (err) {
        console.log("ERROR mySql:", err);
        result(err, null);
        return;
      } else {
        result(null, res[0]);
        return;
      }
    });
  }
  //thông tin module
  static async moduleCourse(idCourse, result) {
    sql.query(
      "SELECT * FROM course_module WHERE course_module.course_id = ? ",
      idCourse,
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
          result(err, null);
          return;
        } else {
          result(null, res);
          return;
        }
      }
    );
  }
  //danh sách tiêu đề của module
  static async titleModule([idUser, idCourseModule], result) {
    sql.query(
      "SELECT title_module.id,title_module.title_TM,position_TM,`status` FROM title_module INNER JOIN user_cm ON title_module.id = user_cm.id_TM WHERE user_cm.id_user = ? AND title_module.id_CM = ? ",
      [idUser, idCourseModule],
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
          result(err, null);
          return;
        } else {
          result(null, res);
          return;
        }
      }
    );
  }
  //nội dung của tiêu đề
  static async contentTitle(idTitleModule, result) {
    sql.query(
      "SELECT type, content_link,subContent,size,detail_title.position FROM detail_title WHERE detail_title.id_TM = ?",
      idTitleModule,
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
          result(err, null);
          return;
        } else {
          result(null, res);
          return;
        }
      }
    );
  }
  //update status course details
  static async updateStatus([idUser, idTitleModule], result) {
    sql.query(
      "UPDATE user_cm SET `status` = 1 WHERE user_cm.id_user = ? AND user_cm.id_TM = ?",
      [idUser, idTitleModule],
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
          result(err, null);
          return;
        } else {
          result(null, res);
          return;
        }
      }
    );
  }
  static async updatePercent([idUser, idCourse], result) {
    sql.query(
      "UPDATE user_course SET user_course.percent = ((( SELECT COUNT(title_module.id) FROM user_cm INNER JOIN title_module ON user_cm.id_TM = title_module.id WHERE user_cm.id_user = ? AND title_module.id_Course = ? AND `status` = 1) /  (SELECT COUNT(title_module.id) FROM title_module WHERE title_module.id_Course = ? )) * 100) WHERE user_course.id_user =  ? AND user_course.id_course = ?",
      [idUser, idCourse, idCourse, idUser, idCourse],
      (err, res) => {
        if (err) {
          console.log("ERROR mySql:", err);
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
module.exports = courseModel;
