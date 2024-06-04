const quesAnsModel = require("../models/quesAns");
class quesAnsController {
  //Lấy list câu hỏi đã phân trang
  static async getQues(req, res) {
    try {
      const pageNumber = (req.body.pageNumber - 1) * 6;
      quesAnsModel.getQuesion(pageNumber, async (err, data) => {
        if (err) {
          res.send(err || "Error");
          console.log("Error with model");
        } else {
          quesAnsModel.getTotalPage(async (err, total) => {
            if (err) {
              res.send(err || "Error");
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
    }
  }
  //Lấy list danh sách câu hỏi theo môn
  static async getListQuesSub(req, res) {
    try {
      const pageNumber = (req.body.pageNumber - 1) * 6;
      const subjectId = req.body.subjectId;
      quesAnsModel.getQuesSub([subjectId, pageNumber], async (err, data) => {
        if (err) {
          res.send(err || "Error");
          console.log("Error with model");
        } else {
          quesAnsModel.getTotalSub(subjectId, async (err, total) => {
            if (err) {
              res.send(err || "Error");
              console.log("Error with model");
            } else {
              res.status(200).send({ data, total });
              console.log("Get question by subject Successful");
            }
          });
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model");
    }
  }
  //Lấy list danh sách câu hỏi theo tìm kiếm
  static async getListQuesSearch(req, res) {
    try {
      const pageNumber = (req.body.pageNumber - 1) * 6;
      const textSearch = req.body.textSearch;
      quesAnsModel.getQuesSearch(
        [textSearch, pageNumber],
        async (err, data) => {
          if (err) {
            res.send(err || "Error");
            console.log("Error with model");
          } else {
            quesAnsModel.getTotalSearch(textSearch, async (err, total) => {
              if (err) {
                res.send(err || "Error");
                console.log("Error with model");
              } else {
                res.status(200).send({ data, total });
                console.log("Get question by subject Successful");
              }
            });
          }
        }
      );
    } catch (err) {
      res.status(500).send("Don't access with model");
    }
  }
  //Lấy tiêu đề từng câu hỏi
  static async getTitleQues(req, res) {
    try {
      const quesId = req.body.quesId;
      if (quesId) {
        quesAnsModel.getTitle(quesId, async (err, data) => {
          if (err) {
            res.send(err || "Error");
            console.log("Error with model getTitle:", err);
          } else {
            quesAnsModel.getAnswer(quesId, async (error, answer) => {
              if (error) {
                res.send(error || "Error");
                console.log("Error with model getAnswer:", error);
              } else {
                res.status(200).json({ data, answer });
              }
            });
          }
        });
      } else {
        console.log("Ma cau hoi k ton tai");
        res.status(403).send("Question id not exist");
      }
    } catch (err) {
      res.status(500).send("Don't access with model");
    }
  }
  //Thêm câu hỏi
  static async addQuestions(req, res) {
    try {
      const { idUser, idMon, content, imageQuestion } = req.body;
      const dateQues = new Date();
      const imageQues = req.file ? req.file.filename : imageQuestion;
      quesAnsModel.addQuestion(
        [idUser, idMon, content, imageQues, dateQues],
        (err, data) => {
          if (err) {
            console.log("Error with model: ", err);
            res.send(false);
          } else {
            res.status(200).send(true);
          }
        }
      );
    } catch (error) {
      console.log(error);
      res.status(401).send(error);
    }
  }
  //Thêm câu tra loi
  static async addAnswers(req, res) {
    try {
      const { idUser, idQues, contentAdd, imageAns } = req.body;
      const image = req.file ? req.file.filename : null;
      const dateAns = new Date();
      quesAnsModel.addAnswer(
        [idUser, idQues, contentAdd, image, dateAns],
        (err, data) => {
          if (err) {
            console.log("Error with model: ", err);
            res.send(false);
          } else {
            console.log("Add Answer Success");
            res.status(200).send(true);
          }
        }
      );
    } catch (error) {
      console.log(error);
      res.status(401).send(error);
    }
  }
}

module.exports = quesAnsController;
