-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 05, 2024 lúc 01:59 AM
-- Phiên bản máy phục vụ: 10.4.27-MariaDB
-- Phiên bản PHP: 8.2.0

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `datn`
--
CREATE DATABASE IF NOT EXISTS `datn` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `datn`;

DELIMITER $$
--
-- Thủ tục
--
DROP PROCEDURE IF EXISTS `addUseCM`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUseCM` (IN `idUser` INT(11), IN `idCourse` INT(11))   BEGIN
	DECLARE total INT(11) DEFAULT -1;
	DECLARE i INT(11) DEFAULT 0;
	DECLARE idModule INT(11) DEFAULT 0;
	SELECT COUNT(title_module.id) INTO total FROM title_module WHERE title_module.id_Course = idCourse;
	WHILE ( i < total) DO
		SELECT title_module.id INTO idModule FROM title_module WHERE title_module.id_Course = idCourse ORDER BY title_module.id ASC LIMIT i,1;
		INSERT INTO user_cm SET user_cm.id_TM = idModule, user_cm.id_user = idUser, user_cm.`status` = 0;
		SET i = i + 1;
	END WHILE;
END$$

DROP PROCEDURE IF EXISTS `computedScore`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `computedScore` (IN `idExamUser` INT)   BEGIN
		DECLARE scored FLOAT;
    DECLARE total INT DEFAULT 1;
    DECLARE reply INT DEFAULT 1;
    DECLARE i INT DEFAULT 0;
    DECLARE correct INT DEFAULT 0;
    DECLARE idExam INT;
    DECLARE idQues INT;
    DECLARE idAns INT;
    DECLARE isCorrected INT;
    -- Lấy idExam từ bảng users_exam
    SELECT id_exam INTO idExam FROM users_exam WHERE users_exam.id = idExamUser;
    -- Đếm tổng số câu hỏi trong kỳ thi
    SELECT COUNT(exams_question.id) INTO total FROM exams_question WHERE exams_question.id_exam = idExam;
    -- Đếm số câu hỏi đã trả lời
    SELECT COUNT(users_answers.id_ques) INTO reply FROM users_answers WHERE users_answers.id_userExam = idExamUser;
    -- Vòng lặp để kiểm tra từng câu trả lời của người dùng
    WHILE (i < reply) DO
        -- Lấy id câu hỏi và id câu trả lời của người dùng theo thứ tự tăng dần
        SELECT users_answers.id_ques, users_answers.id_answer INTO idQues, idAns 
        FROM users_answers 
        WHERE users_answers.id_userExam = idExamUser 
        ORDER BY users_answers.id_ques ASC 
        LIMIT i, 1;
        -- Kiểm tra câu trả lời có đúng không
        SELECT COUNT(exams_answer.id) INTO isCorrected 
        FROM exams_answer 
        WHERE exams_answer.id_ques = idQues AND exams_answer.id = idAns AND exams_answer.isCorrect = 1;
        -- Nếu câu trả lời đúng, tăng biến correct
        IF (isCorrected = 1) THEN 
            SET correct = correct + 1;
        END IF;
        -- Tăng biến đếm vòng lặp
        SET i = i + 1;
    END WHILE;
    -- Tính điểm và làm tròn đến 2 chữ số thập phân
    SET scored = ROUND((correct/total*10), 2);
		UPDATE users_exam SET users_exam.end_time = NOW(), users_exam.`status` = 2, users_exam.score = scored WHERE users_exam.id = idExamUser;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `answer`
--

DROP TABLE IF EXISTS `answer`;
CREATE TABLE `answer` (
  `id` int(11) NOT NULL,
  `id_ques` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `content` text NOT NULL,
  `imageAns` varchar(255) DEFAULT NULL,
  `date` datetime NOT NULL,
  `statusNo` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `answer`
--

INSERT INTO `answer` (`id`, `id_ques`, `id_user`, `content`, `imageAns`, `date`, `statusNo`) VALUES
(11, 147, 112, '', 'imageAns_1713760898299.JPG', '2024-04-22 11:41:38', 1),
(12, 147, 112, '', 'imageAns_1713760947865.JPG', '2024-04-22 11:42:27', 1),
(21, 147, 125, 'tesst them cau tra loi', 'imageAns_1716696086156.JPG', '2024-05-26 11:01:26', 1),
(22, 147, 130, 'Tesst cau tra loi', NULL, '2024-06-05 01:07:39', 0),
(23, 147, 130, 'Test lan 2', NULL, '2024-06-05 01:07:51', 0),
(24, 147, 131, 'Vừa test câu trả lời vừa test đăng nhập bằng google', NULL, '2024-06-05 01:08:51', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `course`
--

DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `id_mon` int(11) NOT NULL,
  `id_lop` int(11) NOT NULL,
  `image` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `course`
--

INSERT INTO `course` (`id`, `name`, `id_mon`, `id_lop`, `image`) VALUES
(1, 'Chiến tranh thế giới thứ nhất', 7, 3, 'https://i.postimg.cc/8kLHM0D6/CTTG1-1.jpg'),
(2, 'Test làm ui1', 1, 1, 'https://i.postimg.cc/fTxCJGZ9/CTTG1-7.jpg'),
(3, 'Test làm ui 2', 5, 2, 'https://i.postimg.cc/fTxCJGZ9/CTTG1-7.jpg'),
(4, 'test làm ui 3', 5, 2, 'https://i.postimg.cc/BZH2vyKF/CTTG1-4.png'),
(5, 'Test làm ui 4', 8, 2, 'https://i.postimg.cc/fTxCJGZ9/CTTG1-7.jpg'),
(6, 'test làm ui 5', 8, 2, 'https://i.postimg.cc/fTxCJGZ9/CTTG1-7.jpg'),
(7, 'test lam ui 6', 7, 1, 'https://i.postimg.cc/0j5k7gFy/CTTG1-8.jpg'),
(8, 'Làm để thử nghiệm tìm kiếm', 3, 2, 'https://i.postimg.cc/BZH2vyKF/CTTG1-4.png');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `course_module`
--

DROP TABLE IF EXISTS `course_module`;
CREATE TABLE `course_module` (
  `id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `title` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `course_module`
--

INSERT INTO `course_module` (`id`, `course_id`, `position`, `title`) VALUES
(1, 1, 1, 'Tóm tắt'),
(2, 1, 2, 'Nguyên nhân của chiến tranh'),
(3, 1, 3, 'Diễn biến của chiến tranh thế giới thứ nhất(1914-1918)'),
(4, 1, 4, 'Kết cục của cuộc chiến tranh thế giới thứ nhất'),
(5, 2, 1, 'Test xem lỗi data không'),
(6, 2, 2, 'test ui 2'),
(7, 2, 3, 'test 3');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `detail_title`
--

DROP TABLE IF EXISTS `detail_title`;
CREATE TABLE `detail_title` (
  `id` int(11) NOT NULL,
  `id_TM` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `content_link` text NOT NULL,
  `size` int(11) DEFAULT NULL,
  `subContent` text DEFAULT NULL,
  `position` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `detail_title`
--

INSERT INTO `detail_title` (`id`, `id_TM`, `type`, `content_link`, `size`, `subContent`, `position`) VALUES
(1, 1, 2, 'https://www.youtube.com/embed/wBqOAyAHO10?si=_nOGwx0zJv_AI8OE', NULL, 'Tóm tắt nhanh CTTG thứ nhất (EZ sử)', 1),
(2, 2, 1, 'Chiến tranh thế giới thứ nhất, còn được gọi là Đại chiến thế giới lần thứ nhất, Thế chiến thứ nhất hay Đệ nhất thế chiến, diễn ra từ tháng 8 năm 1914 đến tháng 11 năm 1918, là một trong những cuộc chiến tranh quyết liệt, quy mô to lớn nhất trong lịch sử nhân loại; về quy mô và sự khốc liệt nó chỉ đứng sau Chiến tranh thế giới thứ hai.\r\n\r\nCuộc chiến tranh này là một trong những sự kiện lịch sử có ảnh hưởng lớn nhất trong lịch sử thế giới.[1] Đây là cuộc chiến tranh có chiến trường chính bao trùm khắp châu Âu và ảnh hưởng ra toàn thế giới, lôi kéo tất cả các cường quốc châu Âu và Bắc Mỹ vào vòng chiến với số người chết trên 20 triệu người với sức tàn phá và ảnh hưởng về vật chất tinh thần cho nhân loại rất sâu sắc và lâu dài. Khác với các cuộc chiến tranh trước đó, người Âu châu phải chiến đấu cả trên chiến trường lẫn ở hậu phương. Phụ nữ phải làm việc thay nam giới, đồng thời sự phát triển của kỹ nghệ cũng có ảnh hưởng đến tính chất chiến tranh; có thể thấy sự hiệu quả của xe tăng trong chiến đấu kể từ cuộc Đại chiến này. Chiến tranh chiến hào gắn liền với cuộc Đại chiến thế giới lần thứ nhất trong thời gian đầu của nó.\r\n\r\nĐây là cuộc chiến giữa phe Hiệp Ước (chủ yếu là Anh, Pháp, Nga, Ý và sau đó là Hoa Kỳ, Brasil) và phe Liên Minh (chủ yếu là Đức, Thổ Ottoman, Áo-Hung và Bulgaria). Cuộc Đại chiến mở đầu với sự kiện Hoàng thái tử Áo-Hung bị ám sát, dẫn đến việc người Áo - Hung tuyên chiến với Serbia. Sự kiện này được nối tiếp bởi việc Hoàng đế Đức là Wilhelm II truyền lệnh cho các tướng xua quân tấn công Bỉ, Luxembourg, và Pháp, theo kế hoạch schlieffen. Hơn 70 triệu quân nhân được huy động ra trận tiền, trong số đó có 60 triệu người Âu châu, trong một trong những cuộc chiến tranh lớn nhất trong sử sách. Trong cuộc chiến tranh kinh hoàng này, Pháp là nước chịu tổn thất nặng nề hơn cả và hoàn toàn bị khánh kiệt, dẫn tới đại bại của bọn họ trong các cuộc chiến tranh về sau. Những trận đánh khốc liệt nhất trong cuộc Chiến tranh thế giới lần thứ nhất cũng diễn ra trên đất Pháp. Một trận đánh đáng nhớ của cuộc Đại chiến là tại Verdun cùng năm đó, khi quân Đức tấn công thành cổ Verdun của Pháp, nhưng không thành công. Song, trận chiến đẫm máu nhất là tại sông Somme (1916), khi liên quân Anh - Pháp đánh bất phân thắng bại với quân Đức.\r\n\r\nTất cả những Đế quốc quân chủ đều sụp đổ trong cuộc chiến tranh này, nó tạo điều kiện cho đảng Bolshevik lên nắm quyền tại nước Nga, và mở đường cho Adolf Hitler lên nắm quyền tại Đức. Tuy nước Đức thua cuộc nhưng về thương mại và công nghiệp họ không bị tổn hại gì lớn (ít ra còn hơn hẳn Pháp), vì thế về những mặt này họ đã chiến thắng cuộc Chiến tranh thế giới lần thứ nhất. Không có một nước nào thật sự chiến thắng cuộc chiến tranh này. Sau chiến tranh, châu Âu lâm vào tình trạng khủng hoàng và những cao trào dân tộc chủ nghĩa trỗi dậy ở các nước bại trận. Điển hình là ở Thổ Nhĩ Kỳ, bão táp phong trào Cách mạng Giải phóng Dân tộc rầm rộ, đưa dân tộc này dần dần hồi phục, và buộc phe Entente phải xóa bỏ những điều khoản khắc nghiệt sau khi cuộc Chiến tranh thế giới lần thứ nhất chấm dứt.\r\n\r\nTrước đây ở các nước nói tiếng Anh dùng từ \"Đại chiến\" (Great War). Vài thập kỷ sau, tên gọi Chiến tranh thế giới lần thứ nhất (World War I) mới được áp dụng để phân biệt với cuộc Chiến tranh thế giới thứ hai. Chính những vấn đề liên quan tới Hiệp định Versailles (1918) đã khiến cho cuộc Chiến tranh thế giới lần thứ hai bùng nổ.', NULL, NULL, 1),
(3, 2, 3, 'https://i.postimg.cc/HkQYTy3g/CTTG1.jpg', 400, NULL, 2),
(4, 3, 1, '-Chủ nghĩa tư bản phát triển theo quy luật không đều làm thay đổi sâu sắc lực lượng giữa các đế quốc ở cuối XIX đầu XX.\r\n-Sự phân chia thuộc địa giữa các đế quốc cũng không đều. Đế quốc già (Anh, Pháp) nhiều thuộc địa. Đế quốc trẻ (Đức, Mĩ) ít thuộc địa.\r\nMâu thuẫn giữa các đế quốc về vấn đề thuộc địa nảy sinh và ngày càng gay gắt.\r\n-Các cuộc chiến tranh giành thuộc địa đã nổ ra ở nhiều nơi vào cuối thế kỷ XIX:', NULL, NULL, 1),
(5, 3, 3, 'https://i.postimg.cc/5ytxS4hk/bang1.png', 900, NULL, 2),
(6, 3, 1, '-Trong cuộc chạy đua giành giật thuộc địa, Đức là kẻ hiếu chiến nhất, lại ít thuộc địa . Đức đã cùng Áo - Hung, Italia thành lập “phe Liên Minh”, năm 1882 chuẩn bị chiến tranh chia lại thế giới.\r\n-Để đối phó Anh đã ký với Nga và Pháp những Hiệp ước tay đôi hình thành phe Hiệp ước (đầu thế kỉ XX).\r\n-Đầu thế kỉ XX ở châu Âu đã hình thành 2 khối quân sự đối đầu nhau, âm mưu xâm lược, cướp đoạt lãnh thổ và thuộc địa của nhau, điên cuồng chạy đua vũ trang, chuẩn bị cho chiến tranh, một cuộc chiến tranh đế quốc nhằm phân chia thị trường thế giới không thể tránh khỏi.', NULL, NULL, 3),
(7, 3, 3, 'https://i.postimg.cc/XNcgmVTD/CTTG1-2.jpg', 400, 'Hai khối :màu đỏ khối Liên Mimh,màu xanh khối Hiệp ước', 4),
(8, 4, 1, '<b>* Nguyên nhân sâu xa:</b>\n   + Sự phát triển không đều của các nước đế quốc ,mâu thuẫn giữa các đế quốc  về thuộc  địa ngày càng gay gắt( trước tiên là giữa đế quốc Anh với đế quốc Đức) là nguyên nhân cơ bản dẫn đến chiến tranh.\n   +  Sự tranh  giành thị trường thuộc địa  giữa  các đế quốc với nhau.\n<b>* Nguyên nhân  trực tiếp:</b>\n  + Sự hình thành hai khối quân sự đối lập, kình địch nhau.\n  + Duyên cớ: 28/6/1914 Hoàng thân thừa kế ngôi vua Áo-Hung bị ám sát tại Bô-xni-a (Xéc bi)\nĐến năm 1914, sự chuẩn bị chiến tranh của 2 phe đế quốc cơ bản đã xong. Ngày 28.6.1914, Áo - Hung tổ chức tập trận ở Bô-xni-a. Thái tử Áo là Phơ-ran-xo Phéc-đi-nan đến thủ đô Bô-xni-a là Xa-ra-e-vô để tham quan cuộc tập trận thì bị một phần tử người Xéc-bi ám sát. Nhân cơ hội đó Đức hùng hổ bắt Áo phải tuyên chiến với Xéc-bi. Thế là chiến tranh đã được châm ngòi.', NULL, NULL, 1),
(9, 4, 3, 'https://i.postimg.cc/RCPp07Rz/CTTG1-3.jpg', 400, NULL, 2),
(16, 5, 1, 'Chiến tranh bùng nổ\r\n     + 28/6/1914, Hoàng thân thừa kế ngôi vua Áo-Hung bị ám sát\r\n     + 28/7/1914, Áo-Hung tuyên chiến với Xéc-bi.\r\n    +1/8/1914, Đức tuyên chiến với Nga.       \r\n    + 3/8/1914, Đức tuyên chiến với Pháp\r\n    + 4/8/1914, Anh tuyên chiến với Đức.\r\nChiến tranh thế giới bùng nổ diễn ra trên 2 mặt trận Đông Âu và Tây Âu', NULL, NULL, 1),
(17, 5, 3, 'https://i.postimg.cc/BZH2vyKF/CTTG1-4.png', 300, '', 2),
(18, 5, 3, 'https://i.postimg.cc/7ZGKm9Rn/CTTG1-5.png', 900, NULL, 3),
(19, 5, 1, 'Những năm đầu Đức, Áo - Hung giữ thế chủ động tấn công. Từ cuối 1916 trở đi. Đức, Áo - Hung chuyển sang thế phòng ngự ở cả hai mặt trận Đông Âu, Tây Âu.', NULL, NULL, 4),
(20, 6, 3, 'https://i.postimg.cc/pd07SrZD/CTTG1-6.png', 900, NULL, 1),
(21, 6, 3, 'https://i.postimg.cc/fTxCJGZ9/CTTG1-7.jpg', 300, 'Mỹ tham gia cùng phe hiệp ước', 2),
(22, 6, 3, 'https://i.postimg.cc/0j5k7gFy/CTTG1-8.jpg', 300, 'Cách mạng tháng 10 Nga thành công, Nga rút khỏi cuộc chiến', 3),
(23, 7, 1, '<b>* Hậu quả của chiến tranh:</b>\r\n- Chiến tranh thế giới thứ nhất kết thúc với sự thất bại của phe Liên Minh, gây nên thiệt hại nặng nề về người và của.\r\n    + 10 triệu người chết.\r\n    + 20 triệu người bị thương.\r\n    + Chiến  phí 85 tỉ đô la.\r\n- Các nước Châu Âu là con nợ của Mỹ.\r\n- Bản đồ thế giới  thay đổi .\r\n- Cách mạng tháng Mười Nga thành công đánh dấu bước chuyển lớn trong cục diện thế giới.\r\n<b>* Tính chất:</b>\r\nChiến tranh thế giới thứ nhất là cuộc chiến tranh đế quốc phi nghĩa.', NULL, NULL, 1),
(24, 7, 3, 'https://i.postimg.cc/1XwNWVK3/CTTG1-10.jpg', 500, NULL, 2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `exams`
--

DROP TABLE IF EXISTS `exams`;
CREATE TABLE `exams` (
  `id` int(11) NOT NULL,
  `id_class` int(11) NOT NULL,
  `id_subject` int(11) NOT NULL,
  `name` text NOT NULL,
  `time` time NOT NULL,
  `id_course` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `exams`
--

INSERT INTO `exams` (`id`, `id_class`, `id_subject`, `name`, `time`, `id_course`) VALUES
(1, 3, 7, 'Kiểm tra lý thuyết chiến tranh Thế giới thứ nhất', '01:00:00', 1),
(2, 1, 2, 'Test đề thi vật lý 6', '01:00:00', NULL),
(3, 2, 3, 'Test dề thi hóa học lớp 7', '01:00:00', NULL),
(4, 1, 1, 'Test đề thi toán 6', '01:00:00', NULL),
(5, 3, 5, 'Test dề thi tiếng anh lớp 8', '01:00:00', NULL),
(6, 3, 3, 'Test dề thi hóa học lớp 8', '01:00:00', NULL),
(7, 2, 8, 'Test dề thi giáo dục công dân lớp 7', '01:00:00', NULL),
(8, 4, 6, 'Test dề thi sinh học lớp 9', '01:00:00', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `exams_answer`
--

DROP TABLE IF EXISTS `exams_answer`;
CREATE TABLE `exams_answer` (
  `id` int(11) NOT NULL,
  `id_ques` int(11) NOT NULL,
  `ans_text` text NOT NULL,
  `isCorrect` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `exams_answer`
--

INSERT INTO `exams_answer` (`id`, `id_ques`, `ans_text`, `isCorrect`) VALUES
(1, 1, 'Hình thành nhóm “đế quốc trẻ”- “đế quốc già”', 1),
(2, 1, 'Hình thành phe Liên minh- Hiệp ước', 0),
(3, 1, 'Hình thành phe tư bản dân chủ- phát xít', 0),
(4, 1, 'Hình thành phe Đồng minh – phe Trục', 0),
(5, 2, 'Mĩ', 0),
(6, 2, 'Anh', 0),
(7, 2, 'Đức', 1),
(8, 2, 'Nhật', 0),
(9, 3, 'phe Hiệp ước', 0),
(10, 3, 'phe Đồng minh', 0),
(11, 3, 'phe Liên minh', 0),
(12, 3, 'phe Trục', 0),
(13, 4, 'Đức-Ý-Nhật.', 0),
(14, 4, 'Đức-Áo-Hung.', 1),
(15, 4, 'Đức-Nhật-Áo.', 0),
(16, 4, 'Đức-Nhật-Mĩ', 0),
(17, 5, 'Anh, Pháp, Đức', 0),
(18, 5, 'Anh, Pháp, Nga', 1),
(19, 5, 'Mĩ, Đức, Nga', 0),
(20, 5, 'Anh, Pháp, Mĩ', 0),
(21, 6, 'phe Hiệp ước', 1),
(22, 6, 'phe Đồng minh', 0),
(23, 6, 'phe Liên minh', 0),
(24, 6, 'phe Trục', 0),
(25, 7, 'Đức tấn công Ba Lan', 0),
(26, 6, 'Áo- Hung tuyên chiến với Xéc-bi', 0),
(27, 7, 'Anh tuyên chiến với Đức', 0),
(28, 7, 'Thái tử Áo - Hung bị ám sát', 1),
(29, 8, 'Sự hung hãn của Đức', 0),
(30, 8, 'Thái tử Áo - Hung bị ám sát', 1),
(31, 8, 'Mâu thuẫn Anh - Pháp', 0),
(32, 8, 'Mâu thuẫn về vấn đề thuộc địa', 0),
(33, 9, 'Sự phát triển không đều về kinh tế, chính trị của chủ nghĩa tư bản', 1),
(34, 9, 'Việc sở hữu các loại vũ khí có tính sát thương cao', 0),
(35, 9, 'Hệ thống thuộc địa không đồng đều', 0),
(36, 9, 'Tiềm lực quân sự của các nước tư bản phương Tây', 0),
(37, 10, 'Sự hình thành liên minh chính trị đối đầu nhau', 0),
(38, 10, 'Sự hình thành các liên minh kinh tế đối đầu nhau', 0),
(39, 10, 'Sự hình thành các khối quân sự đối đầu nhau', 1),
(40, 10, 'Sự tập trung lực lượng quân sự ở biên giới giữa các nước', 0),
(41, 11, 'Sự hình thành phe Liên minh', 0),
(42, 11, 'Thái độ hung hăng của Đức', 1),
(43, 11, 'Sự hình thành phe Liên minh và Hiệp ước', 0),
(44, 11, 'Thái độ trung lập của Mĩ', 0),
(45, 12, 'Tiến hành các cuộc chiến tranh nhằm giành giật thuộc địa, chia lại thị trường', 1),
(46, 12, 'Chủ động đàm phán với các nước đế quốc', 0),
(47, 12, ' Liên minh với các nước đế quốc', 0),
(48, 12, 'Gây chiến với các nước đế quốc láng giềng', 0),
(49, 13, 'Để lôi kéo đồng minh.', 0),
(50, 13, 'Để tăng cường chạy đua vũ trang.', 0),
(51, 13, 'Giải quyết cuộc khủng hoảng kinh tế đang bao trùm thế giới tư bản.', 1),
(52, 13, 'Ôm mộng xâm lược, cướp đoạt lãnh thổ và thuộc địa của nhau.', 0),
(53, 14, 'Mâu thuẫn về vấn đề nhân công và văn hóa', 0),
(54, 14, 'Sự phát triển không đồng đều của chủ nghĩa tư bản', 1),
(55, 14, ' Thái độ hung hăng của Đức và sự dung dưỡng của Anh, Pháp', 0),
(56, 14, 'Thái tử Xéc-bi bị ám sát', 0),
(57, 15, 'Nước Đức có tiềm lực kinh tế, quân sự hùng mạnh nhưng lại có ít thuộc địa', 1),
(58, 15, 'Nước Đức có lực lượng quân dội hùng mạnh, được huấn luyện đầy đủ', 0),
(59, 15, 'Nước Đức có nền kinh tế phát triển mạnh nhất Châu Âu', 0),
(60, 15, 'Giới quân phiệt Đức tự tin có thể chiến thắng các đế quốc khác', 0),
(61, 16, 'Củng cố hệ thống quan lại, tay sai ở Đông Dương', 0),
(62, 16, 'Thiết lập một nền cai trị cứng rắn', 0),
(63, 16, 'Mở rộng thương thuyết với chính phủ Trung Hoa', 0),
(64, 16, 'Trao lại quyền thống trị cho chính phủ Nam triều', 1),
(65, 17, 'Vấn đề sở hữu vũ khí và phương tiện chiến tranh mới', 0),
(66, 18, 'Vấn đề thuộc địa', 1),
(67, 17, 'Chiến lược phát triển kinh tế', 0),
(68, 17, 'Mâu thuẫn trong chính sách đối ngoại', 0),
(69, 18, 'Nhật.', 0),
(70, 18, ' Anh.', 0),
(71, 18, 'Đức.', 1),
(72, 18, 'Áo – Hung', 0),
(73, 19, 'Đánh nhanh thắng nhanh/ đánh chớp nhoáng', 1),
(74, 19, 'Đánh cầm cự, vừa đánh vừa đàm phán', 0),
(75, 19, 'Tiến công thẳng vào các đối thủ thuộc phe Hiệp ước', 0),
(76, 19, 'Đánh lâu dài để gìn giữ lực lượng', 0),
(77, 20, 'Ngày 1-8-1914, Đức tuyên chiến với Nga.', 0),
(78, 20, 'Ngày 28-7-1914, Áo - Hung tấn công Xéc-bi.', 1),
(79, 20, 'Ngày 4-8 -1914, Anh tuyên chiến với Đức.', 0),
(80, 20, 'Ngày 28-6-1914, Thái tử Áo-Hung bị ám sát.', 0),
(81, 21, 'Liên minh', 0),
(82, 21, 'Hiệp ước', 1),
(83, 21, 'Đồng minh', 0),
(84, 21, 'Phe Trục', 0),
(85, 22, 'Đức loại bỏ được Nga ra khỏi chiến tranh.', 0),
(86, 22, 'Nga loại bỏ quân Áo - Hung ra khỏi chiến tranh.', 0),
(87, 22, 'Cầm cự trong một mặt trận dài 1200 km.', 1),
(88, 22, 'Nga hoàng khủng hoảng nghiêm trọng.', 0),
(89, 23, 'Sử dụng máy bay trinh sát và ném bom', 0),
(90, 23, 'Ném bom và thả hơi độc', 0),
(91, 23, 'Mai phục và tiêu diệt', 0),
(92, 23, 'Sử dụng tàu ngầm', 1),
(93, 24, 'Đức tấn công Bỉ, chặn con đường ra biển, không cho Anh sang tiếp viện', 0),
(94, 24, 'Pháp phản công giành thắng lợi trên sông Mácnơ, Anh đổ bộ lên lục địa châu Âu', 1),
(95, 24, 'Thất bại của Đức trong trận Véc-đoong', 0),
(96, 24, 'Nga tấn công vào Đông Phổ, buộc Đức phải điều quân từ mặt trận phía Tây về chống lại', 0),
(97, 25, 'Chiến dịch tấn công Véc-đoong của Đức thất bại (12 - 1916)', 1),
(98, 25, 'Pháp phản công và giành thắng lợi trên sông Mác-nơ (9 - 1914)', 0),
(99, 25, 'Sau cuộc tấn công Nga quyết liệt của quân Đức - Áo - Hung (1915)', 0),
(100, 25, 'Cả hai bên đưa vào cuộc chiến những phương tiện chiến tranh mới như xe tăng, máy bay trinh sát, ném bom (1915)…', 0),
(101, 26, 'Hai bên bắt tay cùng nhau chống đế quốc', 0),
(102, 26, 'Nước Nga rút ra khỏi chiến tranh đế quốc', 1),
(103, 26, 'Phá vỡ tuyến phòng thủ của Đức ở biên giới hai nước', 0),
(104, 26, 'Hai nước hòa giải để tập trung vào công cuộc kiến thiết đất nước', 0),
(105, 27, 'Quân Đức tấn công dồn dập vào lục địa Nga.', 0),
(106, 27, 'Cách mạng xã hội chủ nghĩa tháng Mười thắng lợi.', 1),
(107, 27, 'Hòa ước Brét Litốp được kí kết giữa Nga và Đức.', 0),
(108, 27, 'Nước Nga quyết định rút khỏi chiến tranh đế quốc.', 0),
(109, 28, 'Tư bản chủ nghĩa', 0),
(110, 28, 'Xã hội chủ nghĩa', 0),
(111, 28, 'Hiệp ước', 1),
(112, 28, 'Liên minh', 0),
(113, 29, 'Mĩ tuyên chiến với Đức.', 0),
(114, 29, 'Cách mạng dân chủ tư sản Đức.', 0),
(115, 29, 'Chiến dịch Véc-đoong.', 0),
(116, 29, 'Đức kí văn kiện đầu hàng, chiến tranh kết thúc.', 1),
(117, 30, 'Phe Liên minh được thành lập sớm, có sự chuẩn bị kĩ càng', 0),
(118, 30, 'Phe Liên minh là phe phát động của cuộc chiến tranh', 0),
(119, 30, 'Ưu thế về kinh tế- quân sự của Đức trong phe Liên minh so với Anh, Pháp', 0),
(120, 30, 'Nội bộ phe Hiệp ước không có sự thống nhất', 1),
(121, 31, 'Cách mạng tháng Hai và cách mạng tháng Mười năm 1917 ở Nga', 0),
(122, 31, 'Đức dồn lực lượng, quay lại đánh Nga và loại Italia ra khỏi vòng chiến', 0),
(123, 31, 'Tàu ngầm Đức vi phạm quyền tự do trên biển, tấn công phe Hiệp ước', 0),
(124, 31, 'Mĩ tuyên chiến với Đức, chính thức tham chiến và đứng về phe Hiệp ước', 1),
(125, 32, 'Cách mạng tháng Hai và cách mạng tháng Mười năm 1917 ở Nga', 0),
(126, 32, 'Đức dồn lực lượng, quay lại đánh Nga và loại Italia ra khỏi vòng chiến', 0),
(127, 32, 'Tàu ngầm Đức vi phạm quyền tự do trên biển, tấn công phe Hiệp ước', 0),
(128, 32, 'Mĩ tuyên chiến với Đức, chính thức tham chiến và đứng về phe Hiệp ước', 1),
(129, 33, 'Muốn lợi dụng chiến tranh để bán vũ khí cho cả hai phe', 1),
(130, 33, 'Chưa đủ tiềm lực để tham chiến', 0),
(131, 33, 'Không muốn “hi sinh” một cách vô ích', 0),
(132, 33, 'Sợ quân Đức tấn công', 0),
(133, 34, 'Chạy đua vũ trang để tham gia chiến tranh.', 0),
(134, 34, 'Ủng hộ Đức phát động chiến tranh.', 0),
(135, 34, 'Xúi dục Anh, Pháp gây chiến tranh.', 0),
(136, 34, 'Giữ thái độ “trung lập”.', 1),
(137, 35, 'Anh', 0),
(138, 35, 'Pháp', 0),
(139, 35, 'Mĩ', 1),
(140, 35, 'Nhật Bản', 0),
(141, 36, 'Bị thiệt hại nặng nề về sức người sức của', 0),
(142, 36, 'Gây ra những mâu thuẫn trong phe Hiệp ước', 0),
(143, 36, 'Sự thành công của Cách mạng tháng Mười Nga và việc thành lập nhà nước Xô viết', 1),
(144, 36, 'Gây đau thương chết chóc cho nhân loại', 0),
(145, 37, '10 triệu người chết.', 0),
(146, 37, 'Sự thất bại của phe liên minh', 0),
(147, 37, ' Thành công của cách mạng tháng 10 Nga', 1),
(148, 37, ' Phong trào yêu nước phát triển', 0),
(149, 38, 'Thất bại thuộc về phe liên minh.', 0),
(150, 38, 'Chiến thắng Véc-đoong', 0),
(151, 38, 'Mĩ tham chiến.', 0),
(152, 38, 'Cách mạng tháng Mười Nga', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `exams_question`
--

DROP TABLE IF EXISTS `exams_question`;
CREATE TABLE `exams_question` (
  `id` int(11) NOT NULL,
  `id_exam` int(11) NOT NULL,
  `ques_text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `exams_question`
--

INSERT INTO `exams_question` (`id`, `id_exam`, `ques_text`) VALUES
(1, 1, 'Sự phát triển không đồng đều về kinh tế và chính trị của chủ nghĩa tư bản đã dẫn đến sự phân hóa như thế nào giữa các nước đế quốc cuối thế kỉ XIX – đầu thế kỉ XX?'),
(2, 1, 'Trong cuộc đua giành giật thuộc địa, nước đế quốc nào hung hãn nhất?'),
(3, 1, 'Đức, Áo- Hung và Italia là những nước nằm trong phe nào?'),
(4, 1, 'Phe Liên Minh gồm những nước nào?'),
(5, 1, 'Phe hiệp ước bao gồm những nước nào?'),
(6, 1, 'Các nước Anh, Pháp, Nga là những nước nằm trong phe nào?'),
(7, 1, 'Sự kiện nào được coi là duyên cớ trực tiếp dẫn tới cuộc Chiến tranh thế giới thứ nhất (1914 – 1918)?'),
(8, 1, 'Nguyên nhân trực tiếp dẫn tới chiến tranh thế giới thứ nhất?'),
(9, 1, 'Yếu tố nào đã làm thay đổi sâu sắc so sánh lực lượng giữa các nước đế quốc vào cuối thế kỉ XIX – đầu thế kỉ XX?'),
(10, 1, 'Dấu hiệu nào chứng tỏ vào cuối thế kỉ XIX - đầu thế kỉ XX quan hệ quốc tế giữa các đế quốc ở Châu Âu ngày càng căng thẳng?'),
(11, 1, 'Đâu là nhân tố khiến cho quan hệ quốc tế châu Âu cuối thế kỉ XIX – đầu thế kỉ XX ngày càng căng thẳng?'),
(12, 1, 'Chủ trương của giới cầm quyền Đức trong việc giải quyết mâu thuẫn giữa các nước đế quốc cuối thế kỉ XIX - đầu thế kỉ XX là:'),
(13, 1, 'Ý nào không phản ánh đúng mục đích thành lập của hai khối quân sự đối đầu (Liên minh và Hiệp ước) đầu thế kỉ XX?'),
(14, 1, 'Nguyên nhân sâu xa dẫn tới sự bùng nổ cuộc chiến tranh thế giới thứ nhất (1914-1918) là'),
(15, 1, 'Vì sao nói Đức là kẻ hung hãn nhất trong cuộc đua giành giật thuộc địa cuối thế kỉ XIX – đầu thế kỉ XX?'),
(16, 1, 'Đâu không phải sự biến đổi trong chính sách cai trị của thực dân Pháp ở Đông Dương khi nước Pháp tham gia cuộc chiến tranh thế giới thứ nhất (1914-1918)?'),
(17, 1, 'Mâu thuẫn gay gắt giữa các nước đế quốc “già” và các nước đế quốc “trẻ” cuối thế kỉ XIX - đầu thế kỉ XX chủ yếu vì'),
(18, 1, 'Nước nào được mệnh danh là “con hổ đói đến bàn tiệc muộn” trong cuộc giành giật thuộc địa cuối thế kỉ XIX, đầu thế kỉ XX?'),
(19, 1, 'Trong giai đoạn đầu của Chiến tranh thế giới thứ nhất (1914-1916), Đức đã sử dụng chiến lược nào?'),
(20, 1, 'Chiến tranh thế giới thứ nhất bắt đầu với sự kiện nào?'),
(21, 1, 'Trong giai đoạn thứ hai của Chiến tranh thế giới thứ nhất (1917 - 1918), ưu thế trên chiến trường thuộc về phe nào?'),
(22, 1, 'Ở mặt trận phía Đông vào năm 1915, quân Đức cùng quân Áo - Hung và quân Nga đang ở trong thế'),
(23, 1, 'Đức đã làm gì để cắt đứt đường tiếp tế trên biển của phe Hiệp ước trong giai đoạn thứ hai của Chiến tranh thế giới thứ nhất?'),
(24, 1, 'Sự kiện nào đánh dấu kế hoạch “đánh nhanh thắng nhanh” của Đức trong cuộc Chiến tranh thế giới thứ nhất bị phá sản?'),
(25, 1, 'Sự kiện nào đánh dấu kết thúc giai đoạn một của Chiến tranh thế giới thứ nhất?'),
(26, 1, 'Nội dung chủ yếu của Hòa ước Brét Litốp được kí kết giữa Nga và Đức là'),
(27, 1, 'Tháng 11-1917 đã diễn ra sự kiện gì ở Nga?'),
(28, 1, 'Kết thúc chiến tranh thế giới thứ nhất, thắng lợi đã thuộc về phe nào?'),
(29, 1, 'Ngày 11-11-1918 gắn với sự kiện gì trong Chiến tranh thế giới thứ nhất?'),
(30, 1, 'Đâu không phải là lý do trong giai đoạn đầu của cuộc chiến tranh thế giới thứ nhất (1914-1916) phe Liên minh nắm được thế chủ động trên chiến trường?'),
(31, 1, 'Nội dung nào chi phối giai đoạn 2 của cuộc Chiến tranh thế giới thứ nhất?'),
(32, 1, 'Nội dung nào chi phối giai đoạn 2 của cuộc Chiến tranh thế giới thứ nhất?'),
(33, 1, 'Vì sao Mĩ lại giữ thái độ “trung lập” trong giai đoạn đầu của cuộc Chiến tranh thế giới thứ nhất?'),
(34, 1, 'Mĩ có thái độ như thế nào trước và trong những năm đầu cuộc Chiến tranh thế giới thứ nhất?'),
(35, 1, 'Quốc gia nào được hưởng lợi nhiều nhất từ cuộc chiến tranh thế giới thứ nhất (1914-1918)?'),
(36, 1, 'Hệ quả ngoài mong muốn của các nước đế quốc khi tham gia Chiến tranh thế giới thứ nhất là'),
(37, 1, 'Kết quả nào trong Chiến tranh thế giới thứ nhất nằm ngoài dự tính của các nước đế quốc?'),
(38, 1, 'Trong quá trình chiến tranh thế giới thứ nhất, sự kiện nào đánh dấu bước chuyển biến lớn trong cục diện chính trị thế giới?');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `heading_type`
--

DROP TABLE IF EXISTS `heading_type`;
CREATE TABLE `heading_type` (
  `id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `heading_type`
--

INSERT INTO `heading_type` (`id`, `type`) VALUES
(1, 'content'),
(2, 'video'),
(3, 'image');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `question`
--

DROP TABLE IF EXISTS `question`;
CREATE TABLE `question` (
  `id` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `id_mon` int(11) NOT NULL,
  `content` text NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `date_ques` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `question`
--

INSERT INTO `question` (`id`, `id_user`, `id_mon`, `content`, `image`, `date_ques`) VALUES
(1, 112, 1, 'Test câu hỏi môn toán', NULL, '2024-02-25 00:00:00'),
(2, 112, 2, 'Test câu hỏi môn vật lý', NULL, '2024-02-25 00:00:00'),
(3, 120, 1, 'cho hình bình hành ABCD, M là trung điểm của AB, Gọi G là giao điểm của AC,DM. Lấy điểm E ∈ AM. Các đường thẳng GE,CD cắt nhau tại F\na, cm G là trọng tâm của ΔABD\nb, cm GC=2GA\nc, kẻ đường thẳng qua G cắt các cạnh AD,BC lần lượt tại I,K. Cm EI//KF', NULL, '2024-02-28 08:03:43'),
(146, 125, 2, 'Test câu hỏi có hình ảnh', 'imageQues_1713723879865.png', '2024-04-22 01:24:39'),
(147, 125, 1, 'test cau hoi toan hoc', 'imageQues_1713724426260.png', '2024-04-22 01:33:46'),
(148, 112, 2, 'test', NULL, '2024-04-22 12:09:31');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tblkhoi`
--

DROP TABLE IF EXISTS `tblkhoi`;
CREATE TABLE `tblkhoi` (
  `id` int(11) NOT NULL,
  `tenkhoi` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tblkhoi`
--

INSERT INTO `tblkhoi` (`id`, `tenkhoi`) VALUES
(1, 'Khối Tự Nhiên'),
(2, 'Khối Xã Hội'),
(3, 'Khối khác');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tbllop`
--

DROP TABLE IF EXISTS `tbllop`;
CREATE TABLE `tbllop` (
  `id` int(11) NOT NULL,
  `tenlop` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tbllop`
--

INSERT INTO `tbllop` (`id`, `tenlop`) VALUES
(1, '6'),
(2, '7'),
(3, '8'),
(4, '9');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tblmon`
--

DROP TABLE IF EXISTS `tblmon`;
CREATE TABLE `tblmon` (
  `id` int(11) NOT NULL,
  `tenmon` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tblmon`
--

INSERT INTO `tblmon` (`id`, `tenmon`) VALUES
(1, 'Toán'),
(2, 'Vật Lý'),
(3, 'Hóa Học'),
(4, 'Ngữ Văn'),
(5, 'Anh Văn'),
(6, 'Sinh Học'),
(7, 'Lịch Sử'),
(8, 'GDCD');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tbluser`
--

DROP TABLE IF EXISTS `tbluser`;
CREATE TABLE `tbluser` (
  `id` int(11) NOT NULL,
  `fullname` text NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `email` varchar(200) NOT NULL,
  `avatar` varchar(255) DEFAULT 'avatar.jpg',
  `school` text DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `class` int(2) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `sex` int(1) DEFAULT NULL,
  `typeLogin` varchar(255) DEFAULT NULL,
  `id_google` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tbluser`
--

INSERT INTO `tbluser` (`id`, `fullname`, `username`, `password`, `email`, `avatar`, `school`, `birthday`, `class`, `phone`, `sex`, `typeLogin`, `id_google`) VALUES
(112, 'Vũ Tấn Minh', 'member1', '$2b$10$cL3gNQaUL8JgOREGMuo8cueyg1NYgEiK50gggCbOWRD6em/GiZ/Ju', 'daiboss147@gmail.com', 'avatar_1713724987657.jpg', 'Trường THCS Nam Hải', '2001-08-01', 8, '0965112622', 1, NULL, NULL),
(120, 'Vũ Quốc Cường', 'member2', '$2b$10$3.9mNhQVEQrACEyJxWeRx.klX2W6Kif5v6rZ8ftFZSrqtL8c/10ne', 'daiboss147@gmail.com', 'avatar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(123, 'test', 'member3', '$2b$10$W8bsSZ1ofk10TXDmqJfc..MwcWFv959/5vG1RDXFeFXZuKnjXIGp6', 'minh137664@gmail.com', 'avatar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(125, 'Nguyễn Tiến Dũng', 'member4', '$2b$10$pkUgw5Yh929NJN8ioUb/PeMZtXLoy6z8khez2yHn2J72TYx3YNHNu', 'nguyentiendung@gmail.com', 'avatar_1713695332227.png', 'Trường THCS Vũ Thư', '2001-10-12', 9, '0912522012', 1, NULL, NULL),
(126, 'Vũ Minh Phương', 'member6', '$2b$10$tLeBhPRf4dUFEtE5l1IwW.WQq/VhWNzn/NIgtyZXe/HDCBK1xXN56', 'member6@gmail.com', 'avatar.jpg', 'null', '2009-10-08', 9, 'null', 0, NULL, NULL),
(128, 'Vũ Hà My', 'member8', '$2b$10$dAIu2/pbkxv6itLcIyzMCOtwtA1E6bcJMbXc5ESqzWyZZ73gaaRQO', 'daiboss147@gmail.com', 'avatar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(129, 'Minh Vũ', NULL, NULL, 'daiboss147@gmail.com', 'avatar.jpg', NULL, NULL, NULL, NULL, NULL, 'google', '107950341174796818651'),
(130, 'Minh Vu', NULL, NULL, 'quakhu1472001@gmail.com', 'avatar.jpg', NULL, NULL, NULL, NULL, NULL, 'google', '101855269130313775851'),
(131, 'Minh Vũ', NULL, NULL, 'minhvt1472001@gmail.com', 'avatar.jpg', NULL, NULL, NULL, NULL, NULL, 'google', '114221795254716955108');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `title_module`
--

DROP TABLE IF EXISTS `title_module`;
CREATE TABLE `title_module` (
  `id` int(11) NOT NULL,
  `id_CM` int(11) NOT NULL,
  `title_TM` text NOT NULL,
  `position_TM` int(2) NOT NULL,
  `id_Course` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `title_module`
--

INSERT INTO `title_module` (`id`, `id_CM`, `title_TM`, `position_TM`, `id_Course`) VALUES
(1, 1, 'Video tóm tắt tham khảo (EZ sử)', 1, 1),
(2, 1, 'Tóm tắt chiến tranh thế giới thứ nhất', 2, 1),
(3, 2, 'Quan hệ quốc tế cuối thế kỷ XIX, đầu thế kỷ XX', 1, 1),
(4, 2, 'Nguyên nhân của cuộc chiến tranh', 2, 1),
(5, 3, 'Giai đoạn thứ nhất( 1914-1916)', 1, 1),
(6, 3, 'Giai đoạn thứ 2 (1917 - 1918)', 2, 1),
(7, 4, 'Hậu quả và tính chất của chiến tranh', 1, 1),
(8, 5, 'test ui', 1, 2),
(9, 6, 'tesst ui 2', 1, 2),
(10, 7, 'test 3', 1, 2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users_answers`
--

DROP TABLE IF EXISTS `users_answers`;
CREATE TABLE `users_answers` (
  `id` int(11) NOT NULL,
  `id_userExam` int(11) NOT NULL,
  `id_ques` int(11) NOT NULL,
  `id_answer` int(11) NOT NULL,
  `selected` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users_answers`
--

INSERT INTO `users_answers` (`id`, `id_userExam`, `id_ques`, `id_answer`, `selected`) VALUES
(1, 1, 5, 17, 1),
(2, 1, 6, 24, 1),
(3, 1, 7, 27, 1),
(4, 1, 11, 42, 1),
(5, 1, 16, 63, 1),
(6, 1, 17, 65, 1),
(7, 1, 19, 73, 1),
(8, 1, 22, 85, 1),
(9, 1, 24, 94, 1),
(10, 1, 27, 105, 1),
(11, 1, 31, 121, 1),
(12, 1, 36, 142, 1),
(211, 2, 1, 3, 1),
(212, 2, 2, 5, 1),
(213, 2, 3, 9, 1),
(214, 2, 4, 16, 1),
(215, 2, 5, 18, 1),
(216, 2, 6, 22, 1),
(217, 2, 8, 29, 1),
(218, 2, 10, 39, 1),
(219, 2, 11, 44, 1),
(220, 2, 12, 45, 1),
(221, 2, 13, 52, 1),
(222, 2, 14, 56, 1),
(223, 2, 15, 58, 1),
(224, 2, 16, 61, 1),
(225, 2, 17, 67, 1),
(226, 2, 19, 74, 1),
(227, 2, 20, 79, 1),
(228, 2, 23, 90, 1),
(229, 2, 24, 93, 1),
(230, 2, 25, 99, 1),
(231, 2, 26, 103, 1),
(232, 2, 27, 106, 1),
(233, 2, 28, 111, 1),
(234, 2, 29, 113, 1),
(235, 2, 30, 120, 1),
(236, 2, 31, 123, 1),
(237, 2, 32, 128, 1),
(238, 2, 33, 132, 1),
(239, 2, 34, 136, 1),
(240, 2, 35, 140, 1),
(241, 2, 36, 141, 1),
(242, 2, 37, 148, 1),
(243, 2, 38, 151, 1),
(244, 4, 11, 43, 1),
(245, 4, 21, 82, 1),
(246, 4, 22, 86, 1),
(247, 4, 31, 124, 1),
(248, 4, 32, 128, 1),
(249, 4, 33, 132, 1),
(250, 4, 38, 149, 1),
(251, 3, 2, 8, 1),
(252, 3, 4, 14, 1),
(253, 3, 9, 34, 1),
(254, 3, 12, 47, 1),
(255, 3, 14, 53, 1),
(256, 3, 15, 57, 1),
(257, 3, 16, 61, 1),
(258, 3, 18, 66, 1),
(259, 3, 24, 95, 1),
(260, 3, 25, 98, 1),
(261, 3, 26, 104, 1),
(262, 3, 28, 112, 1),
(263, 3, 29, 116, 1),
(264, 3, 30, 120, 1),
(265, 3, 31, 122, 1),
(266, 3, 34, 134, 1),
(267, 3, 35, 138, 1),
(268, 3, 38, 151, 1),
(269, 5, 2, 5, 1),
(270, 5, 4, 15, 1),
(271, 5, 8, 32, 1),
(272, 5, 9, 34, 1),
(273, 5, 19, 76, 1),
(274, 5, 21, 82, 1),
(275, 5, 29, 115, 1),
(276, 5, 31, 123, 1),
(277, 5, 33, 132, 1),
(278, 16, 1, 2, 1),
(279, 16, 3, 12, 1),
(280, 16, 4, 13, 1),
(281, 16, 11, 44, 1),
(282, 16, 16, 63, 1),
(283, 16, 21, 83, 1),
(284, 16, 26, 101, 1),
(285, 16, 35, 138, 1),
(286, 24, 2, 7, 1),
(287, 24, 5, 20, 1),
(288, 24, 6, 26, 1),
(289, 24, 10, 37, 1),
(290, 24, 16, 61, 1),
(291, 24, 17, 65, 1),
(292, 24, 19, 76, 1),
(293, 24, 24, 95, 1),
(294, 24, 30, 120, 1),
(295, 24, 34, 133, 1),
(296, 24, 35, 138, 1),
(297, 25, 4, 15, 1),
(298, 25, 8, 31, 1),
(299, 25, 18, 72, 1),
(300, 25, 26, 101, 1),
(301, 27, 1, 3, 1),
(302, 27, 2, 5, 1),
(303, 27, 3, 12, 1),
(304, 27, 4, 14, 1),
(305, 27, 5, 17, 1),
(306, 27, 6, 23, 1),
(307, 27, 7, 27, 1),
(308, 27, 8, 31, 1),
(309, 27, 9, 33, 1),
(310, 27, 10, 39, 1),
(311, 27, 11, 42, 1),
(312, 27, 12, 45, 1),
(313, 27, 13, 50, 1),
(314, 27, 14, 55, 1),
(315, 27, 15, 57, 1),
(316, 27, 16, 61, 1),
(317, 27, 17, 65, 1),
(318, 27, 18, 71, 1),
(319, 27, 19, 73, 1),
(320, 27, 20, 77, 1),
(321, 27, 21, 84, 1),
(322, 27, 22, 88, 1),
(323, 27, 23, 90, 1),
(324, 27, 24, 94, 1),
(325, 27, 25, 100, 1),
(326, 27, 26, 103, 1),
(327, 27, 27, 106, 1),
(328, 27, 28, 109, 1),
(329, 27, 29, 116, 1),
(330, 27, 30, 120, 1),
(331, 27, 31, 121, 1),
(332, 27, 32, 128, 1),
(333, 27, 33, 130, 1),
(334, 27, 34, 134, 1),
(335, 27, 35, 140, 1),
(336, 27, 36, 141, 1),
(337, 27, 37, 147, 1),
(338, 27, 38, 149, 1),
(339, 28, 12, 45, 1),
(340, 28, 13, 50, 1),
(341, 28, 19, 76, 1),
(342, 28, 28, 111, 1),
(343, 28, 29, 116, 1),
(344, 28, 34, 134, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users_exam`
--

DROP TABLE IF EXISTS `users_exam`;
CREATE TABLE `users_exam` (
  `id` int(11) NOT NULL,
  `id_exam` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `score` float DEFAULT 0,
  `status` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users_exam`
--

INSERT INTO `users_exam` (`id`, `id_exam`, `id_user`, `start_time`, `end_time`, `score`, `status`) VALUES
(1, 1, 112, '2024-05-22 16:04:55', '2024-05-27 01:34:27', 0.79, 2),
(2, 1, 112, '2024-05-23 07:54:57', '2024-05-23 08:31:14', 2.11, 2),
(3, 1, 126, '2024-05-23 09:17:43', '2024-05-23 09:19:07', 1.32, 2),
(4, 1, 112, '2024-05-23 09:15:47', '2024-05-23 09:16:53', 0.79, 2),
(5, 1, 126, '2024-05-23 09:21:33', '2024-05-23 09:22:54', 0.26, 2),
(6, 2, 112, NULL, NULL, 0, 0),
(7, 2, 120, NULL, NULL, 0, 0),
(8, 1, 120, NULL, NULL, 0, 0),
(9, 1, 120, NULL, NULL, 0, 0),
(10, 2, 112, NULL, NULL, 0, 0),
(11, 7, 126, NULL, NULL, 0, 0),
(12, 7, 125, NULL, NULL, 0, 0),
(13, 3, 112, NULL, NULL, 0, 0),
(14, 2, 125, NULL, NULL, 0, 0),
(15, 4, 112, NULL, NULL, 0, 0),
(16, 1, 112, '2024-05-27 01:17:59', '2024-05-27 01:18:41', 0, 2),
(17, 1, 112, '2024-05-27 01:25:06', '2024-05-27 01:25:07', 0, 2),
(18, 1, 112, '2024-05-27 01:27:21', '2024-05-27 01:27:21', 0, 2),
(19, 1, 112, '2024-05-27 01:29:36', '2024-05-27 01:29:36', 0, 2),
(20, 1, 112, '2024-05-27 01:32:10', '2024-05-27 01:32:11', 0, 2),
(21, 1, 112, '2024-05-27 01:36:28', '2024-05-27 01:36:28', 0, 2),
(22, 1, 112, '2024-05-27 01:37:23', '2024-05-27 01:37:48', 0, 2),
(23, 1, 112, '2024-05-27 01:38:45', '2024-05-27 01:38:45', 0, 2),
(24, 1, 112, '2024-05-27 01:39:08', '2024-05-27 01:41:45', 0.53, 2),
(25, 1, 112, '2024-05-27 01:42:33', '2024-05-27 01:42:42', 0, 2),
(27, 1, 112, '2024-05-28 23:11:32', '2024-05-29 02:39:27', 3.68, 2),
(28, 1, 112, '2024-05-29 02:46:25', '2024-05-29 02:54:12', 0.79, 2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_cm`
--

DROP TABLE IF EXISTS `user_cm`;
CREATE TABLE `user_cm` (
  `id` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `id_TM` int(11) NOT NULL,
  `status` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user_cm`
--

INSERT INTO `user_cm` (`id`, `id_user`, `id_TM`, `status`) VALUES
(57, 112, 8, 1),
(58, 112, 9, 0),
(59, 112, 10, 0),
(74, 120, 1, 1),
(75, 120, 2, 1),
(76, 120, 3, 0),
(77, 120, 4, 0),
(78, 120, 5, 0),
(79, 120, 6, 0),
(80, 120, 7, 0),
(81, 123, 1, 0),
(82, 123, 2, 0),
(83, 123, 3, 0),
(84, 123, 4, 0),
(85, 123, 5, 0),
(86, 123, 6, 0),
(87, 123, 7, 0),
(88, 112, 1, 1),
(89, 112, 2, 1),
(90, 112, 3, 1),
(91, 112, 4, 1),
(92, 112, 5, 0),
(93, 112, 6, 0),
(94, 112, 7, 1),
(95, 126, 1, 0),
(96, 126, 2, 1),
(97, 126, 3, 1),
(98, 126, 4, 1),
(99, 126, 5, 1),
(100, 126, 6, 0),
(101, 126, 7, 0),
(102, 126, 8, 0),
(103, 126, 9, 0),
(104, 126, 10, 0),
(105, 126, 8, 0),
(106, 126, 9, 0),
(107, 126, 10, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_course`
--

DROP TABLE IF EXISTS `user_course`;
CREATE TABLE `user_course` (
  `id` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `id_course` int(11) NOT NULL,
  `percent` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user_course`
--

INSERT INTO `user_course` (`id`, `id_user`, `id_course`, `percent`) VALUES
(17, 112, 2, 33),
(20, 120, 1, 29),
(21, 123, 1, 0),
(22, 112, 1, 71),
(23, 126, 1, 57),
(24, 126, 2, 0),
(25, 126, 2, 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `answer`
--
ALTER TABLE `answer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_ques` (`id_ques`);

--
-- Chỉ mục cho bảng `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mon` (`id_mon`),
  ADD KEY `id_lop` (`id_lop`);
ALTER TABLE `course` ADD FULLTEXT KEY `name` (`name`);

--
-- Chỉ mục cho bảng `course_module`
--
ALTER TABLE `course_module`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`);

--
-- Chỉ mục cho bảng `detail_title`
--
ALTER TABLE `detail_title`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_TM` (`id_TM`),
  ADD KEY `type` (`type`);

--
-- Chỉ mục cho bảng `exams`
--
ALTER TABLE `exams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_class` (`id_class`),
  ADD KEY `id_subject` (`id_subject`);
ALTER TABLE `exams` ADD FULLTEXT KEY `name` (`name`);

--
-- Chỉ mục cho bảng `exams_answer`
--
ALTER TABLE `exams_answer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_ques` (`id_ques`);

--
-- Chỉ mục cho bảng `exams_question`
--
ALTER TABLE `exams_question`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_exam` (`id_exam`);

--
-- Chỉ mục cho bảng `heading_type`
--
ALTER TABLE `heading_type`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mon` (`id_mon`);
ALTER TABLE `question` ADD FULLTEXT KEY `content` (`content`);

--
-- Chỉ mục cho bảng `tblkhoi`
--
ALTER TABLE `tblkhoi`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tbllop`
--
ALTER TABLE `tbllop`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tblmon`
--
ALTER TABLE `tblmon`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tbluser`
--
ALTER TABLE `tbluser`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `key_username` (`username`);

--
-- Chỉ mục cho bảng `title_module`
--
ALTER TABLE `title_module`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_CM` (`id_CM`),
  ADD KEY `id_Course` (`id_Course`);

--
-- Chỉ mục cho bảng `users_answers`
--
ALTER TABLE `users_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_userExam` (`id_userExam`);

--
-- Chỉ mục cho bảng `users_exam`
--
ALTER TABLE `users_exam`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_exam` (`id_exam`);

--
-- Chỉ mục cho bảng `user_cm`
--
ALTER TABLE `user_cm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_TM` (`id_TM`);

--
-- Chỉ mục cho bảng `user_course`
--
ALTER TABLE `user_course`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_course` (`id_course`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `answer`
--
ALTER TABLE `answer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT cho bảng `course`
--
ALTER TABLE `course`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `course_module`
--
ALTER TABLE `course_module`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `detail_title`
--
ALTER TABLE `detail_title`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT cho bảng `exams`
--
ALTER TABLE `exams`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `exams_answer`
--
ALTER TABLE `exams_answer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=153;

--
-- AUTO_INCREMENT cho bảng `exams_question`
--
ALTER TABLE `exams_question`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT cho bảng `question`
--
ALTER TABLE `question`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;

--
-- AUTO_INCREMENT cho bảng `tblkhoi`
--
ALTER TABLE `tblkhoi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tbllop`
--
ALTER TABLE `tbllop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `tblmon`
--
ALTER TABLE `tblmon`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `tbluser`
--
ALTER TABLE `tbluser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT cho bảng `title_module`
--
ALTER TABLE `title_module`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `users_answers`
--
ALTER TABLE `users_answers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=345;

--
-- AUTO_INCREMENT cho bảng `users_exam`
--
ALTER TABLE `users_exam`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT cho bảng `user_cm`
--
ALTER TABLE `user_cm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT cho bảng `user_course`
--
ALTER TABLE `user_course`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `answer`
--
ALTER TABLE `answer`
  ADD CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`id_ques`) REFERENCES `question` (`id`);

--
-- Các ràng buộc cho bảng `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_ibfk_1` FOREIGN KEY (`id_mon`) REFERENCES `tblmon` (`id`),
  ADD CONSTRAINT `course_ibfk_2` FOREIGN KEY (`id_lop`) REFERENCES `tbllop` (`id`);

--
-- Các ràng buộc cho bảng `course_module`
--
ALTER TABLE `course_module`
  ADD CONSTRAINT `course_module_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`);

--
-- Các ràng buộc cho bảng `detail_title`
--
ALTER TABLE `detail_title`
  ADD CONSTRAINT `detail_title_ibfk_1` FOREIGN KEY (`id_TM`) REFERENCES `title_module` (`id`),
  ADD CONSTRAINT `detail_title_ibfk_2` FOREIGN KEY (`type`) REFERENCES `heading_type` (`id`);

--
-- Các ràng buộc cho bảng `exams`
--
ALTER TABLE `exams`
  ADD CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`id_class`) REFERENCES `tbllop` (`id`),
  ADD CONSTRAINT `exams_ibfk_2` FOREIGN KEY (`id_subject`) REFERENCES `tblmon` (`id`);

--
-- Các ràng buộc cho bảng `exams_answer`
--
ALTER TABLE `exams_answer`
  ADD CONSTRAINT `exams_answer_ibfk_1` FOREIGN KEY (`id_ques`) REFERENCES `exams_question` (`id`);

--
-- Các ràng buộc cho bảng `exams_question`
--
ALTER TABLE `exams_question`
  ADD CONSTRAINT `exams_question_ibfk_1` FOREIGN KEY (`id_exam`) REFERENCES `exams` (`id`);

--
-- Các ràng buộc cho bảng `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_2` FOREIGN KEY (`id_mon`) REFERENCES `tblmon` (`id`);

--
-- Các ràng buộc cho bảng `title_module`
--
ALTER TABLE `title_module`
  ADD CONSTRAINT `title_module_ibfk_1` FOREIGN KEY (`id_CM`) REFERENCES `course_module` (`id`),
  ADD CONSTRAINT `title_module_ibfk_2` FOREIGN KEY (`id_Course`) REFERENCES `course` (`id`);

--
-- Các ràng buộc cho bảng `users_answers`
--
ALTER TABLE `users_answers`
  ADD CONSTRAINT `users_answers_ibfk_1` FOREIGN KEY (`id_userExam`) REFERENCES `users_exam` (`id`);

--
-- Các ràng buộc cho bảng `users_exam`
--
ALTER TABLE `users_exam`
  ADD CONSTRAINT `users_exam_ibfk_1` FOREIGN KEY (`id_exam`) REFERENCES `exams` (`id`);

--
-- Các ràng buộc cho bảng `user_cm`
--
ALTER TABLE `user_cm`
  ADD CONSTRAINT `user_cm_ibfk_2` FOREIGN KEY (`id_TM`) REFERENCES `title_module` (`id`);

--
-- Các ràng buộc cho bảng `user_course`
--
ALTER TABLE `user_course`
  ADD CONSTRAINT `user_course_ibfk_1` FOREIGN KEY (`id_course`) REFERENCES `course` (`id`);
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
