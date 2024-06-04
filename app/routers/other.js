const otherController = require("../controllers/otherController");
const router = require("express").Router();
router.get("/subject", otherController.getSub);
router.get("/class", otherController.getListClass);
router.post("/getUserNotify", otherController.getUserNotify);
router.post("/updateUserNotify", otherController.updateUserNotify);

module.exports = router;
