-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 30, 2024 at 03:15 PM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_user` (IN `p_id` VARCHAR(36), IN `p_username` VARCHAR(255), IN `p_password` VARCHAR(255))   BEGIN
    INSERT INTO users (user_id, username, password)
    VALUES (p_id, p_username, p_password);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_categories` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM categories LIMIT offset, limitPerPage;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_courses` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM courses LIMIT offset, limitPerPage;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_roles` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM roles LIMIT offset, limitPerPage;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_users` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM users LIMIT offset, limitPerPage;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_order_by_user_id` (IN `p_user_id` VARCHAR(36))   BEGIN
    SELECT * FROM orders WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_total_courses` ()   BEGIN
    DECLARE course_count INT;

    SELECT COUNT(*) INTO course_count
    FROM courses;

    SELECT course_count;
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
  `token_value` text COLLATE utf8mb4_general_ci NOT NULL
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
(3, 'Category 3'),
(1, 'Category A'),
(2, 'Category B'),
(4, 'Category C'),
(5, 'category D'),
(7, 'category E'),
(8, 'category F'),
(9, 'category G'),
(10, 'category H');

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
('01ea24fa-b263-49a5-a0e6-02e351a43b8e', 'Course2', 'Des1', 'g', 'g', 8, 0),
('080f2d5f-f55d-4b4e-9e01-a9906777ce19', 'Course2', 'Des1', '', '', 2, 0),
('1258005c-64d8-446e-aae3-dc60faae0f7c', 'Course2', 'Des1', '', '', 1, 0),
('1673770a-1f69-4276-8244-b3203d9bc42f', 'test', 'in android', 'book1.jpg', 'youtube.com', 8, 0),
('208c7361-db53-46ba-adc9-4ea8a7b3f458', 'Course2', 'Des1', '', '', 5, 0),
('29c8d915-3024-4299-af1d-3b1096692050', 'Course1', 'Des1', '', '', 2, 0),
('2a7b6451-c01d-4c07-a58e-b9268dfb9a09', 'Course1', 'Des1', '', '', 4, 0),
('36fb6c53-591d-438d-b87d-460fcec40992', 'Course1', 'Des1', '', '', 2, 0),
('480380f5-3c70-428e-b512-17bb754875ff', 'j', 'bhkb', 'j', 'jhjk', 9, 0),
('48895d54-fc5a-44ab-8218-b76070870a8b', 'c', 'c', 'c', 'c', 10, 0),
('560f8d72-3cfa-4b11-84ba-11eb13740596', 'Course1', 'Des1', '', '', 2, 0),
('6075ba19-e197-4cbc-b157-1bff71ca8138', 'Course2', 'Des1', '', '', 2, 0),
('6a028d2c-e1ef-4664-94a9-12b2ccf34495', 'Course2', 'Des1', '', '', 2, 0),
('79d588b1-7cf6-4fee-a093-d525e3fdd786', 'a', 'aa', 'aa', 'a', 7, 0),
('7dfa2d8f-2e5b-4164-9ec4-1731b58488a4', 'Course2', 'Des1', '', '', 2, 0),
('868afe24-5820-415e-9c9e-1dd9c5552304', 'Course2', 'Des1', '', '', 2, 0),
('8bc2edc8-efe2-4d20-a3fc-6702f25a2b7f', 'Course2', 'Des1', '', '', 2, 0),
('952b3eea-3793-43b0-b3d1-e8d04cf2f1ec', 'Course1', 'Des1', '', '', 1, 0),
('9d309a2f-887c-455a-989d-c8521a6daf7f', 'Course1', 'Des1', '', '', 2, 0),
('a3cd84da-bb66-4bbe-a09f-58d2d47dafd4', 'Course2', 'Des1', '', '', 5, 0),
('ba21b3a4-72cf-4c04-832e-a884f7156077', 'b', 'b', 'b', 'b', 10, 0),
('bd72ab78-209f-4311-a258-1ad4f9c5f5ac', 'Course1', 'Des1', '', '', 2, 0),
('c6f13e0c-8f5a-4802-9113-f1c457752d19', 'Course2', 'Des1', '', '', 2, 0),
('course1', 'course cos id la course1 da duoc update', 'course cos id la course1 da duoc update', 'course1.png', 'youtube.com', 1, 0),
('course2', 'course co id la course2 updated', 'course co id la course2 updated', 'course2.png', '', 2, 0),
('course3', 'Course 3', 'Description for Course 3', 'image3.jpg', 'video3.mp4', 1, 0),
('d741a44c-3e51-461a-9430-dcb73f172347', 'Course1', 'Des1', '', '', 2, 0),
('e1c25b47-e4a1-4a96-b68c-da552c65e83b', 'Course2', 'Des1', '', '', 4, 0),
('e603f757-b9e1-4153-ade0-7d7d88deb9fa', 'Course1', 'Des1', '', '', 2, 0),
('f8eef06c-639d-47b4-8bea-87abbd507a92', 'newcourseandroid', 'course add in android', '1', '1', 10, 0),
('fb7b640b-1768-403e-abcd-4ed710e64b35', 'Course1', 'Des1', '', '', 7, 0);

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
('160c750e-d536-4f91-9509-bdaa8a0dfdf6', '2f9f0cb2-76c1-43bf-9fbc-e5af4c5381f8', 'ba21b3a4-72cf-4c04-832e-a884f7156077'),
('9f9812ee-9230-49a0-b423-a93395a44bfc', '2f9f0cb2-76c1-43bf-9fbc-e5af4c5381f8', 'ba21b3a4-72cf-4c04-832e-a884f7156077'),
('fb40c2bf-16f3-4eab-bfa2-5bc65353a5ce', 'b1a8100c-f748-4a61-900c-0900af43732d', 'ba21b3a4-72cf-4c04-832e-a884f7156077');

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
  `full_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `role_id` bigint DEFAULT '3'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `username`, `password`, `is_active`, `role_id`) VALUES
('1', 'mod', 'mod', '$2b$10$scHNmbvf8kpW3NljmwOYs.L.4zSI9BwhY0gmenaR/dOjPB.bnRH5G', 1, 2),
('2f9f0cb2-76c1-43bf-9fbc-e5af4c5381f8', 'Nguyễn A', 'user2', '$2b$10$U79ykClg1h9LN6f8ZV6OvO8WoKOJZEp/bhtog99W0GabKS888bS5.', 1, 3),
('35a2f92a-92b2-4b14-bf03-823c60d728d2', 'Tester', 'tester', '$2b$10$UUFnKD0tz4GEnw9/I8iIqOgCX71qj/X6ubKLa06nowqdpcphwUIJy', 1, 3),
('7e1b0bb0-f33f-4e76-822b-fc210749e1df', 'Thì sao', 'user3', '$2b$10$1vXoYIrPqA5Qhb2Z4wlWku4aPCaVqUyRr4ZO//gWrWnLAWSkBY/.u', 1, 3),
('84227c70-014f-4fff-98d6-2448c8a0d4fd', 'Lê Nguyễn Trung Mẫn', 'man', '$2b$10$.bqDZPzV6ilQzlDtG0KMcO2mRgM9IuL8CLT6mXOhkYI1bR7WQy14e', 1, 1),
('87245ca0-b2c4-4793-b4ab-4907e4688807', '', 'hule', '$2b$10$q93GG1TUqCjLtM0Sr0tToekEJm3RrBS9iPVBUWDbWIDwGUWygIJbC', 1, 3),
('8a164fa7-95f7-4554-9359-93a199e4f403', 'Trần B', 'user1', '$2b$10$g2Sb8Nd3W.ZRLgKRWzJTZ.SHFJv3DG32wjq1UzJrhSnevSMeWsFGK', 1, 3),
('8c70dca9-edf4-4cb3-92d1-2cbbacc19c38', 'Updated Name', 'admin', '$2b$10$pklxTyC58whxFyfVxoh6ke.AEXqZydaN8qrxw/jEA0lfamd6EeCMm', 1, 1),
('9561ac5a-9248-4bee-aad6-2e07e6e678af', '', 'tester1', '$2b$10$hB3yU6WOrV7zgpHjAbXvq.yLgU2jF5aQUF5xTYUUM9rl0BlHpC7MO', 1, 3),
('b1a8100c-f748-4a61-900c-0900af43732d', 'Nguyễn D', 'moderator', '$2b$10$scHNmbvf8kpW3NljmwOYs.L.4zSI9BwhY0gmenaR/dOjPB.bnRH5G', 1, 2),
('dafddefa-86f1-484a-a272-fcdcfc08bb4f', 'Lê E', 'user', '$2b$10$taGbcEN4vcOpkZ/CdRIonusgY2tfK6l6TdqavXXFE.Et1dzr7O356', 1, 3),
('f6db8955-a680-438d-8c63-6dcf7222e2e6', 'Nguyễn F', 'test', '$2b$10$6mGpKO4sli1qL/ZM40Ii8ejB8EN/YzUKaPm7DBeW81dGLHKcgS5yi', 1, 3);

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
