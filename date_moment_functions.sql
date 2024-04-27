--    Gregorian - Jalali Date Converter Functions for Mysql, v2.0.0 + hijri functions added 
--    Based on  Mohammad Saleh Souzanchi(saleh.souzanchi@gmail.com|https://github.com/zoghal), Mehran . M . Spitman
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program. If not, see <http://www.gnu.org/licenses/>.
--    Pathed by Amir Mirmoeini (Added read-only + deterministic flags to prevent errors in new and strict MySql or MariaDB environments)



-- ----------------------------
-- Function structure for `__mydiv`
-- ----------------------------
DROP FUNCTION IF EXISTS `__mydiv`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `__mydiv`(`a` int, `b` int) RETURNS bigint(20)
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2009-2019 Mohammad Saleh Souzanchi
# WebLog : www.saleh.soozanchi.ir
# Version V2.0.0

	return FLOOR(a / b);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `__mymod`
-- ----------------------------
DROP FUNCTION IF EXISTS `__mymod`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `__mymod`(`a` int, `b` int) RETURNS bigint(20)
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2011-2019 Mehran . M . Spitman
# WebLog :spitman.azdaa.com
# Version V2.0.0

	return (a - b * FLOOR(a / b));
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `_gdmarray`
-- ----------------------------
DROP FUNCTION IF EXISTS `_gdmarray`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `_gdmarray`(`m` smallint) RETURNS smallint(2)
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2009-2019 Mohammad Saleh Souzanchi
# WebLog : www.saleh.soozanchi.ir
# Version V2.0.0

	CASE m
		WHEN 0 THEN RETURN 31;
		WHEN 1 THEN RETURN 28;
		WHEN 2 THEN RETURN 31;
		WHEN 3 THEN RETURN 30;
		WHEN 4 THEN RETURN 31;
		WHEN 5 THEN RETURN 30;
		WHEN 6 THEN RETURN 31;
		WHEN 7 THEN RETURN 31;
		WHEN 8 THEN RETURN 30;
		WHEN 9 THEN RETURN 31;
		WHEN 10 THEN RETURN 30;
		WHEN 11 THEN RETURN 31;
	END CASE;

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `_jdmarray`
-- ----------------------------
DROP FUNCTION IF EXISTS `_jdmarray`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `_jdmarray`(`m` smallint) RETURNS smallint(2)
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2009-2019 Mohammad Saleh Souzanchi
# WebLog : www.saleh.soozanchi.ir
# Version V2.0.0

	CASE m
		WHEN 0 THEN RETURN 31;
		WHEN 1 THEN RETURN 31;
		WHEN 2 THEN RETURN 31;
		WHEN 3 THEN RETURN 31;
		WHEN 4 THEN RETURN 31;
		WHEN 5 THEN RETURN 31;
		WHEN 6 THEN RETURN 30;
		WHEN 7 THEN RETURN 30;
		WHEN 8 THEN RETURN 30;
		WHEN 9 THEN RETURN 30;
		WHEN 10 THEN RETURN 30;
		WHEN 11 THEN RETURN 29;
	END CASE;

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `_jdmarray2`
-- ----------------------------
DROP FUNCTION IF EXISTS `_jdmarray2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `_jdmarray2`(`m` smallint) RETURNS smallint(2)
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2011-2019 Mehran . M . Spitman
# WebLog :spitman.azdaa.com
# Version V2.0.0

	CASE m
		WHEN 1 THEN RETURN 31;
		WHEN 2 THEN RETURN 31;
		WHEN 3 THEN RETURN 31;
		WHEN 4 THEN RETURN 31;
		WHEN 5 THEN RETURN 31;
		WHEN 6 THEN RETURN 31;
		WHEN 7 THEN RETURN 30;
		WHEN 8 THEN RETURN 30;
		WHEN 9 THEN RETURN 30;
		WHEN 10 THEN RETURN 30;
		WHEN 11 THEN RETURN 30;
		WHEN 12 THEN RETURN 29;
	END CASE;

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `pdate`
-- ----------------------------
DROP FUNCTION IF EXISTS `pdate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `pdate`(`gdate` datetime) RETURNS char(100) CHARSET utf8
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2009-2019 Mohammad Saleh Souzanchi
# WebLog : www.saleh.soozanchi.ir
# Version V2.0.0

	DECLARE
		i,
		gy, gm, gd,
		g_day_no, j_day_no, j_np,jy INT DEFAULT 0;  /* Can be unsigned int? */
	DECLARE jm, jd INT(2) ZEROFILL DEFAULT 0;
	DECLARE resout char(100);
	DECLARE ttime CHAR(20);

	SET gy = YEAR(gdate) - 1600;
	SET gm = MONTH(gdate) - 1;
	SET gd = DAY(gdate) - 1;
	SET ttime = TIME(gdate);
	SET g_day_no = ((365 * gy) + __mydiv(gy + 3, 4) - __mydiv(gy + 99, 100) + __mydiv (gy + 399, 400));
	SET i = 0;

	WHILE (i < gm) do
		SET g_day_no = g_day_no + _gdmarray(i);
		SET i = i + 1;
	END WHILE;

	IF gm > 1 and ((gy % 4 = 0 and gy % 100 <> 0)) or gy % 400 = 0 THEN
		SET g_day_no =	g_day_no + 1;
	END IF;

	SET g_day_no = g_day_no + gd;
	SET j_day_no = g_day_no - 79;
	SET j_np = j_day_no DIV 12053;
	SET j_day_no = j_day_no % 12053;
	SET jy = 979 + 33 * j_np + 4 * __mydiv(j_day_no, 1461);
	SET j_day_no = j_day_no % 1461;

	IF j_day_no >= 366 then
		SET jy = jy + __mydiv(j_day_no - 1, 365);
		SET j_day_no = (j_day_no - 1) % 365;
	END IF;

	SET i = 0;

	WHILE (i < 11 and j_day_no >= _jdmarray(i)) do
		SET j_day_no = j_day_no - _jdmarray(i);
		SET i = i + 1;
	END WHILE;

	SET jm = i + 1;
	SET jd = j_day_no + 1;
	SET resout = CONCAT_WS ('-', jy, jm, jd);

	IF (ttime <> '00:00:00') then
		SET resout = CONCAT_WS(' ', resout, ttime);
	END IF;

	RETURN resout;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `PMONTH`
-- ----------------------------
DROP FUNCTION IF EXISTS `PMONTH`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `PMONTH`(`gdate` datetime) RETURNS char(100) CHARSET utf8
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2009-2019 Mohammad Saleh Souzanchi
# WebLog : www.saleh.soozanchi.ir
# Version V2.0.0

	DECLARE
		i,
		gy, gm, gd,
		g_day_no, j_day_no, j_np,
		jy, jm, jd INT DEFAULT 0; /* Can be unsigned int? */

	SET gy = YEAR(gdate) - 1600;
	SET gm = MONTH(gdate) - 1;
	SET gd = DAY(gdate) - 1;
	SET g_day_no = ((365 * gy) + __mydiv(gy + 3, 4) - __mydiv(gy + 99, 100) + __mydiv(gy + 399, 400));
	SET i = 0;

	WHILE (i < gm) do
		SET g_day_no = g_day_no + _gdmarray(i);
		SET i = i + 1;
	END WHILE;

	IF gm > 1 and ((gy % 4 = 0 and gy % 100 <> 0)) or gy % 400 = 0 THEN
		SET g_day_no = g_day_no + 1;
	END IF;

	SET g_day_no = g_day_no + gd;
	SET j_day_no = g_day_no - 79;
	SET j_np = j_day_no DIV 12053;
	set j_day_no = j_day_no % 12053;
	SET jy = 979 + 33 * j_np + 4 * __mydiv(j_day_no, 1461);
	SET j_day_no = j_day_no % 1461;

	IF j_day_no >= 366 then
		SET jy = jy + __mydiv(j_day_no - 1, 365);
		SET j_day_no =(j_day_no - 1) % 365;
	END IF;

	SET i = 0;

	WHILE (i < 11 and j_day_no >= _jdmarray(i)) do
		SET j_day_no = j_day_no - _jdmarray(i);
		SET i = i + 1;
	END WHILE;

	SET jm = i + 1;
	SET jd = j_day_no + 1;
	RETURN jm;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `pmonthname`
-- ----------------------------
DROP FUNCTION IF EXISTS `pmonthname`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `pmonthname`(`gdate` datetime) RETURNS varchar(100) CHARSET utf8
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2009-2019 Mohammad Saleh Souzanchi
# WebLog : www.saleh.soozanchi.ir
# Version V2.0.0

	CASE PMONTH(gdate)
		WHEN 1 THEN RETURN 'فروردین';
		WHEN 2 THEN RETURN 'اردیبهشت';
		WHEN 3 THEN	RETURN 'خرداد';
		WHEN 4 THEN	RETURN 'تیر';
		WHEN 5 THEN	RETURN 'مرداد';
		WHEN 6 THEN	RETURN 'شهریور';
		WHEN 7 THEN	RETURN 'مهر';
		WHEN 8 THEN	RETURN 'آبان';
		WHEN 9 THEN	RETURN 'آذر';
		WHEN 10 THEN RETURN	'دی';
		WHEN 11 THEN RETURN	'بهمن';
		WHEN 12 THEN RETURN	'اسفند';
	END CASE;

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `pyear`
-- ----------------------------
DROP FUNCTION IF EXISTS `pyear`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `pyear`(`gdate` datetime) RETURNS char(100) CHARSET utf8
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2009-2019 Mohammad Saleh Souzanchi
# WebLog : www.saleh.soozanchi.ir
# Version V2.0.0

	DECLARE
		i,
		gy, gm, gd,
		g_day_no, j_day_no, j_np,
		jy, jm, jd INT DEFAULT 0; /* Can be unsigned int? */

	SET gy = YEAR(gdate) - 1600;
	SET gm = MONTH(gdate) - 1;
	SET gd = DAY(gdate) - 1;
	SET g_day_no = ((365 * gy) + __mydiv(gy + 3, 4) - __mydiv(gy + 99, 100) + __mydiv(gy + 399, 400));
	SET i = 0;

	WHILE (i < gm) do
		SET g_day_no = g_day_no + _gdmarray(i);
		SET i = i + 1;
	END WHILE;

	IF gm > 1 and ((gy % 4 = 0 and gy % 100 <> 0)) or gy % 400 = 0 THEN
		SET g_day_no =	g_day_no + 1;
	END IF;

	SET g_day_no = g_day_no + gd;
	SET j_day_no = g_day_no - 79;
	SET j_np = j_day_no DIV 12053;
	set j_day_no = j_day_no % 12053;
	SET jy = 979 + 33 * j_np + 4 * __mydiv(j_day_no, 1461);
	SET j_day_no = j_day_no % 1461;

	IF j_day_no >= 366 then
		SET jy = jy + __mydiv(j_day_no - 1, 365);
		SET j_day_no = (j_day_no - 1) % 365;
	END IF;

	SET i = 0;

	WHILE (i < 11 and j_day_no >= _jdmarray(i)) do
		SET j_day_no = j_day_no - _jdmarray(i);
		SET i = i + 1;
	END WHILE;

	SET jm = i + 1;
	SET jd = j_day_no + 1;
	RETURN jy;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `pday`
-- ----------------------------
DROP FUNCTION IF EXISTS `pday`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `pday`(`gdate` datetime) RETURNS char(100) CHARSET utf8
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2011-2019 Mohammad Saleh Souzanchi, Mehran . M . Spitman
# WebLog : www.saleh.soozanchi.ir, spitman.azdaa.com
# Version V2.0.0

	DECLARE
		i,
		gy, gm, gd,
		g_day_no, j_day_no, j_np,
		jy, jm, jd INT DEFAULT 0; /* Can be unsigned int? */

	SET gy = YEAR(gdate) - 1600;
	SET gm = MONTH(gdate) - 1;
	SET gd = DAY(gdate) - 1;
	SET g_day_no = ((365 * gy) + __mydiv(gy + 3, 4) - __mydiv(gy + 99 , 100) + __mydiv(gy + 399, 400));
	SET i = 0;

	WHILE (i < gm) do
		SET g_day_no = g_day_no + _gdmarray(i);
		SET i = i + 1;
	END WHILE;

	IF gm > 1 and ((gy % 4 = 0 and gy % 100 <> 0)) or gy % 400 = 0 THEN
		SET g_day_no = g_day_no + 1;
	END IF;

	SET g_day_no = g_day_no + gd;
	SET j_day_no = g_day_no - 79;
	SET j_np = j_day_no DIV 12053;
	SET j_day_no = j_day_no % 12053;
	SET jy = 979 + 33 * j_np + 4 * __mydiv(j_day_no, 1461);
	SET j_day_no = j_day_no % 1461;

	IF j_day_no >= 366 then
		SET jy = jy + __mydiv(j_day_no - 1, 365);
		SET j_day_no = (j_day_no-1) % 365;
	END IF;

	SET i = 0;

	WHILE (i < 11 and j_day_no >= _jdmarray(i)) do
		SET j_day_no = j_day_no - _jdmarray(i);
		SET i = i + 1;
	END WHILE;

	SET jm = i + 1;
	SET jd = j_day_no + 1;
	RETURN jd;
END;;
DELIMITER ;


-- ----------------------------
-- Function structure for `_gdmarray2`
-- ----------------------------
DROP FUNCTION IF EXISTS `_gdmarray2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `_gdmarray2`(`m` smallint, `k` SMALLINT) RETURNS smallint(2)
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2011-2019  Mehran . M . Spitman
# WebLog :spitman.azdaa.com
# Version V2.0.0

	CASE m
		WHEN 0 THEN RETURN 31;
		WHEN 1 THEN RETURN 28+k;
		WHEN 2 THEN RETURN 31;
		WHEN 3 THEN RETURN 30;
		WHEN 4 THEN RETURN 31;
		WHEN 5 THEN RETURN 30;
		WHEN 6 THEN RETURN 31;
		WHEN 7 THEN RETURN 31;
		WHEN 8 THEN RETURN 30;
		WHEN 9 THEN RETURN 31;
		WHEN 10 THEN RETURN 30;
		WHEN 11 THEN RETURN 31;
	END CASE;


END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `gdate`
-- ----------------------------
DROP FUNCTION IF EXISTS `gdate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `gdate`(`jy` smallint, `jm` smallint, `jd` smallint) RETURNS datetime
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2011-2019 Mehran . M . Spitman
# WebLog :spitman.azdaa.com
# Version V2.0.0

	DECLARE
		i, j, e, k, mo,
		gy, gm, gd,
		g_day_no, j_day_no, bkab, jmm, mday, g_day_mo, bkab1, j1
	INT DEFAULT 0; /* Can be unsigned int? */
	DECLARE fdate datetime;


  SET bkab = __mymod(jy,33);

  IF (bkab = 1 or bkab= 5 or bkab = 9 or bkab = 13 or bkab = 17 or bkab = 22 or bkab = 26 or bkab = 30) THEN
    SET j=1;
  end IF;

  SET bkab1 = __mymod(jy+1,33);

  IF (bkab1 = 1 or bkab1= 5 or bkab1 = 9 or bkab1 = 13 or bkab1 = 17 or bkab1 = 22 or bkab1 = 26 or bkab1 = 30) THEN
    SET j1=1;
  end IF;

	CASE jm
		WHEN 1 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 2 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 3 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 4 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 5 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 6 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 7 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 8 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 9 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 10 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 11 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 12 THEN IF jd > _jdmarray2(jm)+j or jd <= 0 THEN SET e=1; end IF;
	END CASE;
  IF jm > 12 or jm <= 0 THEN SET e=1; end IF;
  IF jy <= 0 THEN SET e=1; end IF;

  IF e>0 THEN
    RETURN 0;
  end IF;

  IF (jm>=11) or (jm=10 and jd>=11 and j=0) or (jm=10 and jd>11 and j=1) THEN
    SET i=1;
  end IF;
  SET gy = jy + 621 + i;

  IF (__mymod(gy,4)=0) THEN
    SET k=1;
  end IF;

	IF (__mymod(gy,100)=0) and (__mymod(gy,400)<>0) THEN
		SET k=0;
	END IF;

  SET jmm=jm-1;

  WHILE (jmm > 0) do
    SET mday=mday+_jdmarray2(jmm);
    SET jmm=jmm-1;
  end WHILE;

  SET j_day_no=(jy-1)*365+(__mydiv(jy,4))+mday+jd;
  SET g_day_no=j_day_no+226899;


  SET g_day_no=g_day_no-(__mydiv(gy-1,4));
  SET g_day_mo=__mymod(g_day_no,365);

	IF (k=1 and j=1) THEN
		IF (g_day_mo=0) THEN
			RETURN CONCAT_WS('-',gy,'12','30');
		END IF;
		IF (g_day_mo=1) THEN
			RETURN CONCAT_WS('-',gy,'12','31');
		END IF;
	END IF;

	IF (g_day_mo=0) THEN
		RETURN CONCAT_WS('-',gy,'12','31');
	END IF;


  SET mo=0;
  SET gm=gm+1;
  while g_day_mo>_gdmarray2(mo,k) do
		SET g_day_mo=g_day_mo-_gdmarray2(mo,k);
    SET mo=mo+1;
    SET gm=gm+1;
  end WHILE;
  SET gd=g_day_mo;

  RETURN CONCAT_WS('-',gy,gm,gd);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for `gdatestr`
-- ----------------------------
DROP FUNCTION IF EXISTS `gdatestr`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `gdatestr`(`jdat` char(10)) RETURNS datetime
READS SQL DATA
DETERMINISTIC
BEGIN
# Copyright (C) 2011-2019 Mehran . M . Spitman
# WebLog spitman.azdaa.com
# Version V2.0.0

	DECLARE
		i, j, e, k, mo,
		gy, gm, gd,
		g_day_no, j_day_no, bkab, jmm, mday, g_day_mo, jd, jy, jm,bkab1,j1
	INT DEFAULT 0; /* ### Can't be unsigned int! ### */
	DECLARE jdd, jyd, jmd, jt varchar(100);
	DECLARE fdate datetime;

	SET jdd = SUBSTRING_INDEX(jdat, '/', -1);
	SET jt = SUBSTRING_INDEX(jdat, '/', 2);
	SET jyd = SUBSTRING_INDEX(jt, '/', 1);
	SET jmd = SUBSTRING_INDEX(jt, '/', -1);
	SET jd = CAST(jdd as SIGNED);
	SET jy = CAST(jyd as SIGNED);
	SET jm = CAST(jmd as SIGNED);


	 SET bkab = __mymod(jy,33);

  IF (bkab = 1 or bkab= 5 or bkab = 9 or bkab = 13 or bkab = 17 or bkab = 22 or bkab = 26 or bkab = 30) THEN
    SET j=1;
  end IF;

  SET bkab1 = __mymod(jy+1,33);

  IF (bkab1 = 1 or bkab1= 5 or bkab1 = 9 or bkab1 = 13 or bkab1 = 17 or bkab1 = 22 or bkab1 = 26 or bkab1 = 30) THEN
    SET j1=1;
  end IF;

	CASE jm
		WHEN 1 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 2 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 3 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 4 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 5 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 6 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 7 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 8 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 9 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 10 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 11 THEN IF jd > _jdmarray2(jm) or jd <= 0 THEN SET e=1; end IF;
		WHEN 12 THEN IF jd > _jdmarray2(jm)+j or jd <= 0 THEN SET e=1; end IF;
	END CASE;
  IF jm > 12 or jm <= 0 THEN SET e=1; end IF;
  IF jy <= 0 THEN SET e=1; end IF;

  IF e>0 THEN
    RETURN 0;
  end IF;

  IF (jm>=11) or (jm=10 and jd>=11 and j=0) or (jm=10 and jd>11 and j=1) THEN
    SET i=1;
  end IF;
  SET gy = jy + 621 + i;

  IF (__mymod(gy,4)=0) THEN
    SET k=1;
  end IF;

	IF (__mymod(gy,100)=0) and (__mymod(gy,400)<>0) THEN
		SET k=0;
	END IF;

  SET jmm=jm-1;

  WHILE (jmm > 0) do
    SET mday=mday+_jdmarray2(jmm);
    SET jmm=jmm-1;
  end WHILE;

  SET j_day_no=(jy-1)*365+(__mydiv(jy,4))+mday+jd;
  SET g_day_no=j_day_no+226899;


  SET g_day_no=g_day_no-(__mydiv(gy-1,4));
  SET g_day_mo=__mymod(g_day_no,365);

	IF (k=1 and j=1) THEN
		IF (g_day_mo=0) THEN
			RETURN CONCAT_WS('-',gy,'12','30');
		END IF;
		IF (g_day_mo=1) THEN
			RETURN CONCAT_WS('-',gy,'12','31');
		END IF;
	END IF;

	IF (g_day_mo=0) THEN
		RETURN CONCAT_WS('-',gy,'12','31');
	END IF;


  SET mo=0;
  SET gm=gm+1;
  while g_day_mo>_gdmarray2(mo,k) do
		SET g_day_mo=g_day_mo-_gdmarray2(mo,k);
    SET mo=mo+1;
    SET gm=gm+1;
  end WHILE;
  SET gd=g_day_mo;

  RETURN CONCAT_WS('-',gy,gm,gd);
END;;

DROP FUNCTION IF EXISTS `IntPart` $$
CREATE FUNCTION `IntPart` (FloatNum float) RETURNS INT
BEGIN
if (floatNum< -0.0000001) then
     return ceil(floatNum-0.0000001);
else
  return floor(floatNum+0.0000001);
end if;
END $$

DELIMITER ;


DELIMITER $$

DROP FUNCTION IF EXISTS `georgiantohijri` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `georgiantohijri`(MiladiTarih date) RETURNS varchar(10) CHARSET utf8
BEGIN
  declare d,m,y,jd,l,n,j int;
  set d=day(MiladiTarih);
  set m=month(MiladiTarih);
  set y=year(MiladiTarih);
  if ((y>1582) or((y=1582) and (m>10)) or ((y=1582) and (m=10) and (d>14))) then
    set jd=intpart((1461*(y+4800+intpart((m-14)/12)))/4)+intpart((367*(m-2-12*(intpart((m-14)/12))))/12)- intpart( (3* (intpart(  (y+4900+    intpart( (m-14)/12)     )/100)    )   ) /4)+d-32075;
  else
    set jd = 367*y-intpart((7*(y+5001+intpart((m-9)/7)))/4)+intpart((275*m)/9)+d+1729777;
  end if;
                    set l=jd-1948440+10632;
                    set n=intpart((l-1)/10631);
                    set l=l-10631*n+354;
                    set j=(intpart((10985-l)/5316))*(intpart((50*l)/17719))+(intpart(l/5670))*(intpart((43*l)/15238));
                    set l=l-(intpart((30-j)/15))*(intpart((17719*j)/50))-(intpart(j/16))*(intpart((15238*j)/43))+29;
                    set m=intpart((24*l)/709);
                    set d=l-intpart((709*m)/24);
                    set y=30*n+j-30;
return concat(y,'-',m,'-',d);
END $$

DELIMITER ;


DELIMITER $$

DROP FUNCTION IF EXISTS `hijritogeorgian` $$
CREATE FUNCTION `hijritogeorgian` (HicriTarih date) RETURNS date
BEGIN
  declare d,m,y,jd,l,n,j,i,k int;
  set d=day(HicriTarih);
    set m=month(HicriTarih);
    set y=year(HicriTarih);
    set jd=intPart((11*y+3)/30)+354*y+30*m-intPart((m-1)/2)+d+1948440-385;
  if (jd> 2299160 ) then
        set l=jd+68569;
        set n=intPart((4*l)/146097);
    set l=l-intPart((146097*n+3)/4);
        set i=intPart((4000*(l+1))/1461001);
    set l=l-intPart((1461*i)/4)+31;
    set j=intPart((80*l)/2447);
    set d=l-intPart((2447*j)/80);
        set l=intPart(j/11);
        set m=j+2-12*l;
        set y=100*(n-49)+i+l;
  else
    set j=jd+1402;
    set k=intPart((j-1)/1461);
    set l=j-1461*k;
    set n=intPart((l-1)/365)-intPart(l/1461);
    set i=l-365*n+30;
        set j=intPart((80*i)/2447);
        set d=i-intPart((2447*j)/80);
        set i=intPart(j/11);
        set m=j+2-12*i;
        set y=4*k+n+i-4716;
  end if;
  return concat(y,'-',m,'-',d);
END $$

DELIMITER ;
