const userController = require("../controllers/userController.js");
const verifiTokenController = require("../controllers/verifiTokenController");

const router = require("express").Router();
const multer = require("multer");
const path = require("path");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "image/avatars");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      file.fieldname + "_" + Date.now() + path.extname(file.originalname)
    );
  },
});
const upload = multer({
  storage: storage,
});
//register
router.post("/register", userController.register);
router.post("/login", userController.login);
router.post("/refresh", userController.requestRefreshToken);
router.post("/infoUser", userController.userInfo);
router.post("/editUser", upload.single("avatar"), userController.editUserInfo);
module.exports = router;
