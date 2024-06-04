const kithiController = require("../controllers/kithiController");
const router = require("express").Router();
const verifiTokenController = require("../controllers/verifiTokenController");

router.post("/infoExam", kithiController.getCourseExam);
router.post("/result", kithiController.getResultExam);
router.post("/infoExamUser", kithiController.getCourseExamUser);
router.post("/listQuestions", kithiController.getListQuestion);
router.post("/listAnswers", kithiController.getListAnswers);
router.post("/updateStartTime", kithiController.updateStartTime);
router.post("/saveAnsRedis", kithiController.saveAnswerInRedis);
router.post("/getAnswersRedis", kithiController.getAnswerInRedis);
router.post("/saveAnsDB", kithiController.saveAnswersDatabase);
router.post("/computedScore", kithiController.computedScoreExam);
router.post("/listExamsUser", kithiController.getListExamUser);
router.post("/listExamsAnother", kithiController.getListExamAnother);
router.post("/insertUserExam", kithiController.insertUserExam);
router.post("/resultExam", kithiController.getResultExamUser);
router.post("/infoExamId", kithiController.getInfoExam);
// search
router.post("/searchExam", kithiController.getListExamUserSearch);
router.post("/searchAnother", kithiController.getListExamAnotherSearch);
module.exports = router;
