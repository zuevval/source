-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 13 2018 г., 21:20
-- Версия сервера: 5.6.38
-- Версия PHP: 5.5.38

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `time-forward`
--

-- --------------------------------------------------------

--
-- Структура таблицы `grp_136322_timetable`
--

CREATE TABLE `grp_136322_timetable` (
  `day` int(11) NOT NULL,
  `id_1` int(11) NOT NULL,
  `start_1` int(11) NOT NULL,
  `stop_1` int(11) NOT NULL,
  `id_2` int(11) NOT NULL,
  `start_2` int(11) NOT NULL,
  `stop_2` int(11) NOT NULL,
  `id_3` int(11) NOT NULL,
  `start_3` int(11) NOT NULL,
  `stop_3` int(11) NOT NULL,
  `id_4` int(11) NOT NULL,
  `start_4` int(11) NOT NULL,
  `stop_4` int(11) NOT NULL,
  `id_5` int(11) NOT NULL,
  `start_5` int(11) NOT NULL,
  `stop_5` int(11) NOT NULL,
  `name_1` text NOT NULL,
  `name_2` text NOT NULL,
  `name_3` text NOT NULL,
  `name_4` text NOT NULL,
  `name_5` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `grp_136322_timetable`
--

INSERT INTO `grp_136322_timetable` (`day`, `id_1`, `start_1`, `stop_1`, `id_2`, `start_2`, `stop_2`, `id_3`, `start_3`, `stop_3`, `id_4`, `start_4`, `stop_4`, `id_5`, `start_5`, `stop_5`, `name_1`, `name_2`, `name_3`, `name_4`, `name_5`) VALUES
(0, 1, 120, 140, 2, 144, 164, 3, 168, 188, 0, 0, 0, 0, 0, 0, 'физика', 'английский язык', 'физкультура', '', ''),
(1, 1, 120, 140, 2, 144, 164, 3, 168, 188, 0, 0, 0, 0, 0, 0, 'экономика', 'математическое моделирование', 'математический анализ (лекция)', '', '');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `login` text NOT NULL,
  `pass` text NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`login`, `pass`, `user_id`, `group_id`) VALUES
('zuev', 'qwerty', 1, 136322);

-- --------------------------------------------------------

--
-- Структура таблицы `usr_1_online`
--

CREATE TABLE `usr_1_online` (
  `id` int(11) NOT NULL,
  `day_deadline` int(11) NOT NULL,
  `min_time` int(11) NOT NULL,
  `max_time` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `usr_1_online`
--

INSERT INTO `usr_1_online` (`id`, `day_deadline`, `min_time`, `max_time`, `name`) VALUES
(212, 2, 6, 12, 'тест по истории'),
(213, 5, 12, 12, 'практика по экономике');

-- --------------------------------------------------------

--
-- Структура таблицы `usr_1_raw`
--

CREATE TABLE `usr_1_raw` (
  `day` int(11) NOT NULL,
  `event_id` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `usr_1_raw`
--

INSERT INTO `usr_1_raw` (`day`, `event_id`) VALUES
(0, '201'),
(0, '202');

-- --------------------------------------------------------

--
-- Структура таблицы `usr_1_raw_events`
--

CREATE TABLE `usr_1_raw_events` (
  `day` int(11) NOT NULL,
  `id_1` int(11) NOT NULL,
  `start_1` int(11) NOT NULL,
  `stop_1` int(11) NOT NULL,
  `id_2` int(11) NOT NULL,
  `start_2` int(11) NOT NULL,
  `stop_2` int(11) NOT NULL,
  `id_3` int(11) NOT NULL,
  `start_3` int(11) NOT NULL,
  `stop_3` int(11) NOT NULL,
  `id_4` int(11) NOT NULL,
  `start_4` int(11) NOT NULL,
  `stop_4` int(11) NOT NULL,
  `id_5` int(11) NOT NULL,
  `start_5` int(11) NOT NULL,
  `stop_5` int(11) NOT NULL,
  `id_6` int(11) NOT NULL,
  `start_6` int(11) NOT NULL,
  `stop_6` int(11) NOT NULL,
  `id_7` int(11) NOT NULL,
  `start_7` int(11) NOT NULL,
  `stop_7` int(11) NOT NULL,
  `id_8` int(11) NOT NULL,
  `start_8` int(11) NOT NULL,
  `stop_8` int(11) NOT NULL,
  `id_9` int(11) NOT NULL,
  `start_9` int(11) NOT NULL,
  `stop_9` int(11) NOT NULL,
  `id_10` int(11) NOT NULL,
  `start_10` int(11) NOT NULL,
  `stop_10` int(11) NOT NULL,
  `id_11` int(11) NOT NULL,
  `start_11` int(11) NOT NULL,
  `stop_11` int(11) NOT NULL,
  `id_12` int(11) NOT NULL,
  `start_12` int(11) NOT NULL,
  `stop_12` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `usr_1_raw_events`
--

INSERT INTO `usr_1_raw_events` (`day`, `id_1`, `start_1`, `stop_1`, `id_2`, `start_2`, `stop_2`, `id_3`, `start_3`, `stop_3`, `id_4`, `start_4`, `stop_4`, `id_5`, `start_5`, `stop_5`, `id_6`, `start_6`, `stop_6`, `id_7`, `start_7`, `stop_7`, `id_8`, `start_8`, `stop_8`, `id_9`, `start_9`, `stop_9`, `id_10`, `start_10`, `stop_10`, `id_11`, `start_11`, `stop_11`, `id_12`, `start_12`, `stop_12`) VALUES
(0, 201, -1, -1, 202, -1, -1, 203, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1),
(1, 201, -1, -1, 202, -1, -1, 203, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);

-- --------------------------------------------------------

--
-- Структура таблицы `usr_1_schedule`
--

CREATE TABLE `usr_1_schedule` (
  `day` int(11) NOT NULL,
  `name_1` text NOT NULL,
  `start_1` int(11) NOT NULL,
  `stop_1` int(11) NOT NULL,
  `name_2` text NOT NULL,
  `start_2` int(11) NOT NULL,
  `stop_2` int(11) NOT NULL,
  `name_3` text NOT NULL,
  `start_3` int(11) NOT NULL,
  `stop_3` int(11) NOT NULL,
  `name_4` text NOT NULL,
  `start_4` int(11) NOT NULL,
  `stop_4` int(11) NOT NULL,
  `name_5` text NOT NULL,
  `start_5` int(11) NOT NULL,
  `stop_5` int(11) NOT NULL,
  `name_6` text NOT NULL,
  `start_6` int(11) NOT NULL,
  `stop_6` int(11) NOT NULL,
  `name_7` text NOT NULL,
  `start_7` int(11) NOT NULL,
  `stop_7` int(11) NOT NULL,
  `name_8` text NOT NULL,
  `start_8` int(11) NOT NULL,
  `stop_8` int(11) NOT NULL,
  `name_9` text NOT NULL,
  `start_9` int(11) NOT NULL,
  `stop_9` int(11) NOT NULL,
  `name_10` text NOT NULL,
  `start_10` int(11) NOT NULL,
  `stop_10` int(11) NOT NULL,
  `name_11` text NOT NULL,
  `start_11` int(11) NOT NULL,
  `stop_11` int(11) NOT NULL,
  `name_12` text NOT NULL,
  `start_12` int(11) NOT NULL,
  `stop_12` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `usr_1_schedule`
--

INSERT INTO `usr_1_schedule` (`day`, `name_1`, `start_1`, `stop_1`, `name_2`, `start_2`, `stop_2`, `name_3`, `start_3`, `stop_3`, `name_4`, `start_4`, `stop_4`, `name_5`, `start_5`, `stop_5`, `name_6`, `start_6`, `stop_6`, `name_7`, `start_7`, `stop_7`, `name_8`, `start_8`, `stop_8`, `name_9`, `start_9`, `stop_9`, `name_10`, `start_10`, `stop_10`, `name_11`, `start_11`, `stop_11`, `name_12`, `start_12`, `stop_12`) VALUES
(0, 'история', 120, 140, 'матмоделирование', 144, 164, 'физкультура', 168, 188, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1),
(1, 'история', 120, 140, 'матмоделирование', 144, 164, 'физкультура', 168, 188, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1, '-1', -1, -1);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
