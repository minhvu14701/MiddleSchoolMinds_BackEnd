const quesAnsController = require("../controllers/quesAnsController");
const router = require("express").Router();
const verifiTokenController = require("../controllers/verifiTokenController");

const multer = require("multer");
const path = require("path");
const storage1 = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "image/questions");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      file.fieldname + "_" + Date.now() + path.extname(file.originalname)
    );
  },
});
const upload1 = multer({
  storage: storage1,
});
const storage2 = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "image/answers");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      file.fieldname + "_" + Date.now() + path.extname(file.originalname)
    );
  },
});
const upload2 = multer({
  storage: storage2,
});

router.post("/question", quesAnsController.getQues);
router.post("/title", quesAnsController.getTitleQues);
router.post(
  "/addQuestion",
  upload1.single("imageQues"),
  verifiTokenController.verifiToken,
  quesAnsController.addQuestions
);
router.post("/filterSub", quesAnsController.getListQuesSub);
router.post("/filterSearch", quesAnsController.getListQuesSearch);
router.post(
  "/addAnswer",
  upload2.single("imageAns"),
  verifiTokenController.verifiToken,
  quesAnsController.addAnswers
);
module.exports = router;
