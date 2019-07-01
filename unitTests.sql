use filmPerformanceDB;

SET NOCOUNT ON;  -- SET NOCOUNT HERE to avoid msg when delete from temps

DECLARE @fails INT;
SET @fails=0;

DECLARE @passes INT;
SET @passes=0;

PRINT '---------------------------------------------------------------'
PRINT 'Running 100 Unit Tests'

-- -------------------------------------------------------------------
-- Test number:     1
-- Procedure Name:  insertFilm
-- -------------------------------------------------------------------
EXECUTE insertFilm 'La Dolce Vita', 'Drama', '03:12:22', 'Mastroianni', 'Marcello',
                   'Aimee', 'Anouk', 'Fellini', 'Federico';
EXECUTE insertFilm 'Una Journata Particolare', 'Drama', '02:45:00', 'Mastroianni',
                   'Marcello', 'Loren', 'Sophia', 'Scola', 'Ettore';
EXECUTE insertFilm 'La Vie est Belle', 'Drama', '02:32:32', 'Benigni', 'Roberto', 
                   'Braschi', 'Nicoletta', 'Benigni', 'Roberto';
EXECUTE insertFilm 'La Haine', 'Drama', '02:15:12', 'Cassel', 'Vincent', 'Rauth', 
                   'Heloise', 'Kassovitz', 'Mathieu';
EXECUTE insertFilm 'La Belle et La Bete', 'Romance', '01:54:22', 'Marais', 'Jean', 
                   'Day', 'Josette', 'Cocteau', 'Jean';
EXECUTE insertFilm 'Heat', 'Police Drama', '03:02:11', 'Pacino', 'Al', 'Venora', 
                   'Diane', 'Mann', 'Michael';
EXECUTE insertFilm 'From Russia with Love', 'Drama', '2:34:11', 'Connery', 'Sean', 
                   'Lenya', 'Lotte', 'Young', 'Terence';
EXECUTE insertFilm 'Educating Rita', 'Comedy', '02:55:00', 'Caine', 'Michael', 
                   'Walters', 'Julie', 'Gilbert', 'Lewis';
EXECUTE insertFilm 'His Girl Friday', 'Comedy', '01:34:11', 'Grant', 'Cary',
                   'Russell', 'Rosalind', 'Hawks', 'Howard';
EXECUTE insertFilm 'L Eclisse', 'Comedy', '03:44:22', 'Delon', 'Alain', 'Vitti', 
                   'Monica', 'Antonioni', 'Michaelangelo';
EXECUTE insertFilm 'Lovely Donuts', 'Comedy', '02:12:26', 'Keaton', 'Bobby', 'Gish', 
                   'Cheryl', 'Hitchcock', 'John';
EXECUTE insertFilm 'adsfghdsad', 'dsadadad', '02:12:26', 'qwqweq', 'qwewqe', 'qweqwew', 
                   'qeqe', 'qeqwe', 'qweqwe';

if ((SELECT COUNT(FILM_ID) FROM filmsTBL )=12) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 1';
	  SET @fails = @fails + 1
  END


-- -------------------------------------------------------------------
-- Test number:     2
-- Procedure Name:  insertCustomer
-- -------------------------------------------------------------------
EXECUTE insertCustomer 'Randolph', 'Scott', '13 Pleasant Street', 'Liverpool', 
                       'L19 0NE', 'randyscott@gmail.com', '0151345987';
EXECUTE insertCustomer 'Judy', 'Garland', '22 Harlington Cresent', 'Liverpool', 
                       'L24 2ED', 'jgarland@gmail.com', '01514448383';
EXECUTE insertCustomer 'Romeo', 'Echowhisky', '16b Tarwood Terrace', 'Liverpool', 
                       'L1 2LF', 'recho@yahoo.com', '089414567854';
EXECUTE insertCustomer 'Sally', 'Biggins', '22 Plikington Place', 'Liverpool',
                       'L22 4ES', 'sbiggins@gmail.com', '08982241161';
EXECUTE insertCustomer 'James', 'Garner', '94 Bold Street', 'Liverpool', 
                       'L14 3DD', 'jgarner123@gmail.com', '01517775656';
EXECUTE insertCustomer 'Christopher', 'Scott', '6 Alexandra Mews', 'Liverpool', 
                       'L9 0ND', 'chrissyscott@gmail.com', '015109987784';
EXECUTE insertCustomer 'Percival', 'Morrisson', '21 Everly Close', 'Liverpool', 
                       'L11 4FQ', 'pmoggyio@gmail.com', '08982215663';
EXECUTE insertCustomer 'Gigi', 'Delacourt', '96 Evergreen Terrace', 'Liverpool', 
                       'L22 6TR', 'gggirlie@gmail.com', '01515556343';
EXECUTE insertCustomer 'Lloyd', 'Ferdinand', '124 Mainbridge Street', 'Liverpool', 
                       'L2 4FD', 'ferdielar@gmail.com', '08942278876';
EXECUTE insertCustomer 'Mark', 'Chapman', '12 Leepworth Hill', 'Liverpool', 
                       'L16 2WW', 'chappio@gmail.com' , '01518989777';
EXECUTE insertCustomer 'Paul', 'Henderson', '65 Impressa Grove', 'Liverpool',
                       'L2 4EE', 'hennyla@gmail.com', '08983267769';
EXECUTE insertCustomer 'Ffff', 'Pwwww', 'uug', 'ewe', 'wwwwwwww', 'wwwwwww', 'werrw';

if ((SELECT COUNT(CUSTOMER_ID) FROM customersTBL )=12) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 2';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     3
-- Procedure Name:  insertScreen
-- -------------------------------------------------------------------
EXECUTE insertScreen 50,0,1;
EXECUTE insertScreen 150,1,1;
EXECUTE insertScreen 100,1,1;
EXECUTE insertScreen 150,0,0;
EXECUTE insertScreen 250,1,0;
EXECUTE insertScreen 200,0,0;
EXECUTE insertScreen 100,1,1;

if ((SELECT COUNT(SCREEN_NO) FROM screenTBL )=7) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 3';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:   4
-- Procedure Name:  insertPerformance
-- -------------------------------------------------------------------
EXECUTE insertPerformance 1,1,'2018-08-21','20:00:00',12.99,0;
EXECUTE insertPerformance 2,1,'2018-08-22','12:00:00',12.99,0;
EXECUTE insertPerformance 3,1,'2018-08-22','16:00:00',12.99,0;
EXECUTE insertPerformance 4,1,'2018-08-22','20:00:00',12.99,0;
EXECUTE insertPerformance 5,2,'2018-08-22','16:00:00',12.99,0;
EXECUTE insertPerformance 6,2,'2018-08-22','20:00:00',12.99,1;
EXECUTE insertPerformance 7,3,'2018-08-22','20:30:00',12.99,0;
EXECUTE insertPerformance 8,1,'2018-08-23','16:00:00',12.99,1;
EXECUTE insertPerformance 9,1,'2018-08-23','20:00:00',12.99,0;
EXECUTE insertPerformance 10,2,'2018-08-23','16:00:00',12.99,0;
EXECUTE insertPerformance 11,2,'2018-08-23','20:22:00',12.99,0;

if ((SELECT COUNT(PERFORMANCE_ID) FROM performanceTBL )=11) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 4';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     5
-- Procedure Name:  insertBooking
-- -------------------------------------------------------------------
EXECUTE insertBooking 1,2,2;
EXECUTE insertBooking 2,3,1;
EXECUTE insertBooking 3,3,1;
EXECUTE insertBooking 4,3,2;
EXECUTE insertBooking 5,4,2;
EXECUTE insertBooking 6,6,1;
EXECUTE insertBooking 7,6,2;
EXECUTE insertBooking 8,7,4;
EXECUTE insertBooking 9,2,2;
EXECUTE insertBooking 10,7,1;
EXECUTE insertBooking 11,8,2;

if ((SELECT COUNT(BOOKING_ID) FROM bookingsTBL )=11) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 5';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     6
-- Procedure Name:  deleteFilm
-- -------------------------------------------------------------------
EXECUTE deleteFilm 12;

if ((SELECT COUNT(*)
     FROM (SELECT * FROM filmsTBL WHERE FILM_ID=12) subquery)=0 
   ) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 6';
	  SET @fails = @fails + 1
  END

 -- -------------------------------------------------------------------
-- Test number:     7
-- Procedure Name:  deleteCustomer
-- -------------------------------------------------------------------
EXECUTE deleteCustomer 12;

if ((SELECT COUNT(*)
     FROM (SELECT * FROM customersTBL WHERE CUSTOMER_ID=12) subquery)=0 
   ) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 7';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     8
-- Procedure Name:  deleteBooking
-- -------------------------------------------------------------------
EXECUTE deleteBooking 1;

if ((SELECT COUNT(*)
     FROM (SELECT * FROM bookingsTBL WHERE BOOKING_ID=1) subquery)=0 
   ) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 8';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     9
-- Procedure Name:  deletePerformance
-- -------------------------------------------------------------------
EXECUTE deletePerformance 1;

if ((SELECT COUNT(*)
     FROM (SELECT * FROM performanceTBL WHERE PERFORMANCE_ID=1) subquery)=0 
   ) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 9';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     10
-- Procedure Name:  updateFilm
-- -------------------------------------------------------------------
EXECUTE updateFilm 2, 'Una Journata Particolare', 'Drama', '03:15:00', 'Mastroianni', 
                      'Marcello', 'Loren', 'Sophia', 'Scola', 'Ettore';

DECLARE @res10 TIME;
DECLARE @res10a TIME
SET @res10 = '03:15:00';
SET @res10a =
    (SELECT DURATION FROM filmsTBL
     WHERE FILM_ID=2);

if (@res10=@res10a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 10';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     11
-- Procedure Name:  updateCustomer
-- -------------------------------------------------------------------
EXECUTE updateCustomer 2, 'Judy', 'Garland', '22 Harlington Cresent', 'Liverpool', 
                       'L24 2ED', 'realjgarland@gmail.com', '01514448383';;

DECLARE @res11 VARCHAR(50);
DECLARE @res11a VARCHAR(50);
SET @res11 = 'realjgarland@gmail.com';
SET @res11a =
    (SELECT EMAIL FROM customersTBL
     WHERE CUSTOMER_ID=2);

if (@res11=@res11a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 11';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     12
-- Procedure Name:  updateBooking
-- -------------------------------------------------------------------
EXECUTE updateBooking 2,4,3,1;

DECLARE @res12 INT;
DECLARE @res12a INT;
SET @res12 = 4;
SET @res12a =
    (SELECT CUSTOMER_ID FROM bookingsTBL
     WHERE BOOKING_ID=2);

if (@res12=@res12a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 12';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     13
-- Procedure Name:  updatePerformance
-- -------------------------------------------------------------------
EXECUTE updatePerformance 2,2,1,'2018-08-25','12:00:00',12.99,0;

DECLARE @res13 DATE;
DECLARE @res13a DATE;
SET @res13 = '2018-08-25';
SET @res13a =
    (SELECT PERFORMANCE_DATE FROM performanceTBL
     WHERE PERFORMANCE_ID=2);

if (@res13=@res13a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 13';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     14
-- Procedure Name:  getFilmRecordByID
-- -------------------------------------------------------------------
DECLARE @res14 VARCHAR(100);
DECLARE @res14a VARCHAR(100);
SET @res14 = 'Una Journata Particolare';

-- Create a temporary table
Declare @TempFilm Table (
    FILM_ID int,
    TITLE VARCHAR(100) NOT NULL,
    GENRE VARCHAR(25),            
    DURATION TIME NOT NULL,
    ACTOR_SURNAME VARCHAR(35),
    ACTOR_FORENAME VARCHAR(35),
    ACTRESS_SURNAME VARCHAR(35),
    ACTRESS_FORENAME VARCHAR(35),
    DIRECTOR_SURNAME VARCHAR(35),
    DIRECTOR_FORENAME VARCHAR(35)
    )
-- Add result set to temporary table
Insert @TempFilm EXECUTE getFilmRecordByID 2;

SET @res14a = (Select TITLE from @TempFilm Where FILM_ID=2);
DELETE FROM @TempFilm; -- Clear @TempFilm table data
if (@res14=@res14a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 14';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     15
-- Procedure Name:  getBookingRecordByID
-- -------------------------------------------------------------------
DECLARE @res15 INT;
DECLARE @res15a INT;
SET @res15 = 4;

-- Create a temporary table
Declare @TempBookings Table (
    BOOKING_ID INT, 
    CUSTOMER_ID INT NOT NULL,
    PERFORMANCE_ID INT NOT NULL,
    NO_OF_TICKETS TINYINT NOT NULL
    )
-- Add result set to temporary table
Insert @TempBookings EXECUTE getBookingRecordByID 2;

SET @res15a = (Select CUSTOMER_ID from @TempBookings Where BOOKING_ID=2);
DELETE FROM @TempBookings;
if (@res15=@res15a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 15';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     16
-- Procedure Name:  getCustomerRecordByID
-- -------------------------------------------------------------------
DECLARE @res16 VARCHAR(50);
DECLARE @res16a VARCHAR(50);
SET @res16 = 'realjgarland@gmail.com';

-- Create a temporary table
Declare @TempCustomers Table (
    CUSTOMER_ID int,
    FIRSTNAME VARCHAR(35) NOT NULL,
    LASTNAME VARCHAR(35) NOT NULL,
    ADDRESSLINE1 VARCHAR(50),
    ADDRESSLINE2 VARCHAR(50),
    POSTCODE VARCHAR(10),
    EMAIL VARCHAR(50),
    PHONE_NO VARCHAR(15)
)

-- Add result set to temporary table
Insert @TempCustomers EXECUTE getCustomerRecordByID 2;

SET @res16a = (Select EMAIL from @TempCustomers Where CUSTOMER_ID=2);
DELETE FROM @TempCustomers;
if (@res16=@res16a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 16';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     17
-- Procedure Name:  getPerformanceRecordByID
-- -------------------------------------------------------------------
DECLARE @res17 INT;
DECLARE @res17a INT;
SET @res17 = 2;

-- Create a temporary table
Declare @TempPerformance Table (
    PERFORMANCE_ID int,
    FILM_ID INT NOT NULL,  
    SCREEN_NO INT NOT NULL,
    PERFORMANCE_DATE DATE,     
    START_TIME TIME,
    END_TIME TIME,
    PRICE MONEY,
    IN_3D BIT
)
-- Add result set to temporary table
Insert @TempPerformance EXECUTE getPerformanceRecordByID 2;

SET @res17a = (Select FILM_ID from @TempPerformance Where PERFORMANCE_ID=2);
DELETE FROM @TempPerformance;
if (@res17=@res17a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 17';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     18
-- Procedure Name:  getPerformanceDetailsByDateAndStartTime
-- -------------------------------------------------------------------
DECLARE @res18 VARCHAR(100);
DECLARE @res18a VARCHAR(100);
SET @res18 = 'Una Journata Particolare';

-- Create a temporary table
Declare @TempPDDST Table (
    TITLE VARCHAR(100) NOT NULL,
    GENRE VARCHAR(25),            
    SCREEN_NO INT NOT NULL,
    PERFORMANCE_DATE VARCHAR(20),     
    START_TIME TIME,
    END_TIME TIME,
    PRICE MONEY,
    IN_3D BIT
    )
-- Add result set to temporary table
Insert @TempPDDST EXECUTE getPerformanceDetailsByDateAndStartTime '2018-08-25','12:00:00','00:00:00';

SET @res18a = (Select TITLE from @TempPDDST WHERE START_TIME='12:00:00');
DELETE FROM @TempPDDST;
if (@res18=@res18a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 18';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     19
-- Procedure Name:  getPerformanceDetailsByDateAndStartTime
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDDST EXECUTE getPerformanceDetailsByDateAndStartTime '2018-08-22','20:00:00','00:30:00';

if (( SELECT COUNT(TITLE) FROM @TempPDDST)=3)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 19';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDDST;

-- -------------------------------------------------------------------
-- Test number:     20
-- Procedure Name:  getPerformanceDetailsByDateAndStartTime
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDDST EXECUTE getPerformanceDetailsByDateAndStartTime '2018-08-23','20:00:00','00:30:00';

if (( SELECT COUNT(TITLE) FROM @TempPDDST)=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 20';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDDST;

-- -------------------------------------------------------------------
-- Test number:     21
-- Procedure Name:  getPerformanceDetailsByDateAndStartTime
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDDST EXECUTE getPerformanceDetailsByDateAndStartTime '2018-08-23','20:00:00','00:30';

if (( SELECT COUNT(TITLE) FROM @TempPDDST)=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 21';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDDST;

-- -------------------------------------------------------------------
-- Test number:     22
-- Procedure Name:  getPerformanceDetailsByDateAndStartTime
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDDST EXECUTE getPerformanceDetailsByDateAndStartTime '2018-08-25','21:00:00','00:30:00';

if (( SELECT COUNT(TITLE) FROM @TempPDDST)=0)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 22';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDDST;

-- -------------------------------------------------------------------
-- Test number:     23
-- Procedure Name:  getPerformanceDetailsByFilmTitle
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDDST EXECUTE getPerformanceDetailsByFilmTitle 'Lovely Donuts';

if (( SELECT COUNT(TITLE) FROM @TempPDDST)=1)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 23';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDDST;

-- -------------------------------------------------------------------
-- Test number:     24
-- Procedure Name:  getAll3DPerformanceDetails;
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDDST EXECUTE getAll3DPerformanceDetails;

if (( SELECT COUNT(TITLE) FROM @TempPDDST)=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 24';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDDST;

-- -------------------------------------------------------------------
-- Test number:     25
-- Procedure Name:  get3DPerformanceDetailsByDateAndStartTime
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDDST EXECUTE get3DPerformanceDetailsByDateAndStartTime '2018-08-22','20:00:00','00:30:00';

if (( SELECT COUNT(TITLE) FROM @TempPDDST)=1)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 25';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDDST;

-- -------------------------------------------------------------------
-- Test number:     26
-- Procedure Name:  getFilmRecordsByDuration
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempFRD Table (
    TITLE VARCHAR(100) NOT NULL,
    GENRE VARCHAR(25),            
    DURATION VARCHAR(20)
    )
-- Add result set to temporary table
Insert @TempFRD EXECUTE getFilmRecordsByDuration '00:45','02:30';

if (( SELECT COUNT(TITLE) FROM @TempFRD)=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 26';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempFRD;

-- -------------------------------------------------------------------
-- Test number:     27
-- Procedure Name:  getFilmRecordsByGenre
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempFRD EXECUTE getFilmRecordsByGenre 'Comedy';

if (( SELECT COUNT(TITLE) FROM @TempFRD)=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 27';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempFRD;

-- -------------------------------------------------------------------
-- Test number:   28
-- Function Name: getAllFilmGenres
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempTitles Table (
    TITLE VARCHAR(100) NOT NULL
    )

Insert @TempTitles SELECT * FROM dbo.getAllFilmGenres();

if (( SELECT COUNT(TITLE) FROM @TempTitles)=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 28';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTitles;

-- -------------------------------------------------------------------
-- Test number:   29
-- Function Name: getAllFilmTitles
-- -------------------------------------------------------------------
Insert @TempTitles SELECT * FROM dbo.getAllFilmTitles();

if (( SELECT COUNT(TITLE) FROM @TempTitles)=11)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 29';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTitles;

-- -------------------------------------------------------------------
-- Test number:     30
-- Procedure Name:  getCustomerRecordsByEmail
-- -------------------------------------------------------------------
DECLARE @res30 INT;
DECLARE @res30a INT;
SET @res30 = 4;

-- Add result set to temporary table
Insert @TempCustomers EXECUTE getCustomerRecordsByEmail 'sbiggins@gmail.com';

SET @res30a = (Select CUSTOMER_ID from @TempCustomers Where EMAIL='sbiggins@gmail.com');
DELETE FROM @TempCustomers;
if (@res30=@res30a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 30';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     31
-- Procedure Name:  getCustomerRecordsByPostcode
-- -------------------------------------------------------------------
DECLARE @res31 INT;
DECLARE @res31a INT;
SET @res31 = 4;

-- Add result set to temporary table
Insert @TempCustomers EXECUTE getCustomerRecordsByPostcode 'L22 4ES';

SET @res31a = (Select CUSTOMER_ID from @TempCustomers Where POSTCODE='L22 4ES');
DELETE FROM @TempCustomers;
if (@res31=@res31a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 31';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     32
-- Procedure Name:  getBookingRecordsByCustomerID
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempBookings EXECUTE getBookingRecordsByCustomerID 7;

if (( SELECT COUNT(BOOKING_ID) FROM @TempBookings)=1)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 32';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempBookings;

-- -------------------------------------------------------------------
-- Test number:     33
-- Procedure Name:  getBookingRecordsForDate
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempBookings EXECUTE getBookingRecordsForDate '2018-08-23';

if (( SELECT COUNT(BOOKING_ID) FROM @TempBookings)=1)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 33';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempBookings;

-- -------------------------------------------------------------------
-- Test number:     34
-- Procedure Name:  getBookingRecordsByFilmID
-- -------------------------------------------------------------------
Insert @TempBookings EXECUTE getBookingRecordsByFilmID 3;

if (( SELECT COUNT(BOOKING_ID) FROM @TempBookings)=3)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 34';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempBookings;

-- -------------------------------------------------------------------
-- Test number:     35
-- Procedure Name:  getBookingRecordsByPerformanceID
-- -------------------------------------------------------------------
Insert @TempBookings EXECUTE getBookingRecordsByPerformanceID 7;

if (( SELECT COUNT(BOOKING_ID) FROM @TempBookings)=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 35';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempBookings;

-- -------------------------------------------------------------------
-- Test number:     36
-- Procedure Name:  getFilmIDsByTitle
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempFIBT Table (
    FILM_ID int,
    TITLE VARCHAR(100) NOT NULL
    )

Insert @TempFIBT EXECUTE getFilmIDsByTitle 'La';

if (( SELECT COUNT(FILM_ID) FROM @TempFIBT)=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 36';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     37
-- Procedure Name:  getTotalNoOfTicketsBookedByCustomerID
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByCustomerID(4))=3)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 37';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     38
-- Procedure Name:  getTotalNoOfTicketsBookedByPerformanceID
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByPerformanceID(3))=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 38';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     39
-- Procedure Name:  getTotalNoOfTicketsBookedByFilmID
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByFilmID(3))=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 39';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     40
-- Procedure Name:  getTotalNoOfTicketsBookedByGenre
-- -------------------------------------------------------------------
if ((dbo.getTotalNoOfTicketsBookedByGenre('Drama'))=13)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 40';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     41
-- Procedure Name:  getTotalNoOfTicketsBookedByFilmTitle
-- -------------------------------------------------------------------
if ((dbo.getTotalNoOfTicketsBookedByFilmTitle('Heat'))=3)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 41';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     42
-- Procedure Name:  getTotalNoOfTicketsBookedInPeriod
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedInPeriod('2018-08-21', '2018-08-23'))=16)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 42';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     43
-- Procedure Name:  getTotalNoOfTicketsBookedOnDate
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedOnDate('2018-08-22'))=14)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 43';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     44
-- Procedure Name:  getTotalNoOfTicketsBookedByScreenNo
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByScreenNo(2))=3)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 44';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     45
-- Procedure Name:  getTopNFilmBookingsOfAllTime
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempTopNFBAT Table (
    FILM_ID INT,
    TITLE VARCHAR(100) NOT NULL,
    GENRE VARCHAR(25),            
    DURATION VARCHAR(20),
	TOTAL_BOOKINGS INT
    )
-- Add result set to temporary table
Insert @TempTopNFBAT EXECUTE getTopNFilmBookingsOfAllTime 5;

if (( SELECT SUM(TOTAL_BOOKINGS) FROM @TempTopNFBAT)=16)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 45';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNFBAT;

-- -------------------------------------------------------------------
-- Test number:     46
-- Procedure Name:  getTopNBookingCustomersOfAllTime
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempTopNBCAT Table (
    CUSTOMER_ID int,
    FIRSTNAME VARCHAR(35) NOT NULL,
    LASTNAME VARCHAR(35) NOT NULL,
    EMAIL VARCHAR(50),
    POSTCODE VARCHAR(10),
	TOTAL_BOOKINGS INT
    )
-- Add result set to temporary table
Insert @TempTopNBCAT EXECUTE getTopNBookingCustomersOfAllTime 5;

if (( SELECT SUM(TOTAL_BOOKINGS) FROM @TempTopNBCAT)=13)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 46';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNBCAT;

-- -------------------------------------------------------------------
-- Test number:     47
-- Procedure Name:  getTopNGenreBookingsOfAllTime
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempTopGBAT Table (
    GENRE VARCHAR(25), 
	TOTAL_BOOKINGS INT
    )
-- Add result set to temporary table
Insert @TempTopGBAT EXECUTE getTopNGenreBookingsOfAllTime 5;

if (( SELECT SUM(TOTAL_BOOKINGS) FROM @TempTopGBAT)=18)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 47';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopGBAT;


-- -------------------------------------------------------------------
-- Test number:     48
-- Procedure Name:  getTopNScreenBookingsOfAllTime
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempTopNSBAT Table (
    SCREEN_NO INT, 
	TOTAL_BOOKINGS INT
    )
-- Add result set to temporary table
Insert @TempTopNSBAT EXECUTE getTopNScreenBookingsOfAllTime 5;
 
if ((SELECT TOTAL_BOOKINGS FROM @TempTopNSBAT WHERE SCREEN_NO=1)=10)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 48';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNSBAT;

-- -------------------------------------------------------------------
-- Test number:     49
-- Procedure Name:  getTotalNoOfTicketsBookedByCustomerIDDuringPeriod
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByCustomerIDDuringPeriod(4, '2018-08-21', '2018-08-23'))=3)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 49';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     50
-- Procedure Name:  getTotalNoOfTicketsBookedByFilmIDDuringPeriod
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByFilmIDDuringPeriod(7, '2018-08-21', '2018-08-23'))=5)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 50';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     51
-- Procedure Name:  getTotalNoOfTicketsBookedByGenreDuringPeriod
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByGenreDuringPeriod('Comedy', '2018-08-21', '2018-08-23'))=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 51';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     52
-- Procedure Name:  getTotalNoOfTicketsBookedByScreenNoDuringPeriod
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByScreenNoDuringPeriod(3, '2018-08-21', '2018-08-23'))=5)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 52';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     53
-- Procedure Name:  getTopNFilmBookingsDuringPeriod
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopNFBAT EXECUTE getTopNFilmBookingsDuringPeriod 5, '2018-08-21', '2018-08-23';

if ((SELECT TOTAL_BOOKINGS FROM @TempTopNFBAT WHERE FILM_ID=7)=5)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 53';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNFBAT;

-- -------------------------------------------------------------------
-- Test number:     54
-- Procedure Name:  getTopNBookingCustomersDuringPeriod
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopNBCAT EXECUTE getTopNBookingCustomersDuringPeriod 5, '2018-08-21', '2018-08-23';

if ((SELECT TOTAL_BOOKINGS FROM @TempTopNBCAT WHERE CUSTOMER_ID=8)=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 54';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNBCAT;

-- -------------------------------------------------------------------
-- Test number:     55
-- Procedure Name:  getTopNGenreBookingsDuringPeriod 
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopGBAT EXECUTE getTopNGenreBookingsDuringPeriod 5, '2018-08-21', '2018-08-23';


if ((SELECT TOTAL_BOOKINGS FROM @TempTopGBAT WHERE GENRE LIKE 'Drama')=11)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 55';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopGBAT;

-- -------------------------------------------------------------------
-- Test number:     56
-- Procedure Name:  getTopNScreenBookingsDuringPeriod
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopNSBAT EXECUTE getTopNScreenBookingsDuringPeriod 5, '2018-08-21', '2018-08-23';
 
if ((SELECT TOTAL_BOOKINGS FROM @TempTopNSBAT WHERE SCREEN_NO=1)=8)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 56';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNSBAT;

-- -------------------------------------------------------------------
-- Test number:   57
-- Function Name: getAllFilmIDs
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempAllIDs Table (
    ID INT
    )

-- Add result set to temporary table
Insert @TempAllIDs SELECT * FROM dbo.getAllFilmIDs();

if ((SELECT COUNT(ID) FROM @TempAllIDs)=11)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 57';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempAllIDs;

-- -------------------------------------------------------------------
-- Test number:   58
-- Function Name: getAllBookingIDs
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempAllIDs SELECT * FROM dbo.getAllBookingIDs();

if ((SELECT COUNT(ID) FROM @TempAllIDs)=10)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 58';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempAllIDs;

-- -------------------------------------------------------------------
-- Test number:   59
-- Function Name: getAllCustomerIDs
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempAllIDs SELECT * FROM dbo.getAllCustomerIDs();

if ((SELECT COUNT(ID) FROM @TempAllIDs)=11)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 59';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempAllIDs;

-- -------------------------------------------------------------------
-- Test number:   60
-- Function Name: getAllPerformanceIDs
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempAllIDs SELECT * FROM dbo.getAllPerformanceIDs();
--SELECT COUNT(ID) FROM @TempAllIDs
if ((SELECT COUNT(ID) FROM @TempAllIDs)=10)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 60';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempAllIDs;

-- -------------------------------------------------------------------
-- Test number:   61
-- Function Name: getAll3DPerformanceIDs
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempAllIDs SELECT * FROM dbo.getAll3DPerformanceIDs();
--SELECT COUNT(ID) FROM @TempAllIDs
if ((SELECT COUNT(ID) FROM @TempAllIDs)=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 61';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempAllIDs;

-- -------------------------------------------------------------------
-- Test number:     62
-- Procedure Name:  getCustomersWithNoBookings
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempCNB Table (
    CUSTOMER_ID int,
    FIRSTNAME VARCHAR(35) NOT NULL,
    LASTNAME VARCHAR(35) NOT NULL,
    EMAIL VARCHAR(50),
    POSTCODE VARCHAR(10)
    )
-- Add result set to temporary table
Insert @TempCNB EXECUTE getCustomersWithNoBookings;

if (( SELECT COUNT(CUSTOMER_ID) FROM @TempCNB)=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 62';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempCNB;

-- -------------------------------------------------------------------
-- Test number:     63
-- Procedure Name:  getCustomersWithNoBookingsDuringPeriod
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempCNB EXECUTE getCustomersWithNoBookingsDuringPeriod '2018-08-21','2018-08-22';

if (( SELECT COUNT(CUSTOMER_ID) FROM @TempCNB)=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 63';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempCNB;

-- -------------------------------------------------------------------
-- Test number:     64
-- Procedure Name:  getTotalNoOfTicketsBooked
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBooked())=18)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 64';
	  SET @fails = @fails + 1
  END

-- ----------------------------------------------------  
-- Insert performance and booking records for yesterday
-- ----------------------------------------------------
DECLARE @todaysDate DATETIME
DECLARE @yesterdaysDate DATETIME

SET @todaysDate = cast(cast(getdate() as date ) as datetime)

-- Get the start of yesterday by adding -1 day to today
SET @yesterdaysDate = DATEADD(DAY, -1, @todaysDate) 

-- @FILM_ID, @SCREEN_NO, @PERFORMANCE_DATE, @START_TIME, @PRICE
EXECUTE insertPerformance 5,2,@yesterdaysDate,'12:00:00',12.99,0;
EXECUTE insertPerformance 2,2,@yesterdaysDate,'16:00:00',12.99,1;
EXECUTE insertPerformance 7,1,@yesterdaysDate,'20:00:00',12.99,0;

-- @CUSTOMER_ID, @PERFORMANCE_ID, @NO_OF_TICKETS
EXECUTE insertBooking 1,13,2;
EXECUTE insertBooking 4,13,5;
EXECUTE insertBooking 1,12,1;
EXECUTE insertBooking 4,14,7;
EXECUTE insertBooking 1,12,3;
EXECUTE insertBooking 4,12,2;

-- -------------------------------------------------------------------
-- Test number:     65
-- Procedure Name:  getTotalNoOfTicketsBookedDuringPreviousWeek
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedDuringPreviousWeek())=20)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 65';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     66
-- Procedure Name:  getTotalNoOfTicketsBookedByCustomerDuringPreviousWeek
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByCustomerDuringPreviousWeek(4))=14)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 66';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     67
-- Procedure Name:  getTotalNoOfTicketsBookedByFilmIDDuringPreviousWeek
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByFilmIDDuringPreviousWeek(5))=6)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 67';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     68
-- Procedure Name:  getTotalNoOfTicketsBookedByGenreDuringPreviousWeek
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByGenreDuringPreviousWeek('Romance'))=6)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 68';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     69
-- Procedure Name:  getTotalNoOfTicketsBookedByScreenNoDuringPreviousWeek
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByScreenNoDuringPreviousWeek(2))=13)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 69';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     70
-- Procedure Name:  getTopNFilmBookingsDuringPreviousWeek
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopNFBAT EXECUTE getTopNFilmBookingsDuringPreviousWeek 5;

if ((SELECT TOTAL_BOOKINGS FROM @TempTopNFBAT WHERE FILM_ID=7)=7)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 70';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNFBAT;

-- -------------------------------------------------------------------
-- Test number:     71
-- Procedure Name:  getTopNBookingCustomersDuringPreviousWeek
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopNBCAT EXECUTE getTopNBookingCustomersDuringPreviousWeek 5;

if ((SELECT TOTAL_BOOKINGS FROM @TempTopNBCAT WHERE CUSTOMER_ID=4)=14)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 71';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNBCAT;

-- -------------------------------------------------------------------
-- Test number:     72
-- Procedure Name:  getTopNGenreBookingsDuringPreviousWeek
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopGBAT EXECUTE getTopNGenreBookingsDuringPreviousWeek 5;

if ((SELECT TOTAL_BOOKINGS FROM @TempTopGBAT WHERE GENRE LIKE 'Drama')=14)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 72';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopGBAT;

-- -------------------------------------------------------------------
-- Test number:     73
-- Procedure Name:  getTopNScreenBookingsDuringPreviousWeek
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopNSBAT EXECUTE getTopNScreenBookingsDuringPreviousWeek 5;

if ((SELECT TOTAL_BOOKINGS FROM @TempTopNSBAT WHERE SCREEN_NO=2)=13)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 73';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNSBAT;

-- -------------------------------------------------------------------
-- Test number:     74
-- Procedure Name:  getPerformanceDetailsForDate
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempPDFD Table (
    TITLE VARCHAR(100) NOT NULL,
    GENRE VARCHAR(25),    
    SCREEN_NO INT NOT NULL,
    PERFORMANCE_DATE VARCHAR(20),     
    START_TIME TIME,
    END_TIME TIME,
    PRICE MONEY,
    IN_3D BIT
)

-- Add result set to temporary table
Insert @TempPDFD EXECUTE getPerformanceDetailsForDate '2018-08-22';

if ((SELECT COUNT(TITLE) FROM @TempPDFD)=5)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 74';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDFD;

-- -------------------------------------------------------------------
-- Test number:     75
-- Procedure Name:  getBookingRecordsForPeriod
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempBookings EXECUTE getBookingRecordsForPeriod '2018-08-23','2018-08-25';

if ((SELECT COUNT(BOOKING_ID) FROM @TempBookings)=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 75';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempBookings;

-- ------------------------------------------------  
-- Insert performance and booking records for today
-- ------------------------------------------------
-- @FILM_ID, @SCREEN_NO, @PERFORMANCE_DATE, @START_TIME, @PRICE
EXECUTE insertPerformance 3,1,@todaysDate,'12:00:00',12.99,0;
EXECUTE insertPerformance 4,3,@todaysDate,'16:00:00',12.99,1;
EXECUTE insertPerformance 4,3,@todaysDate,'20:00:00',12.99,0;

-- @CUSTOMER_ID, @PERFORMANCE_ID, @NO_OF_TICKETS
EXECUTE insertBooking 2,15,2;
EXECUTE insertBooking 3,15,1;
EXECUTE insertBooking 1,15,1;
EXECUTE insertBooking 2,16,3;
EXECUTE insertBooking 1,16,2;
EXECUTE insertBooking 6,17,2;

-- -------------------------------------------------------------------
-- Test number:     76
-- Procedure Name:  getBookingRecordsForToday
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempBookings EXECUTE getBookingRecordsForToday;

if (( SELECT COUNT(BOOKING_ID) FROM @TempBookings)=6)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 76';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempBookings;

-- -------------------------------------------------------------------
-- Test number:     77
-- Procedure Name:  getPerformanceDetailsForToday
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDFD EXECUTE getPerformanceDetailsForToday;

if ((SELECT COUNT(TITLE) FROM @TempPDFD)=3)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 77';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDFD;

-- ----------------------------------------------------  
-- Insert performance and booking records for yesterday
-- ----------------------------------------------------
DECLARE @tomorrowsDate DATETIME

SET @tomorrowsDate = cast(DATEADD(DAY, 1, @todaysDate) as datetime) 

-- @FILM_ID, @SCREEN_NO, @PERFORMANCE_DATE, @START_TIME, @PRICE
EXECUTE insertPerformance 1,1,@tomorrowsDate,'20:00:00',12.99,0;
EXECUTE insertPerformance 2,1,@tomorrowsDate,'12:00:00',12.99,0;
EXECUTE insertPerformance 5,2,@tomorrowsDate,'16:00:00',12.99,0;
EXECUTE insertPerformance 7,3,@tomorrowsDate,'20:30:00',12.99,0;
EXECUTE insertPerformance 3,2,@tomorrowsDate,'20:00:00',12.99,0;
EXECUTE insertPerformance 6,1,@tomorrowsDate,'16:00:00',12.99,0;

-- @CUSTOMER_ID, @PERFORMANCE_ID, @NO_OF_TICKETS
EXECUTE insertBooking 1,18,3;
EXECUTE insertBooking 3,18,2;
EXECUTE insertBooking 5,19,5;
EXECUTE insertBooking 4,19,3;
EXECUTE insertBooking 1,21,2;
EXECUTE insertBooking 6,22,2;

-- -------------------------------------------------------------------
-- Test number:     78
-- Procedure Name:  getBookingRecordsForTomorrow
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempBookings EXECUTE getBookingRecordsForTomorrow;

if (( SELECT COUNT(BOOKING_ID) FROM @TempBookings)=6)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 78';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempBookings;

-- -------------------------------------------------------------------
-- Test number:     79
-- Procedure Name:  getPerformanceDetailsForTomorrow
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempPDFD EXECUTE getPerformanceDetailsForTomorrow;

if ((SELECT COUNT(TITLE) FROM @TempPDFD)=6)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 79';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempPDFD;

-- -------------------------------------------------------------------
-- Test number:     80
-- Procedure Name:  getCustomerRecordsByPhoneNo
-- -------------------------------------------------------------------
DECLARE @res80 INT;
DECLARE @res80a INT;
SET @res80 = 2;

-- Add result set to temporary table
Insert @TempCustomers EXECUTE getCustomerRecordsByPhoneNo '01514448383';

SET @res80a = (Select CUSTOMER_ID from @TempCustomers Where PHONE_NO='01514448383');
DELETE FROM @TempCustomers;
if (@res80=@res80a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 80';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     81
-- Procedure Name:  getFilmRecordsByDirectorSurname
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempFRBDS Table (
    SURNAME VARCHAR(35),
    FORENAME VARCHAR(35),
    TITLE VARCHAR(100) NOT NULL,
    GENRE VARCHAR(25),            
    DURATION VARCHAR(20)
    )

-- Add result set to temporary table
Insert @TempFRBDS EXECUTE getFilmRecordsByDirectorSurname 'Hitchcock';

if ((SELECT COUNT(TITLE) FROM @TempFRBDS)=1)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 81';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempFRBDS;

-- -------------------------------------------------------------------
-- Test number:     82
-- Procedure Name:  getFilmRecordsByActorSurname
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempFRBDS EXECUTE getFilmRecordsByActorSurname 'Mastroianni';

if ((SELECT COUNT(TITLE) FROM @TempFRBDS)=2)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 82';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempFRBDS;

-- -------------------------------------------------------------------
-- Test number:     83
-- Procedure Name:  getFilmRecordsByActressSurname
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempFRBDS EXECUTE getFilmRecordsByActressSurname 'Loren';

if ((SELECT COUNT(TITLE) FROM @TempFRBDS)=1)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 83';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempFRBDS; 

-- -------------------------------------------------------------------
-- Test number:     84
-- Procedure Name:  getAllActorNames
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempGAAN Table (
    SURNAME VARCHAR(35),
    FORENAME VARCHAR(35)
    )

-- Add result set to temporary table
Insert @TempGAAN SELECT * FROM dbo.getAllActorNames();

if ((SELECT COUNT(SURNAME) FROM @TempGAAN)=10)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 84';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempGAAN; 

-- -------------------------------------------------------------------
-- Test number:     85
-- Procedure Name:  getAllActressNames
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempGAAN SELECT * FROM dbo.getAllActressNames();

if ((SELECT COUNT(SURNAME) FROM @TempGAAN)=11)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 85';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempGAAN; 

-- -------------------------------------------------------------------
-- Test number:     86
-- Procedure Name:  getAllDirectorNames
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempGAAN SELECT * FROM dbo.getAllDirectorNames();

if ((SELECT COUNT(SURNAME) FROM @TempGAAN)=11)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 86';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempGAAN; 

-- -------------------------------------------------------------------
-- Test number:     87
-- Procedure Name:  getTotalNoOfTicketsBookedByActorName
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByActorName('Marcello','Mastroianni'))=22)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 87';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     88
-- Procedure Name:  getTotalNoOfTicketsBookedByActressName
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByActressName('Anouk','Aimee'))=5)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 88';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     89
-- Procedure Name:  getTotalNoOfTicketsBookedByDirectorName
-- -------------------------------------------------------------------
if ((SELECT dbo.getTotalNoOfTicketsBookedByDirectorName('Federico','Fellini'))=5)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 89';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     90
-- Procedure Name:  getTopNDirectorBookingsOfAllTime
-- -------------------------------------------------------------------
-- Create a temporary table
Declare @TempTopNDBAT Table (
    SURNAME VARCHAR(35),
    FORENAME VARCHAR(35),
	TOTAL_BOOKINGS INT
    )

-- Add result set to temporary table
Insert @TempTopNDBAT EXECUTE getTopNDirectorBookingsOfAllTime 5;

if (( SELECT SUM(TOTAL_BOOKINGS) FROM @TempTopNDBAT)=56)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 90';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNDBAT; 

-- -------------------------------------------------------------------
-- Test number:     91
-- Procedure Name:  getTopNActorBookingsOfAllTime
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopNDBAT EXECUTE getTopNActorBookingsOfAllTime 5;

if (( SELECT SUM(TOTAL_BOOKINGS) FROM @TempTopNDBAT)=61)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 91';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNDBAT; 

-- -------------------------------------------------------------------
-- Test number:     92
-- Procedure Name:  getTopNActressBookingsOfAllTime
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempTopNDBAT EXECUTE getTopNActressBookingsOfAllTime 5;

if (( SELECT SUM(TOTAL_BOOKINGS) FROM @TempTopNDBAT)=56)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 92';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempTopNDBAT; 

-- -------------------------------------------------------------------
-- Test number:     93
-- Procedure Name:  updateScreen
-- -------------------------------------------------------------------
EXECUTE updateScreen 1, 200, 0, 1;

DECLARE @res93 SMALLINT;
DECLARE @res93a SMALLINT
SET @res93 = 200;
SET @res93a = (SELECT CAPACITY FROM screenTBL WHERE SCREEN_NO=1);

if (@res93=@res93a) 
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 93';
	  SET @fails = @fails + 1
  END

-- -------------------------------------------------------------------
-- Test number:     94
-- Procedure Name:  deleteScreen
-- -------------------------------------------------------------------
EXECUTE deleteScreen 3;

-- Add result set to temporary table
Insert @TempAllIDs SELECT SCREEN_NO from screenTBL;

if ((SELECT COUNT(ID) FROM @TempAllIDs)=7)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 94';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempAllIDs; 

-- -------------------------------------------------------------------
-- Test number:     95
-- Procedure Name:  getAllScreenNumbers
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempAllIDs SELECT * FROM dbo.getAllScreenNumbers();

if ((SELECT COUNT(ID) FROM @TempAllIDs)=7)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 95';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempAllIDs; 

-- -------------------------------------------------------------------
-- Test number:     96
-- Procedure Name:  getAllScreenDetails
-- -------------------------------------------------------------------
Declare @TempScreen Table (
    SCREEN_NO int,
    CAPACITY SMALLINT,
    HAS_DISABLED_ACCESS BIT,
    HAS_HEARING_LOOP BIT
);

-- Add result set to temporary table
Insert @TempScreen EXECUTE getAllScreenDetails;

if ((SELECT COUNT(SCREEN_NO) FROM @TempScreen)=7)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 96';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempScreen; 

-- -------------------------------------------------------------------
-- Test number:     97
-- Procedure Name:  getScreenDetailsByMinimumCapacity
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempScreen EXECUTE getScreenDetailsByMinimumCapacity 200;

if ((SELECT COUNT(SCREEN_NO) FROM @TempScreen)=3)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 97';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempScreen; 

-- -------------------------------------------------------------------
-- Test number:     98
-- Procedure Name:  getScreenDetailsByScreenNumber
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempScreen EXECUTE getScreenDetailsByScreenNumber 2;

if ((SELECT CAPACITY FROM @TempScreen WHERE SCREEN_NO=2)=150)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 98';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempScreen; 

-- -------------------------------------------------------------------
-- Test number:     99
-- Procedure Name:  getScreensWithDisabledAccess
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempScreen EXECUTE getScreensWithDisabledAccess;

if ((SELECT COUNT(SCREEN_NO) FROM @TempScreen)=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 99';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempScreen; 

-- -------------------------------------------------------------------
-- Test number:     100
-- Procedure Name:  getScreensWithHearingLoop
-- -------------------------------------------------------------------
-- Add result set to temporary table
Insert @TempScreen EXECUTE getScreensWithHearingLoop;

if ((SELECT COUNT(SCREEN_NO) FROM @TempScreen)=4)
  BEGIN
	  SET @passes = @passes + 1
  END
else
  BEGIN
      Print 'Fail test 100';
	  SET @fails = @fails + 1
  END

DELETE FROM @TempScreen; 

-- -------------------------------------------------------------------
--                          END OF UNIT TESTS
-- -------------------------------------------------------------------
PRINT '---------------------------------------------------------------'
PRINT 'Tests passed = ' + CAST(@passes AS VARCHAR)
PRINT 'Tests failed = ' + CAST(@fails AS VARCHAR)

