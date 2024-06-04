const otherModel = require("../models/other");
class otherController {
  static async getSub(req, res) {
    try {
      otherModel.getSubject(async (err, data) => {
        if (err) {
          res.send(err || "Error");
          console.log("Error with model");
        } else {
          res.send(data);
          console.log("Get subject Successful");
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model");
    }
  }
  static async getListClass(req, res) {
    try {
      otherModel.getClass(async (err, data) => {
        if (err) {
          res.send(err || "Error");
          console.log("Error with model");
        } else {
          res.send(data);
          console.log("Get subject Successful");
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model");
    }
  }
  //notify
  static async getUserNotify(req, res) {
    try {
      const { idUser } = req.body;
      otherModel.getNotify(idUser, async (err, data) => {
        if (err) {
          res.send(err || "Error");
          console.log("Error with model");
        } else {
          res.send(data);
          console.log("Get notify Successful");
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model");
    }
  }
  static async updateUserNotify(req, res) {
    try {
      const { idAns } = req.body;
      otherModel.updateNotify(idAns, async (err, data) => {
        if (err) {
          res.send(err || "Error");
          console.log("Error with model");
        } else {
          res.send(true);
          console.log("Updated successfully");
        }
      });
    } catch (err) {
      res.status(500).send("Don't access with model");
    }
  }
}

module.exports = otherController;
