-- BLUCK Database Schema
-- Version 1.0

-- Copyright (c) 2017, Samuel Adeshina <samueladeshina73@gmail.com>. 
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

--  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--  * Neither the name of Oracle nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

-- Schema bluck
DROP SCHEMA IF EXISTS bluck;
CREATE SCHEMA bluck;
USE bluck;

--
-- memberprofile table collection
--

--
-- Table structure for table `memberprofile_membercategories`
--
CREATE TABLE memberprofile_membercategories (
	category_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	category_name VARCHAR(30) NOT NULL UNIQUE
);

--
-- Table structure for table `memberprofile_membertypes`
--
CREATE TABLE memberprofile_membertypes (
	type_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	type_name VARCHAR(30) NOT NULL,
	type_category TINYINT UNSIGNED NOT NULL,
	UNIQUE(type_name, type_category),
	FOREIGN KEY (type_category) REFERENCES memberprofile_membercategories(category_id) ON UPDATE CASCADE ON DELETE CASCADE
);

--
-- Table structure for table `memberprofile_members`
--
CREATE TABLE memberprofile_members (
	member_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	member_type TINYINT UNSIGNED NOT NULL,
	join_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	last_modified DATE,
	FOREIGN KEY (member_type) REFERENCES memberprofile_membertypes(type_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

--
-- Table structure for table `memberprofile_memberinfofields`
--
CREATE TABLE memberprofile_memberinfofields (
	field_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	field_name VARCHAR(20) UNIQUE NOT NULL,
	field_description VARCHAR(50),
	field_type VARCHAR(10) -- valid html input field type
);

--
-- Table structure for table `memberprofile_memberinfofieldvalues`
--
CREATE TABLE memberprofile_memberinfofieldvalues (
	value_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	member_id INT UNSIGNED NOT NULL,
	field_id SMALLINT UNSIGNED,
	field_value VARCHAR(50),
	UNIQUE(member_id, field_id),
	FOREIGN KEY (member_id) REFERENCES memberprofile_members(member_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (field_id) REFERENCES memberprofile_memberinfofields(field_id) ON UPDATE CASCADE ON DELETE SET NULL
);