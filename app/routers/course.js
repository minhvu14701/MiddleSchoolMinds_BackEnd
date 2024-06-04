const courseController = require("../controllers/courseController");
const router = require("express").Router();
const verifiTokenController = require("../controllers/verifiTokenController");
router.post("/another", courseController.getCourseAnother);
router.post("/addUinC", courseController.addCourseUser);
router.post("/course", courseController.getCourseUser);
router.post("/infoCourse", courseController.getInfoCourse);
router.post("/infoModule", courseController.getTitleModule);
router.post("/detailTitle", courseController.getContentTitle);
router.post("/updateStatus", courseController.updateStatusTitle);
router.post("/updatePercent", courseController.updatePercentCourse);
router.post("/addUserExam", courseController.addCourseExamUser);
router.post("/searchAnother", courseController.getCourseAnotherSearch);
router.post("/searchUser", courseController.getCourseUserSearch);
module.exports = router;
