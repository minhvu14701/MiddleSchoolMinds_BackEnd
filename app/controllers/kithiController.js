const kithiModel = require("../models/kithiModel.js");
const client = require("../config/InitRedis.js");
class kithiController {
  static async getCourseExam(req, res) {
    try {
      const { idCourse } = req.body;
      kithiModel.getExamCourse(idCourse, (error, exam) => {
        if (error) {
          res.send("error by sql: " + error);
          console.log("Error with model");
        } else {
          res.status(200).send(exam);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  static async getResultExam(req, res) {
    try {
      const { idUser, idCourse } = req.body;
      kithiModel.resultExamUSer([idUser, idCourse], (error, info) => {
        if (error) {
          res.send("error by sql: " + error);
          console.log("Error with model");
        } else {
          res.status(200).send(info);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  static async getCourseExamUser(req, res) {
    try {
      const { idUserExam } = req.body;
      kithiModel.getExamCourseUser(idUserExam, (error, exam) => {
        if (error) {
          res.send("error by sql: " + error);
          console.log("Error with model");
        } else {
          client.get(`ExamTime-${idUserExam}`, (loi, time) => {
            if (loi) {
              console.log("error with redis get:" + loi);
            } else {
              res.status(200).send({ exam, time });
            }
          });
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  //Lay list question exam
  static async getListQuestion(req, res) {
    try {
      const { idExam } = req.body;
      kithiModel.listQuestions(idExam, (error, exam) => {
        if (error) {
          res.send("error by sql: " + error);
          console.log("Error with model");
        } else {
          res.status(200).send(exam);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  //get list answers exam
  static async getListAnswers(req, res) {
    try {
      const { idQues } = req.body;
      kithiModel.listAnswers(idQues, (error, exam) => {
        if (error) {
          res.send("error by sql: " + error);
          console.log("Error with model");
        } else {
          res.status(200).send(exam);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  //update status start time
  static async updateStartTime(req, res) {
    try {
      const { idUserQues, time } = req.body;
      const startTime = new Date();
      kithiModel.updateStartTimeStatus(
        [startTime, idUserQues],
        (error, exam) => {
          if (error) {
            res.send("error by sql: " + error);
            console.log("Error with model");
          } else {
            res.status(200).send("update successful");
            client.set(`ExamTime-${idUserQues}`, time, (err, reply) => {
              if (err) {
                console.log("error with client set:" + err);
              } else {
                const countdownTime = setInterval(() => {
                  client.decr(`ExamTime-${idUserQues}`, (error, result) => {
                    if (error) {
                      console.log("error decr:" + error);
                    } else {
                      if (result > 0) {
                        client.set(`ExamTime-${idUserQues}`, result);
                      } else if (result == 0 || result < 0) {
                        client.del(`ExamTime-${idUserQues}`, (loi, ketqua) => {
                          if (ketqua == 1) {
                            console.log("Delete key time successfully");
                          }
                        });
                        clearInterval(countdownTime);
                      }
                    }
                  });
                }, 1000);
              }
            });
          }
        }
      );
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  //save answers in database
  static async saveAnswersDatabase(req, res) {
    try {
      const { idUserExam, answers } = req.body;
      const values = answers.map((answer) => [
        idUserExam,
        answer.questionId,
        answer.answerId,
        1,
      ]);
      console.log(idUserExam);
      kithiModel.saveAnsMysql(values, (error, result) => {
        if (error) {
          console.error("Error inserting data into MySQL:", error);
          return res.status(500).send(error);
        } else {
          res.status(200).send("Answers submitted successfully");
        }
      });
    } catch (err) {
      console.log("Error with controller");
    }
  }
  //save answers in redis
  static async saveAnswerInRedis(req, res) {
    try {
      // const { idUserExam, quesId, ansId } = req.body;
      // console.log(quesId + ":" + ansId);
      // client.hset(`Exam-${idUserExam}`, quesId, ansId, (err, response) => {
      //   if (err) return res.status(500).send(err);
      // });
      const { idUserExam, quesId, ansId } = req.body;
      // Log khi bắt đầu xử lý request
      console.log(
        `Received request: idUserExam=${idUserExam}, quesId=${quesId}, ansId=${ansId}`
      );
      client.hset(`Exam-${idUserExam}`, quesId, ansId, (err, response) => {
        if (err) {
          console.error(`Redis error: ${err}`);
          return res.status(500).send({ error: "Could not save answer" });
        } else {
          console.log(`Redis response for Exam-${idUserExam}: ${response}`);
          res.status(200).send({ message: "Answer saved successfully" });
        }
      });
    } catch (error) {
      console.log("Loi khong gui duoc dap an:" + error);
    }
  }
  static async getAnswerInRedis(req, res) {
    const { idUserExam } = req.body;
    client.hgetall(`Exam-${idUserExam}`, (err, answers) => {
      if (err) return res.status(500).send(err);
      res.status(200).json(answers);
    });
  }
  //computed score
  static async computedScoreExam(req, res) {
    try {
      const { idUserExam } = req.body;
      kithiModel.computedScore(idUserExam, (error, result) => {
        if (error) {
          console.error("Error computed score:", error);
          return res.status(500).send(error);
        } else {
          client.del(`Exam-${idUserExam}`, (loi, ketqua) => {
            if (ketqua == 1) {
              console.log("Delete key answers successfully");
            }
          });
          client.del(`ExamTime-${idUserExam}`, (loi, ketqua) => {
            if (ketqua == 1) {
              console.log("Delete key time successfully");
            }
          });
          res.status(200).send("Answers submitted successfully");
        }
      });
    } catch (err) {
      console.log("Error controller:" + err);
    }
  }
  //Khoa hoc cua ban
  static async getListExamUser(req, res) {
    try {
      const pageNumber = (req.body.pageNumber - 1) * 6;
      const idUser = req.body.id_user;
      kithiModel.listExamUser([idUser, pageNumber], async (err, data) => {
        if (err) {
          res.send("Error get: " + err);
          console.log("Error with model");
        } else {
          kithiModel.totalPageExamUser(idUser, async (error, total) => {
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
  //Khoa hoc cua ban search exam name
  static async getListExamUserSearch(req, res) {
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
          : `AND exams.id_class = ${req.body.classValue}`;
      const subjectValue =
        req.body.subjectValue == 0
          ? ""
          : `AND exams.id_subject = ${req.body.subjectValue}`;
      const querySearch = textSearch + " " + classValue + " " + subjectValue;
      kithiModel.listExamUserSearch(
        [idUser, querySearch, pageNumber],
        async (err, data) => {
          if (err) {
            res.send("Error get: " + err);
            console.log("Error with model");
          } else {
            kithiModel.totalPageExamUserSearch(
              [idUser, querySearch],
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
  //Khoa hoc chưa đăng ký
  static async getListExamAnother(req, res) {
    try {
      const pageNumber = (req.body.pageNumber - 1) * 6;
      const idUser = req.body.id_user;
      kithiModel.listExamAnother([idUser, pageNumber], async (err, data) => {
        if (err) {
          res.send("Error get: " + err);
          console.log("Error with model");
        } else {
          kithiModel.totalPageExamAnother(idUser, async (error, total) => {
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
  //Khoa hoc chưa đăng ký search exam name
  static async getListExamAnotherSearch(req, res) {
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
          : `AND exams.id_class = ${req.body.classValue}`;
      const subjectValue =
        req.body.subjectValue == 0
          ? ""
          : `AND exams.id_subject = ${req.body.subjectValue}`;
      const querySearch = textSearch + " " + classValue + " " + subjectValue;
      kithiModel.listExamAnotherSearch(
        [idUser, querySearch, pageNumber],
        async (err, data) => {
          if (err) {
            res.send("Error get: " + err);
            console.log("Error with model");
          } else {
            kithiModel.totalPageExamAnotherSearch(
              [idUser, querySearch],
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
  //Thêm dữ liệu vào userExam
  static async insertUserExam(req, res) {
    try {
      const { idUser, idExam } = req.body;
      kithiModel.insertUserExam([idUser, idExam], (error, exam) => {
        if (error) {
          res.send("error by sql: " + error);
          console.log("Error with model");
        } else {
          res.status(200).send("Insert Success");
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  //Lay ket qua nguoi dung da thi
  static async getResultExamUser(req, res) {
    try {
      const { idUser, idExam } = req.body;
      kithiModel.getResultExamUser([idUser, idExam], (error, result) => {
        if (error) {
          res.send("error by sql: " + error);
          console.log("Error with model");
        } else {
          res.status(200).send(result);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
  // Lấy thông tin kì thi qua idExam
  static async getInfoExam(req, res) {
    try {
      const { idExam } = req.body;
      kithiModel.getInfoExam(idExam, (error, result) => {
        if (error) {
          res.send("error by sql: " + error);
          console.log("Error with model");
        } else {
          res.status(200).send(result);
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model:" + err);
      console.log("Error with controller");
    }
  }
}
module.exports = kithiController;
