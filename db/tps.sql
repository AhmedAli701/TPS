-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 02, 2016 at 03:51 PM
-- Server version: 10.1.10-MariaDB
-- PHP Version: 7.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tps_empty`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `ID` int(11) NOT NULL,
  `SALES` double NOT NULL,
  `DEBTS` double NOT NULL,
  `INCOMES` double NOT NULL,
  `OUTGOINGS` double NOT NULL,
  `WITHDRAWALS` double NOT NULL,
  `PURCHASES` double NOT NULL,
  `BALANCE` double NOT NULL,
  `PROFITS` double NOT NULL,
  `DATE` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `debts`
--

CREATE TABLE `debts` (
  `ID` int(11) NOT NULL,
  `VALUE` double NOT NULL,
  `PAID` double NOT NULL,
  `ORDER_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `incomes`
--

CREATE TABLE `incomes` (
  `ID` int(11) NOT NULL,
  `DETAILS` varchar(300) NOT NULL,
  `VALUE` double NOT NULL,
  `DATE` date NOT NULL,
  `IS_DEBT` tinyint(1) NOT NULL,
  `ACCOUNT_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `incomes`
--
DELIMITER $$
CREATE TRIGGER `INCOMES_ADD` AFTER INSERT ON `incomes` FOR EACH ROW BEGIN
SET @VALUE = NEW.VALUE ;
IF NEW.IS_DEBT > 0 THEN
	SET @PROF = NEW.VALUE;
ELSEIF NEW.IS_DEBT = 0 THEN
	SET @PROF = 0;
END IF; 
UPDATE accounts SET INCOMES = INCOMES + @VALUE, BALANCE = BALANCE + @VALUE, PROFITS = PROFITS + @PROF WHERE ID = NEW.ACCOUNT_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `ID` int(11) NOT NULL,
  `CUSTOMER` varchar(200) NOT NULL,
  `PRICE` double NOT NULL,
  `PAID` double NOT NULL,
  `PURCHASES_VALUE` double NOT NULL,
  `DATE` date NOT NULL,
  `ACCOUNT_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `ORDERS_ADD_PUR_VALUE` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
SET @VALUE = NEW.PURCHASES_VALUE - OLD.PURCHASES_VALUE;
UPDATE accounts SET PROFITS = PROFITS - @VALUE WHERE ID = NEW.ACCOUNT_ID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `SALES_ADD_ORDER` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
SET @TOTAL_SALES = NEW.PAID ;
UPDATE accounts SET SALES = SALES + @TOTAL_SALES, BALANCE = BALANCE + @TOTAL_SALES, PROFITS = PROFITS + @TOTAL_SALES WHERE ID = NEW.ACCOUNT_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `outgoings`
--

CREATE TABLE `outgoings` (
  `ID` int(11) NOT NULL,
  `DETAILS` varchar(300) NOT NULL,
  `VALUE` double NOT NULL,
  `DATE` date NOT NULL,
  `ACCOUNT_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `outgoings`
--
DELIMITER $$
CREATE TRIGGER `OUTGOINGS_ADD` AFTER INSERT ON `outgoings` FOR EACH ROW BEGIN
SET @VALUE = NEW.VALUE ;
UPDATE accounts SET OUTGOINGS = OUTGOINGS + @VALUE, BALANCE = BALANCE - @VALUE WHERE ID = NEW.ACCOUNT_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `ID` int(11) NOT NULL,
  `ITEM` varchar(300) NOT NULL,
  `AMOUNT` int(11) NOT NULL,
  `PURCHASE_PRICE` double NOT NULL,
  `SELLER` varchar(100) NOT NULL,
  `DATE` date NOT NULL,
  `ACCOUNT_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `purchases`
--
DELIMITER $$
CREATE TRIGGER `PURCHASES_ADD` AFTER INSERT ON `purchases` FOR EACH ROW BEGIN
SET @VALUE = NEW.PURCHASE_PRICE ;
UPDATE accounts SET PURCHASES = PURCHASES + @VALUE WHERE ID = NEW.ACCOUNT_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `ID` int(11) NOT NULL,
  `ITEM_NAME` varchar(300) NOT NULL,
  `AMOUNT` int(11) NOT NULL,
  `PRICE` double NOT NULL,
  `PAID` double NOT NULL,
  `PURCHASES_VALUE` double NOT NULL,
  `ORDER_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `sales`
--
DELIMITER $$
CREATE TRIGGER `SALES_ADD_PUR_VALUE` AFTER UPDATE ON `sales` FOR EACH ROW BEGIN
SET @VALUE = NEW.PURCHASES_VALUE - OLD.PURCHASES_VALUE;
UPDATE orders SET PURCHASES_VALUE = PURCHASES_VALUE + @VALUE WHERE ID = NEW.ORDER_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `updates`
--

CREATE TABLE `updates` (
  `ID` int(11) NOT NULL,
  `VER` int(11) NOT NULL,
  `LINK` varchar(300) NOT NULL,
  `SIZE` int(11) NOT NULL,
  `APP_HASH` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `PASSWORD` varchar(100) NOT NULL,
  `TITLE` varchar(100) NOT NULL,
  `AUTH` varchar(100) NOT NULL,
  `LAST_EDIT` date NOT NULL,
  `LAST_LOGGED` date NOT NULL,
  `SEC_KEY` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `withdrawals`
--

CREATE TABLE `withdrawals` (
  `ID` int(11) NOT NULL,
  `DETAILS` varchar(300) NOT NULL,
  `VALUE` double NOT NULL,
  `DATE` date NOT NULL,
  `ACCOUNT_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `withdrawals`
--
DELIMITER $$
CREATE TRIGGER `WITHDRAWALS_ADD` AFTER INSERT ON `withdrawals` FOR EACH ROW BEGIN
SET @VALUE = NEW.VALUE ;
UPDATE accounts SET WITHDRAWALS = WITHDRAWALS + @VALUE, BALANCE = BALANCE - @VALUE WHERE ID = NEW.ACCOUNT_ID;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `debts`
--
ALTER TABLE `debts`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ORDER_ID` (`ORDER_ID`);

--
-- Indexes for table `incomes`
--
ALTER TABLE `incomes`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ACCOUNT_ID` (`ACCOUNT_ID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ACCOUNT_ID` (`ACCOUNT_ID`);

--
-- Indexes for table `outgoings`
--
ALTER TABLE `outgoings`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ACCOUNT_ID` (`ACCOUNT_ID`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ACCOUNT_ID` (`ACCOUNT_ID`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ORDER_ID` (`ORDER_ID`);

--
-- Indexes for table `updates`
--
ALTER TABLE `updates`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ACCOUNT_ID` (`ACCOUNT_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `debts`
--
ALTER TABLE `debts`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `incomes`
--
ALTER TABLE `incomes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;
--
-- AUTO_INCREMENT for table `outgoings`
--
ALTER TABLE `outgoings`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;
--
-- AUTO_INCREMENT for table `updates`
--
ALTER TABLE `updates`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `debts`
--
ALTER TABLE `debts`
  ADD CONSTRAINT `debts_ibfk_1` FOREIGN KEY (`ORDER_ID`) REFERENCES `orders` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `incomes`
--
ALTER TABLE `incomes`
  ADD CONSTRAINT `incomes_ibfk_1` FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `outgoings`
--
ALTER TABLE `outgoings`
  ADD CONSTRAINT `outgoings_ibfk_1` FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`ORDER_ID`) REFERENCES `orders` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD CONSTRAINT `withdrawals_ibfk_1` FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
