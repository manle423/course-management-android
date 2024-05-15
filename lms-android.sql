-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 15, 2024 at 06:18 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_users` (IN `offset` INT, IN `limitPerPage` INT)   BEGIN
    SELECT * FROM users LIMIT offset, limitPerPage;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_category_by_id` (IN `id` INT)   BEGIN
    SELECT * FROM categories WHERE category_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_course_by_id` (IN `id` VARCHAR(255))   BEGIN
    SELECT *
    FROM courses
    WHERE course_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_user_by_id` (IN `p_id` VARCHAR(36))   BEGIN
    SELECT user_id, username, is_active, role_id 
    FROM users
    WHERE user_id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_user_by_username` (IN `p_username` VARCHAR(255))   BEGIN
    SELECT * FROM users WHERE username = p_username;
END$$

DELIMITER ;

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
(2, 'Category B');

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
('course1', 'Course 1', 'Description for Course 1', 'image1.jpg', 'video1.mp4', 1, 0),
('course2', 'Course 2', 'Description for Course 2', 'image2.jpg', 'video2.mp4', 2, 0),
('course3', 'Course 3', 'Description for Course 3', 'image3.jpg', 'video3.mp4', 1, 0),
('e603f757-b9e1-4153-ade0-7d7d88deb9fa', 'Course1', 'Des1', '', '', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `course_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(3, 'user');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `role_id` bigint DEFAULT '3'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `is_active`, `role_id`) VALUES
('2f9f0cb2-76c1-43bf-9fbc-e5af4c5381f8', 'user2', '$2b$10$U79ykClg1h9LN6f8ZV6OvO8WoKOJZEp/bhtog99W0GabKS888bS5.', 1, 3),
('7e1b0bb0-f33f-4e76-822b-fc210749e1df', 'user3', '$2b$10$1vXoYIrPqA5Qhb2Z4wlWku4aPCaVqUyRr4ZO//gWrWnLAWSkBY/.u', 1, 3),
('84227c70-014f-4fff-98d6-2448c8a0d4fd', 'man', '$2b$10$.bqDZPzV6ilQzlDtG0KMcO2mRgM9IuL8CLT6mXOhkYI1bR7WQy14e', 1, 1),
('8a164fa7-95f7-4554-9359-93a199e4f403', 'user1', '$2b$10$g2Sb8Nd3W.ZRLgKRWzJTZ.SHFJv3DG32wjq1UzJrhSnevSMeWsFGK', 1, 3),
('8c70dca9-edf4-4cb3-92d1-2cbbacc19c38', 'admin', '$2b$10$pklxTyC58whxFyfVxoh6ke.AEXqZydaN8qrxw/jEA0lfamd6EeCMm', 1, 1),
('b1a8100c-f748-4a61-900c-0900af43732d', 'moderator', '$2b$10$scHNmbvf8kpW3NljmwOYs.L.4zSI9BwhY0gmenaR/dOjPB.bnRH5G', 1, 2),
('dafddefa-86f1-484a-a272-fcdcfc08bb4f', 'user', '$2b$10$taGbcEN4vcOpkZ/CdRIonusgY2tfK6l6TdqavXXFE.Et1dzr7O356', 1, 3);

--
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
