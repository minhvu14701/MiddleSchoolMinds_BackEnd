const courseModel = require("../models/course");
class courseController {
  //lay khoa hoc khac
  static async getCourseAnother(req, res) {
    try {
      const pageNumber = (req.body.pageNumber - 1) * 6;
      const idUser = req.body.id_user;
      courseModel.getCourseAnother([idUser, pageNumber], async (err, data) => {
        if (err) {
          res.send("Error get: " + err);
          console.log("Error with model");
        } else {
          courseModel.totalCourseAnother(idUser, async (error, total) => {
            if (error) {
              res.send("Error: total: " + error);
              console.log("Error with model");
            } else {
              res.status(200).send({ data, total });
              console.log("Get question Successful");
            }
          });
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model");
      console.log("Error with controller");
    }
  }
  //lay khoa hoc khac tim kiem
  static async getCourseAnotherSearch(req, res) {
    try {
      const pageNumber = (req.body.pageNumber - 1) * 6;
      const idUser = req.body.idUser;
      const textSearch =
        req.body.textSearch == ""
          ? ""
          : `AND MATCH(name) AGAINST('${req.body.textSearch}')`;
      const classValue =
        req.body.classValue == 0
          ? ""
          : `AND course.id_lop = ${req.body.classValue}`;
      const subjectValue =
        req.body.subjectValue == 0
          ? ""
          : `AND course.id_mon = ${req.body.subjectValue}`;
      const dataSearchFilter =
        textSearch + " " + classValue + " " + subjectValue;
      courseModel.getCourseAnotherSearch(
        [idUser, dataSearchFilter, pageNumber],
        async (err, data) => {
          if (err) {
            res.send("Error get another: " + err);
            console.log("Error with model another search");
          } else {
            courseModel.totalCourseAnotherSearch(
              [idUser, dataSearchFilter],
              async (error, total) => {
                if (error) {
                  res.send("Error: total: " + error);
                  console.log("Error with model");
                } else {
                  res.status(200).send({ data, total });
                  console.log("Get question Successful");
                }
              }
            );
          }
        }
      );
    } catch (err) {
      res.status(500).send("Don't access with model");
      console.log("Error with controller");
    }
  }
  //them khoa hoc vao user
  static async addCourseUser(req, res) {
    try {
      const data = {
        id_user: req.body.id_user,
        id_course: req.body.id_course,
      };
      courseModel.addUserCourse(data, (err, result) => {
        if (err) {
          res.send("error by sql: " + err);
          console.log("Error with model");
        } else {
          console.log("Add user course Successful");
          courseModel.addUserExam(
            [data.id_course, data.id_user],
            (error, insert) => {
              if (error) {
                res.send("error by sql: " + err);
                console.log("Error with model");
              } else {
                console.log("Add user exam Successful");
                res.send({ result, insert });
              }
            }
          );
        }
      });
    } catch (err) {
      res.send("Don't access with model");
      console.log("Error with controller");
    }
  }
  //khoa hoc da dang ky
  static async getCourseUser(req, res) {
    try {
      const idUser = req.body.id_user;
      const pageNumber = (req.body.pageNumber - 1) * 6;
      courseModel.getCourse([idUser, pageNumber], async (err, data) => {
        if (err) {
          res.send("Error get: " + err);
          console.log("Error with model");
        } else {
          courseModel.totalCourse(idUser, async (error, total) => {
            if (error) {
              res.send("Error total: " + error);
              console.log("Error with model");
            } else {
              res.status(200).send({ data, total });
              console.log("Get question Successful");
            }
          });
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model");
      console.log("Error with controller");
    }
  }
  //khoa hoc da dang ky tim kiem
  static async getCourseUserSearch(req, res) {
    try {
      const idUser = req.body.idUser;
      const pageNumber = (req.body.pageNumber - 1) * 6;
      const textSearch =
        req.body.textSearch == ""
          ? ""
          : `AND MATCH(name) AGAINST('${req.body.textSearch}')`;
      const classValue =
        req.body.classValue == 0
          ? ""
          : `AND course.id_lop = ${req.body.classValue}`;
      const subjectValue =
        req.body.subjectValue == 0
          ? ""
          : `AND course.id_mon = ${req.body.subjectValue}`;
      const dataSearchFilter =
        textSearch + " " + classValue + " " + subjectValue;
      courseModel.getCourseUserSearch(
        [idUser, dataSearchFilter, pageNumber],
        async (err, data) => {
          if (err) {
            res.send("Error get: " + err);
            console.log("Error with model");
          } else {
            courseModel.totalCourseUserSearch(
              [idUser, dataSearchFilter],
              async (error, total) => {
                if (error) {
                  res.send("Error total: " + error);
                  console.log("Error with model");
                } else {
                  res.status(200).send({ data, total });
                  console.log("Get question Successful");
                }
              }
            );
          }
        }
      );
    } catch (err) {
      res.status(500).send("Don't access with model");
      console.log("Error with controller");
    }
  }
  //lấy thông tin khóa học
  static async getInfoCourse(req, res) {
    try {
      const { idCourse } = req.body;
      courseModel.course(idCourse, (err, courseInfo) => {
        if (err) {
          res.send("Error get course: " + err);
          console.log("Error with model");
        } else {
          courseModel.moduleCourse(idCourse, (error, listModule) => {
            if (error) {
              res.send("Error get list module: " + err);
              console.log("Error with model");
            } else {
              console.log("Get info course and list module successfully");
              res.status(200).send({ courseInfo, listModule });
            }
          });
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  //Lấy tiêu đề module
  static async getTitleModule(req, res) {
    try {
      const { idUser, idCourseModule } = req.body;
      courseModel.titleModule([idUser, idCourseModule], (err, data) => {
        if (err) {
          res.send("error by sql: " + err);
          console.log("Error with model");
        } else {
          console.log("get title in module success");
          res.send(data);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  //Lấy nội dung khóa học
  static async getContentTitle(req, res) {
    try {
      const { idTitleModule } = req.body;
      courseModel.contentTitle(idTitleModule, (err, data) => {
        if (err) {
          res.send("error by sql: " + err);
          console.log("Error with model");
        } else {
          console.log("get title in module success");
          res.send(data);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  //update status
  static async updateStatusTitle(req, res) {
    try {
      const { idUser, idTitleModule } = req.body;
      courseModel.updateStatus([idUser, idTitleModule], (err, data) => {
        if (err) {
          res.send("error by sql: " + err);
          console.log("Error with model");
        } else {
          console.log("Update status success");
          res.send("Update status success");
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  static async updatePercentCourse(req, res) {
    try {
      const { idUser, idCourse } = req.body;
      courseModel.updatePercent([idUser, idCourse], (err, data) => {
        if (err) {
          res.send("error by sql: " + err);
          console.log("Error with model");
        } else {
          console.log("Update percent success");
          res.send("Update percent success");
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  static async addCourseExamUser(req, res) {
    try {
      const { idUser, idCourse } = req.body;
      courseModel.addUserExam([idCourse, idUser], (err, data) => {
        if (err) {
          res.send("error by sql: " + err);
          console.log("Error with model");
        } else {
          console.log("add exam user success");
          res.send(data);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
}

module.exports = courseController;
