-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 04, 2024 at 06:56 AM
-- Server version: 8.0.36
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lms-android`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_to_blacklist` (IN `p_token_value` TEXT)   BEGIN
    INSERT INTO blacklists (token_value)
    VALUES (p_token_value);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_change_info` (IN `p_id` VARCHAR(255), IN `p_full_name` VARCHAR(255))   BEGIN
    UPDATE users 
    SET full_name = p_full_name 
    WHERE user_id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_check_is_active` (IN `p_id` CHAR(36))   BEGIN
    DECLARE user_count INT;

    -- Check if there is a user with the given ID and is_active = true
    SELECT COUNT(*) INTO user_count
    FROM users
    WHERE user_id = p_id AND is_active = TRUE;
    
    IF user_count > 0 THEN
        SELECT TRUE AS is_active;
    ELSE
        SELECT FALSE AS is_active;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_check_is_admin` (IN `p_user_id` VARCHAR(36))   BEGIN
    DECLARE is_user_admin BOOLEAN DEFAULT FALSE;

    -- Select the role_id for the given user_id
    SELECT role_id = 1 INTO is_user_admin
    FROM users
    WHERE user_id = p_user_id;

    -- If no matching user role found, set is_user_admin to FALSE
    IF is_user_admin IS NULL THEN
        SET is_user_admin = FALSE;
    END IF;

    -- Return the result
    SELECT is_user_admin AS is_user_admin;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_check_is_user_attended` (IN `p_user_id` VARCHAR(36), IN `p_course_id` VARCHAR(36))   BEGIN
    DECLARE order_exists BOOLEAN;

    SELECT EXISTS(
        SELECT 1
        FROM orders
        WHERE user_id = p_user_id AND course_id = p_course_id
    ) INTO order_exists;

    SELECT order_exists AS attended;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_check_token_in_blacklist` (IN `p_token_value` TEXT)   BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM blacklists
    WHERE token_value = p_token_value;

    IF v_count > 0 THEN
        SELECT TRUE AS token_exists;
    ELSE
        SELECT FALSE AS token_exists;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_check_username_exists` (IN `p_username` VARCHAR(255))   BEGIN
    DECLARE username_count INT;

    SELECT COUNT(*) INTO username_count
    FROM users
    WHERE username = p_username;

    IF username_count > 0 THEN
        SELECT TRUE AS username_available;
    ELSE
        SELECT FALSE AS username_available;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_category` (IN `p_name` VARCHAR(255))   BEGIN
    INSERT INTO categories (category_name)
    VALUES (p_name);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_course` (IN `p_id` VARCHAR(36), IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_image` VARCHAR(255), IN `p_video` VARCHAR(255), IN `p_category_id` INT)   BEGIN
    INSERT INTO courses (course_id, course_name, description, image, video, category_id)
    VALUES (p_id, p_name, p_description, p_image, p_video, p_category_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_order` (IN `p_id` VARCHAR(36), IN `p_user` VARCHAR(36), IN `p_course` VARCHAR(36))   BEGIN
    INSERT INTO orders (order_id, user_id, course_id)
    VALUES (p_id, p_user, p_course);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_role` (IN `p_name` VARCHAR(255))   BEGIN
    INSERT INTO roles (role_name)
    VALUES (p_name);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_user` (IN `p_id` VARCHAR(36), IN `p_email` VARCHAR(255), IN `p_username` VARCHAR(255), IN `p_password` VARCHAR(255))   BEGIN
    INSERT INTO users (user_id, email, username, password)
    VALUES (p_id, p_email, p_username, p_password);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_order` (IN `p_user` VARCHAR(36), IN `p_course` VARCHAR(36))   BEGIN
    delete from orders where user_id = p_user and course_id = p_course;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_categories` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM categories;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_courses` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM courses;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_roles` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM roles LIMIT offset, limitPerPage;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_users` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM users LIMIT offset, limitPerPage;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_order_by_user_id` (IN `p_user_id` VARCHAR(36))   BEGIN
    SELECT  
        c.*
    FROM 
        orders o
    JOIN 
        courses c
    ON 
        o.course_id = c.course_id
    WHERE 
        o.user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_total_courses` ()   BEGIN
    DECLARE course_count INT;

    SELECT COUNT(*) INTO course_count
    FROM courses;

    SELECT course_count;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_by_category` (IN `p_order` VARCHAR(4), IN `p_category_id` INT)   BEGIN
    IF p_order = 'asc' THEN
        SELECT
            c.*,
            COUNT(o.order_id) AS order_count
        FROM
            courses c
        LEFT JOIN
            orders o ON c.course_id = o.course_id
        WHERE
        	c.category_id = p_category_id
        GROUP BY
            c.course_id
        ORDER BY
            order_count ASC;
    ELSE
        SELECT
            c.*,
            COUNT(o.order_id) AS order_count
        FROM
            courses c
        LEFT JOIN
            orders o ON c.course_id = o.course_id
        WHERE
        	c.category_id = p_category_id
        GROUP BY
            c.course_id
        ORDER BY
            order_count DESC;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_category_by_id` (IN `id` INT)   BEGIN
    SELECT * FROM categories WHERE category_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_course` (IN `p_key` TEXT)   BEGIN
    SELECT * 
    FROM courses 
    WHERE course_name LIKE CONCAT('%', p_key, '%') OR description LIKE CONCAT('%', p_key, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_course_by_id` (IN `id` VARCHAR(255))   BEGIN
    SELECT *
    FROM courses
    WHERE course_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_user_by_id` (IN `p_id` VARCHAR(36))   BEGIN
    SELECT user_id, full_name, username, is_active, role_id 
    FROM users
    WHERE user_id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_user_by_username` (IN `p_username` VARCHAR(255))   BEGIN
    SELECT * FROM users WHERE username = p_username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_with_image_and_video` (IN `p_key` TEXT)   BEGIN
    SELECT * 
    FROM courses 
    WHERE (image IS NOT NULL AND video IS NOT NULL)
    AND (course_name LIKE CONCAT('%', p_key, '%') OR description LIKE CONCAT('%', p_key, '%'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sort_by_popularity` (IN `p_order` VARCHAR(4))   BEGIN
    IF p_order = 'asc' THEN
        SELECT
            c.*,
            COUNT(o.order_id) AS order_count
        FROM
            courses c
        LEFT JOIN
            orders o ON c.course_id = o.course_id
        GROUP BY
            c.course_id
        ORDER BY
            order_count ASC;
    ELSE
        SELECT
            c.*,
            COUNT(o.order_id) AS order_count
        FROM
            courses c
        LEFT JOIN
            orders o ON c.course_id = o.course_id
        GROUP BY
            c.course_id
        ORDER BY
            order_count DESC;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sort_by_popularity_asc` ()   BEGIN
    SELECT
        c.*,
        COUNT(o.order_id) AS order_count
    FROM
        courses c
    LEFT JOIN
        orders o ON c.course_id = o.course_id
    GROUP BY
        c.course_id
    ORDER BY
        order_count ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sort_by_popularity_desc` ()   BEGIN
    SELECT
        c.*,
        COUNT(o.order_id) AS order_count
    FROM
        courses c
    LEFT JOIN
        orders o ON c.course_id = o.course_id
    GROUP BY
        c.course_id
    ORDER BY
        order_count DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_course` (IN `p_id` VARCHAR(36), IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_image` VARCHAR(255), IN `p_video` VARCHAR(255), IN `p_category_id` INT)   BEGIN
    UPDATE courses 
    SET 
        course_name = p_name, 
        description = p_description, 
        image = p_image, 
        video = p_video, 
        category_id = p_category_id
    WHERE course_id = p_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `blacklists`
--

CREATE TABLE `blacklists` (
  `id` int NOT NULL,
  `token_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blacklists`
--

INSERT INTO `blacklists` (`id`, `token_value`) VALUES
(1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiMWE4MTAwYy1mNzQ4LTRhNjEtOTAwYy0wOTAwYWY0MzczMmQiLCJ1c2VybmFtZSI6Im1vZGVyYXRvciIsInJvbGVfaWQiOjIsImlhdCI6MTcxNTc4Mjk5NywiZXhwIjoxNzE1ODY5Mzk3fQ.pvLR3roFYj0wUiiz4npfZOrb0zJXcZELmwDiX6FrywE'),
(2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiMWE4MTAwYy1mNzQ4LTRhNjEtOTAwYy0wOTAwYWY0MzczMmQiLCJ1c2VybmFtZSI6Im1vZGVyYXRvciIsInJvbGVfaWQiOjIsImlhdCI6MTcxNjk4ODMwNCwiZXhwIjoxNzE3MDc0NzA0fQ.uH-PcPrJbKlnbrQfVu-rmrd4HU8NYoRwDMdpecwPr2I');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` bigint NOT NULL,
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(8, 'category F'),
(9, 'category G'),
(4, 'Công nghệ'),
(7, 'Kỹ năng sống'),
(3, 'Lập trình'),
(10, 'LTĐH'),
(5, 'Nghệ thuật\r\n'),
(1, 'Thiết kế'),
(2, 'Đời sống');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `course_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `video` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `category_id` bigint NOT NULL,
  `is_deleted` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `course_name`, `description`, `image`, `video`, `category_id`, `is_deleted`) VALUES
('01ea24fa-b263-49a5-a0e6-02e351a43b8e', 'HTML & CSS Full Course 🌎 (2023)', 'Bro Code đã trở lại với một khóa học vỏn vẹn 4 tiếng, bao hàm toàn bộ các kiến thức nền tảng về HTML và CSS.', 'html_css.jpg', 'https://youtu.be/HGTJBPNC-Gw?si=FSSMwoRUCjdkcshN', 3, 0),
('080f2d5f-f55d-4b4e-9e01-a9906777ce19', 'Khóa học Digital Marketing nền tảng - Trần Minh Nhân Chính', 'Một series video của Trần Minh Nhân Chính, bao bọc các kiến thức nền tảng nhất về Digital Marketing, đồng thời mở rộng sang cả Landing Page, Website, Facebook Ads,...', 'digital_marketing.jpg', 'https://www.youtube.com/watch?v=93zSv9UjpAc&list=PLrwsw2It1I1kHlbF0yHcHIzI2ZY1eAtkk', 4, 0),
('1258005c-64d8-446e-aae3-dc60faae07cf', 'Cải thiện kỹ năng giao tiếp - Conor Neil', 'Tổng hợp những cách thức, lời khuyên về giao tiếp từ giáo sư Conor Neil thuộc IESE Business School.', 'communication_skills.jpg', 'https://www.youtube.com/playlist?list=PL8EEC66CC5F02545C', 7, 0),
('1258005c-64d8-446e-aae3-dc60faae0f7c', 'Java Programming for Beginners – Full Course', 'Khóa học này sẽ cung cấp cho bạn những kiến thức nền tảng về ngôn ngữ Java chỉ trong 4 tiếng.', 'java.jpg', 'https://www.youtube.com/watch?v=A74TOX803D0', 3, 0),
('1673770a-1f69-4276-8244-b3203d9bc42f', 'Photoshop for Beginners', 'Sau 3 tiếng đồng hồ với khóa học này, bạn sẽ có thể tự tin làm chủ ứng dụng Photoshop, biến nó thành công cụ đắc lực trong quá trình thiết kế hình ảnh.', 'photoshop_beginner.jpg', 'https://www.youtube.com/watch?v=IyR_uYsRdPs&t=1s', 1, 0),
('208c7361-db53-46ba-adc9-4ea8a7b3f458', 'Java Full Course ☕', 'Toàn bộ những thông tin cơ bản, nền tảng về Java, gói gọn trong 1 khóa học dài 12 tiếng đồng hồ từ Bro Code.', 'java.jpg', 'https://www.youtube.com/watch?v=xk4_1vDrzzo&t=2s', 3, 0),
('29c8d915-3024-4299-af1d-3b1096692050', 'Python Full Course 🐍', 'Khóa học này cung cấp những kiến thức nền tảng về Python, đồng thời cho người học áp dụng những kiến thức này vào các dự án đơn giản.', 'python.png', 'https://www.youtube.com/watch?v=XKHEtdqhLK8&t=16867s', 3, 0),
('2a7b6451-c01d-4c07-a58e-b9268dfb9a09', 'Chinh Phục Adobe Illustrator - Thùy Uyên', 'Sau khi hoàn thành khóa học này, bạn có thể tự tin làm chủ ứng dụng Adobe Illustrator.', 'illustrator.jpg', 'https://www.youtube.com/watch?v=aQMopS2idcc&list=PL6G5alza0BdSq48VSa1T3ApIkf5Wflb7Q&index=1', 1, 0),
('36fb6c53-591d-438d-b87d-460fcec40992', 'Harvard CS50’s Artificial Intelligence with Python', 'Những kiến thức cơ bản nhất về trí tuệ nhân tạo được cung cấp từ giảng viên thuộc đại học Harvard.', 'ai_in_business.jpg', 'https://youtu.be/5NgNicANyqM?si=Owv3vc5YoaHkwZJ1', 4, 0),
('480380f5-3c70-428e-b512-17bb754875ff', 'Học Guitar cơ bản trong 30 ngày', 'Nếu làm theo khóa học này, bạn sẽ thực sự có thể chơi Guitar chỉ sau 30 ngày. Không tin ư? Bạn cứ vào học là sẽ kiểm chứng được ngay!', 'guitar_beginner.jpg', 'https://www.youtube.com/playlist?list=PLFcgHQh5q7E6hoY5UJMkh1vaY25mPha3W', 5, 0),
('48a66180-bf29-4a99-86b6-de2ab7e70055', 'Hello', 'Hello', 'book1.jpg', 'youtube.com', 7, 0),
('886b2280-1f24-11ef-b25d-0250835b3290', 'C++ Full Course ⚡️', 'Khóa học cung cấp những kiến thức cơ bản về ngôn ngữ C++, đồng thơi có các bài tập cho người học vận dụng kiến thức đã học.', 'book3.jpg', 'https://www.youtube.com/watch?v=-TkoO8Z07hI', 3, 0),
('fd871af9-cb9c-444d-882c-0c9595ac0f0a', 'Photoshop for beginner', 'bạn muốn đẹp hơn? sao không thử photoshop', 'photoshop_beginner.jpg', 'https://youtu.be/HdxtcBILnow?si=qAVBgVXSEaTtgMYB', 3, 0);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `course_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `course_id`) VALUES
('0bfc4a08-cf51-46b5-8fc7-1185042091b7', '8a164fa7-95f7-4554-9359-93a199e4f403', '080f2d5f-f55d-4b4e-9e01-a9906777ce19'),
('37ba5b9d-80a6-4bcf-8c54-3c992311b684', '8a164fa7-95f7-4554-9359-93a199e4f403', '01ea24fa-b263-49a5-a0e6-02e351a43b8e'),
('3a9a6fe3-2921-4ab9-b6d7-a7f445b7932e', '1693101e-9710-404c-9334-25a496daeaea', '01ea24fa-b263-49a5-a0e6-02e351a43b8e'),
('a53501e8-ca8d-48b8-8c92-451eb0bcb7e2', '8a164fa7-95f7-4554-9359-93a199e4f403', '2a7b6451-c01d-4c07-a58e-b9268dfb9a09'),
('ea2a4295-7661-4aa9-b6ef-1f109f489741', '8a164fa7-95f7-4554-9359-93a199e4f403', '36fb6c53-591d-438d-b87d-460fcec40992'),
('fe8a8081-624d-4333-b826-f650f9554c8d', '1693101e-9710-404c-9334-25a496daeaea', 'fd871af9-cb9c-444d-882c-0c9595ac0f0a');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` bigint NOT NULL,
  `role_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(1, 'admin'),
(2, 'manager'),
(4, 'test'),
(3, 'user');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `role_id` bigint DEFAULT '3'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `email`, `full_name`, `username`, `password`, `is_active`, `role_id`) VALUES
('073a0add-dc55-4f40-bbc3-d324f946b93c', NULL, NULL, 'emm', '$2b$10$nkWLEYSHVy69zrdWI4/PV.KqvnuC0wmbRbZjvGRrlE/vHopQm1JYS', 1, 3),
('1', NULL, 'mod', 'mod', '$2b$10$scHNmbvf8kpW3NljmwOYs.L.4zSI9BwhY0gmenaR/dOjPB.bnRH5G', 1, 2),
('1693101e-9710-404c-9334-25a496daeaea', NULL, '', 'newuser', '$2b$10$4f9P55/g26UN3ZKxV6E0vOwuUffMZ4lYzqIqE9wPFXwnCKrQ8USqu', 1, 3),
('2f9f0cb2-76c1-43bf-9fbc-e5af4c5381f8', NULL, 'Nguyễn A', 'user2', '$2b$10$U79ykClg1h9LN6f8ZV6OvO8WoKOJZEp/bhtog99W0GabKS888bS5.', 1, 3),
('35a2f92a-92b2-4b14-bf03-823c60d728d2', NULL, 'Tester', 'tester', '$2b$10$UUFnKD0tz4GEnw9/I8iIqOgCX71qj/X6ubKLa06nowqdpcphwUIJy', 1, 3),
('51e3af0d-5f1c-4148-a07c-f62f7a331187', NULL, NULL, 'new', '$2b$10$HWlmn3Ad732HUKNOnm/BOO.Fj1dBK44ObqfYi4018lo47/Xezzc9m', 1, 3),
('7e1b0bb0-f33f-4e76-822b-fc210749e1df', NULL, 'Thì sao', 'user3', '$2b$10$1vXoYIrPqA5Qhb2Z4wlWku4aPCaVqUyRr4ZO//gWrWnLAWSkBY/.u', 1, 3),
('84227c70-014f-4fff-98d6-2448c8a0d4fd', NULL, 'Lê Nguyễn Trung Mẫn', 'man', '$2b$10$.bqDZPzV6ilQzlDtG0KMcO2mRgM9IuL8CLT6mXOhkYI1bR7WQy14e', 1, 1),
('87245ca0-b2c4-4793-b4ab-4907e4688807', NULL, '', 'hule', '$2b$10$q93GG1TUqCjLtM0Sr0tToekEJm3RrBS9iPVBUWDbWIDwGUWygIJbC', 1, 3),
('8a164fa7-95f7-4554-9359-93a199e4f403', NULL, 'Trần B', 'user1', '$2b$10$g2Sb8Nd3W.ZRLgKRWzJTZ.SHFJv3DG32wjq1UzJrhSnevSMeWsFGK', 1, 3),
('8c70dca9-edf4-4cb3-92d1-2cbbacc19c38', NULL, 'Updated Name', 'admin', '$2b$10$pklxTyC58whxFyfVxoh6ke.AEXqZydaN8qrxw/jEA0lfamd6EeCMm', 1, 1),
('9561ac5a-9248-4bee-aad6-2e07e6e678af', NULL, '', 'tester1', '$2b$10$hB3yU6WOrV7zgpHjAbXvq.yLgU2jF5aQUF5xTYUUM9rl0BlHpC7MO', 1, 3),
('b1a8100c-f748-4a61-900c-0900af43732d', NULL, 'Nguyễn D', 'moderator', '$2b$10$scHNmbvf8kpW3NljmwOYs.L.4zSI9BwhY0gmenaR/dOjPB.bnRH5G', 1, 2),
('b6cd722b-ea1b-4d21-afa8-f7917b8fce54', NULL, NULL, 'user have email 1', '$2b$10$mTgMJlMdVAyLCrDqQk89eeX1uDJQ8HanandmTc4fIewBIRXYZjFSe', 1, 3),
('ba9e50c3-723c-495e-b1f8-a9693af20a6b', NULL, NULL, 'emailgam', '$2b$10$IJNjZBACOiUyuff5LZonyu3kIugCeimzf/S0S7sxNuy9me8HJyzfe', 1, 3),
('dafddefa-86f1-484a-a272-fcdcfc08bb4f', NULL, 'Lê E', 'user', '$2b$10$taGbcEN4vcOpkZ/CdRIonusgY2tfK6l6TdqavXXFE.Et1dzr7O356', 1, 3),
('f54c49be-bbfd-4811-8831-f1bdd895dde7', NULL, '', 'dinhan', '$2b$10$sOCXGm7MnF41B2c4lwueGu2gK6NQwvX0FAcx.9/LZoGE7v1VGbwYy', 1, 3),
('f6db8955-a680-438d-8c63-6dcf7222e2e6', NULL, 'Nguyễn F', 'test', '$2b$10$6mGpKO4sli1qL/ZM40Ii8ejB8EN/YzUKaPm7DBeW81dGLHKcgS5yi', 1, 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blacklists`
--
ALTER TABLE `blacklists`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `unique_name` (`category_name`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `unique_role_name` (`role_name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `unique_username` (`username`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blacklists`
--
ALTER TABLE `blacklists`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
