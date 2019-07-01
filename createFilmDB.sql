-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- File Name:    createFilmDB.sql
-- Author:       Andrew Laing
-- Last updated: 03/01/2019
-- Description:  This file creates the filmPerformanceDB database and its
--               associated tables, constraints, procedures and functions
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- @@@@@@@@@@@@@@@@@@@@@@@
-- @ CREATE THE DATABASE @
-- @@@@@@@@@@@@@@@@@@@@@@@

PRINT 'Create the filmPerformanceDB database.'

GO
-- Make sure that the database does not already exist before creating it.
IF DB_ID('filmPerformanceDB') IS NOT NULL
BEGIN
  PRINT ''
  PRINT 'The filmPerformanceDB Database already exists!'
  PRINT 'Exiting the installation script!'
  SET NOEXEC ON   -- stop the rest of the script from executing
END
ELSE
BEGIN
  CREATE DATABASE filmPerformanceDB;
END
GO


use filmPerformanceDB;

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- @@@@@@@@@@@@@@@@@@@@@
-- @ CREATE THE TABLES @
-- @@@@@@@@@@@@@@@@@@@@@

PRINT 'Create the tables.'

-- Create the filmsTBL TABLE 
-- Make sure that the table does not already exist before creating it.
IF OBJECT_ID('filmsTBL' ,'U') IS NOT NULL
DROP TABLE filmsTBL;
GO
CREATE TABLE filmsTBL (
    FILM_ID int IDENTITY(1,1) PRIMARY KEY,  -- This is the primary key for the table. The value is
                                            -- an automatically assigned number. Starts at 1 and increments by 1.
    TITLE VARCHAR(100) NOT NULL,            -- NOT NULL indicates that this is a required field.
    GENRE VARCHAR(25),            
    DURATION TIME NOT NULL,                 -- Stored in the time format hh:mm:ss
    ACTOR_SURNAME VARCHAR(35),
    ACTOR_FORENAME VARCHAR(35),
    ACTRESS_SURNAME VARCHAR(35),
    ACTRESS_FORENAME VARCHAR(35),
    DIRECTOR_SURNAME VARCHAR(35),
    DIRECTOR_FORENAME VARCHAR(35)
    );
GO

-- Create the customersTBL TABLE 
IF OBJECT_ID('customersTBL' ,'U') IS NOT NULL
DROP TABLE customersTBL;
GO
CREATE TABLE customersTBL (
    CUSTOMER_ID int IDENTITY(1,1) PRIMARY KEY,
    FIRSTNAME VARCHAR(35) NOT NULL,
    LASTNAME VARCHAR(35) NOT NULL,
    ADDRESSLINE1 VARCHAR(50),
    ADDRESSLINE2 VARCHAR(50),
    POSTCODE VARCHAR(10),
    EMAIL VARCHAR(50),
    PHONE_NO VARCHAR(15)
);
GO

-- Create the screenTBL TABLE 
IF OBJECT_ID('screenTBL' ,'U') IS NOT NULL
DROP TABLE screenTBL;
GO
CREATE TABLE screenTBL (
    SCREEN_NO int IDENTITY(1,1) PRIMARY KEY,
    CAPACITY SMALLINT,
    HAS_DISABLED_ACCESS BIT,         -- Use BIT for Yes/No as MSSQL has no boolean datatype.
    HAS_HEARING_LOOP BIT
);
GO

-- Create the performanceTBL TABLE 
IF OBJECT_ID('performanceTBL' ,'U') IS NOT NULL
DROP TABLE performanceTBL;
GO
CREATE TABLE performanceTBL (
    PERFORMANCE_ID int IDENTITY(1,1) PRIMARY KEY,
    FILM_ID INT NOT NULL,  
    SCREEN_NO INT NOT NULL,
    PERFORMANCE_DATE DATE,          -- Stored in format YYYY-MM-DD        
    START_TIME TIME,
    END_TIME TIME,
    PRICE MONEY,
    IN_3D BIT
);
GO

-- Create the bookingsTBL TABLE 
IF OBJECT_ID('bookingsTBL' ,'U') IS NOT NULL
DROP TABLE bookingsTBL;
GO
CREATE TABLE bookingsTBL (
    BOOKING_ID INT IDENTITY(1,1) PRIMARY KEY, 
    CUSTOMER_ID INT NOT NULL,
    PERFORMANCE_ID INT NOT NULL,
    NO_OF_TICKETS TINYINT NOT NULL
);
GO

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @ ADD THE FOREIGN KEY CONSTRAINTS @
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

PRINT 'Create the Foreign Key Constraints.'

GO
ALTER TABLE bookingsTBL  
ADD CONSTRAINT FK_CustomerID FOREIGN KEY(CUSTOMER_ID)
REFERENCES customersTBL(CUSTOMER_ID)
ON DELETE CASCADE;  -- If a record in the parent table(customersTBL) is deleted the 
                    --  corresponding records in bookingsTBL will be automatically deleted.
GO
-- Ensure the Constraint is enabled
ALTER TABLE bookingsTBL CHECK CONSTRAINT FK_CustomerID

GO
ALTER TABLE bookingsTBL  
ADD CONSTRAINT FK_PerformanceID FOREIGN KEY(PERFORMANCE_ID)
REFERENCES performanceTBL(PERFORMANCE_ID)
ON DELETE CASCADE;
GO
ALTER TABLE bookingsTBL CHECK CONSTRAINT FK_PerformanceID;

GO
ALTER TABLE performanceTBL  
ADD CONSTRAINT FK_FilmID FOREIGN KEY(FILM_ID)
REFERENCES filmsTBl(FILM_ID)
ON DELETE CASCADE;
GO
ALTER TABLE performanceTBL CHECK CONSTRAINT FK_FilmID;

GO
ALTER TABLE performanceTBL 
ADD CONSTRAINT FK_ScreenID FOREIGN KEY(SCREEN_NO)
REFERENCES screenTBL(SCREEN_NO)
ON DELETE CASCADE;
GO
ALTER TABLE performanceTBL CHECK CONSTRAINT FK_ScreenID;


-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @ ADD THE OTHER CONSTRAINTS @
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- These constraints are used to verify that only a valid positive number can 
-- be added to various fields 
GO
ALTER TABLE screenTBL
ADD CONSTRAINT CHK_Capacity CHECK (CAPACITY > 0 AND CAPACITY < 500);
GO

GO
ALTER TABLE performanceTBL
ADD CONSTRAINT CHK_Price CHECK (PRICE > 0); 
GO

GO
ALTER TABLE bookingsTBL
ADD CONSTRAINT CHK_Tickets CHECK (NO_OF_TICKETS > 0); 
GO


-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @ CREATE THE INSERT PROCEDURES @
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

PRINT 'Create the INSERT procedures.'

-- ----------------------------------------------------------------------------
-- Procedure Name:  insertFilm
-- Author:          Andrew Laing
-- Last updated:    03/01/2019
-- Description:     This procedure inserts a new film record.
-- Parameters: @TITLE             - The film's title.
--             @GENRE             - The genre of the film.
--             @DURATION          - The duration of the film in TIME format.
--             @ACTOR_SURNAME     - The surname of the lead actor.
--             @ACTOR_FORENAME    - The first name of the lead actor.
--             @ACTRESS_SURNAME   - The surname of the lead actress.
--             @ACTRESS_FORENAME  - The first name of the lead actress.
--             @DIRECTOR_SURNAME  - The surname of the director.
--             @DIRECTOR_FORENAME - The first name of the director
--
-- Example usage: EXECUTE insertFilm 'La Dolce Vita', 'Drama', '03:12:22',
--          'Mastroianni','Marcello','Bellucci','Monica','Fellini','Federico';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('insertFilm' ,'P') IS NOT NULL
DROP PROCEDURE insertFilm;
GO
CREATE PROCEDURE insertFilm  @TITLE VARCHAR(100),
               @GENRE VARCHAR(25),
               @DURATION TIME,
               @ACTOR_SURNAME VARCHAR(35),
               @ACTOR_FORENAME VARCHAR(35),
               @ACTRESS_SURNAME VARCHAR(35),
               @ACTRESS_FORENAME VARCHAR(35),
               @DIRECTOR_SURNAME VARCHAR(35),
               @DIRECTOR_FORENAME VARCHAR(35)
AS
BEGIN
SET NOCOUNT ON;  -- Turn off the messages sent back by SQL Server to improve performance
INSERT INTO filmsTBL 
           ( TITLE,
             GENRE,
             DURATION,
             ACTOR_SURNAME,
             ACTOR_FORENAME,
             ACTRESS_SURNAME,
             ACTRESS_FORENAME,
             DIRECTOR_SURNAME,
             DIRECTOR_FORENAME )
VALUES     ( @TITLE,
             @GENRE,
             @DURATION,
             @ACTOR_SURNAME,
             @ACTOR_FORENAME,
             @ACTRESS_SURNAME,
             @ACTRESS_FORENAME,
             @DIRECTOR_SURNAME,
             @DIRECTOR_FORENAME );  
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: insertCustomer
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure inserts a new customer record.
-- Parameters:     @FIRSTNAME    - The first name of the customer.
--                 @LASTNAME     - The surname of the customer
--                 @ADDRESSLINE1 - The customer's address (Line 1)
--                 @ADDRESSLINE2 - The customer's address (Line 2)
--                 @POSTCODE     - The customer's postcode.
--                 @EMAIL        - The email address of the customer.
--                 @PHONE_NO     - The customer's phone number
--
-- Example usage: EXECUTE insertCustomer 'Randolph', 'Scott', '22 Pelican Grove', 'Liverpool', 'L19 0NE',
--          'randyscott@gmail.com', '0151 666 6666';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('insertCustomer' ,'P') IS NOT NULL
DROP PROCEDURE insertCustomer;
GO
CREATE PROCEDURE insertCustomer @FIRSTNAME VARCHAR(35),
                @LASTNAME VARCHAR(35),
                @ADDRESSLINE1 VARCHAR(50),
                @ADDRESSLINE2 VARCHAR(50),
                @POSTCODE VARCHAR(10),
                @EMAIL VARCHAR(50),
                @PHONE_NO VARCHAR(15)
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO customersTBL 
             ( FIRSTNAME,
               LASTNAME,
               ADDRESSLINE1,
               ADDRESSLINE2,
               POSTCODE,
               EMAIL,
               PHONE_NO )
VALUES       ( @FIRSTNAME,
               @LASTNAME,
               @ADDRESSLINE1,
               @ADDRESSLINE2,
               @POSTCODE,
               @EMAIL,
               @PHONE_NO );   
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getEndTime
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the calculated end time of a film performance.
-- Parameters:    @START_TIME - The start of a film performance.
--                @DURATION   - The duration of the performance.
--
-- Example usage: SELECT dbo.getEndTime('20:30','01:45') AS END_TIME;
-- Example result:
--    END_TIME
--    22:15:00.0000000
--
-- Notes:     The getEndTime function is used by the insertPerformance and updatePerformance procedures.
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getEndTime' ,'FN') IS NOT NULL
DROP FUNCTION getEndTime;
GO
CREATE FUNCTION getEndTime ( @START_TIME TIME, @DURATION TIME)
RETURNS TIME
AS
BEGIN
RETURN
( 
    -- To add times together they must first be converted to datetime.
    CONVERT( time, (CONVERT(datetime,@start_time) + CONVERT(datetime,@duration)) ) 
);
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: insertScreen
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure inserts a new screen record.
-- Parameters:     @CAPACITY - The capacity of the screening room. 
--                 @HAS_DISABLED_ACCESS - 1 if the screening room has disabled access, otherwise 0.
--                 @HAS_HEARING_LOOP - 1 if the screening room has a hearing loop, otherwise 0.
--
-- Example usage:  EXECUTE insertScreen 50,0,1;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('insertScreen' ,'P') IS NOT NULL
DROP PROCEDURE insertScreen;
GO
CREATE PROCEDURE insertScreen @CAPACITY SMALLINT, 
                @HAS_DISABLED_ACCESS BIT,
                @HAS_HEARING_LOOP BIT
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO screenTBL 
          ( CAPACITY,
            HAS_DISABLED_ACCESS,
            HAS_HEARING_LOOP )
VALUES    ( @CAPACITY,
            @HAS_DISABLED_ACCESS,
            @HAS_HEARING_LOOP );  
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: insertPerformance
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure inserts a new performance record.
-- Parameters:     @FILM_ID          - The ID number of the film being screened. 
--                 @SCREEN_NO        - The number of the screen where the film will be projected.
--                 @PERFORMANCE_DATE - The date when the film will be screened.
--                 @START_TIME       - The start time of the performance.
--                 @PRICE            - The cost of a single ticket for the performance.
--                 @IN_3D            - 1 if the film is in 3D, otherwise 0.
--
-- Example usage:  EXECUTE insertPerformance 1,1,'2018-08-21','20:00:00',12.99,0;
-- Notes:          This procedure can only insert films from the filmsTBL as a performance.
--                 The END_TIME is calculated using the getEndTime function.
-- ----------------------------------------------------------------------------
IF OBJECT_ID('insertPerformance' ,'P') IS NOT NULL
DROP PROCEDURE insertPerformance;
GO
CREATE PROCEDURE insertPerformance @FILM_ID INT,
                   @SCREEN_NO INT,
                   @PERFORMANCE_DATE DATE,
                   @START_TIME TIME,
                   @PRICE MONEY,
                   @IN_3D BIT
AS
BEGIN
SET NOCOUNT ON;

-- Calculate the END_TIME
DECLARE @duration TIME    -- Declare variables used in the procedure 
DECLARE @END_TIME TIME
SET @duration = (SELECT duration from filmsTBL where film_ID = @FILM_ID)
SET @END_TIME = dbo.getEndTime(@START_TIME,@duration);

-- INSERT the record
INSERT INTO performanceTBL
            ( FILM_ID,
              SCREEN_NO,
              PERFORMANCE_DATE,
              START_TIME,
              END_TIME,
              PRICE,
              IN_3D )
VALUES      ( @FILM_ID,
              @SCREEN_NO,
              @PERFORMANCE_DATE,
              @START_TIME,
              @END_TIME,
              @PRICE,
              @IN_3D );   
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: insertBooking
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure inserts a new booking record.
-- Parameters:     @CUSTOMER_ID  - The ID number for the customer making the booking.
--                 @PERFORMANCE_ID - The ID number for the performance.
--                 @NO_OF_TICKETS  - The number of tickets being booked.
--
-- Example usage:  EXECUTE insertBooking 1,2,2;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('insertBooking' ,'P') IS NOT NULL
DROP PROCEDURE insertBooking;
GO
CREATE PROCEDURE insertBooking @CUSTOMER_ID INT,
                 @PERFORMANCE_ID INT,
                 @NO_OF_TICKETS TINYINT
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO bookingsTBL 
            ( CUSTOMER_ID,
              PERFORMANCE_ID,
              NO_OF_TICKETS )
VALUES      ( @CUSTOMER_ID,
              @PERFORMANCE_ID,
              @NO_OF_TICKETS );   
END;
GO

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @ CREATE THE DELETE PROCEDURES @
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

PRINT 'Create the DELETE procedures.'

-- ----------------------------------------------------------------------------
-- Procedure Name: cascadeDeleteFilm
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure cascade deletes a specified film record.
-- Parameters:     @FILM_ID  - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deleteFilm 1;
--
-- Notes:          Only an Administrator should be given permission to use
--                 this procedure. All other users should utilise the deleteFilm
--                 procedure instead.
-- ----------------------------------------------------------------------------
IF OBJECT_ID('cascadeDeleteFilm' ,'P') IS NOT NULL
DROP PROCEDURE cascadeDeleteFilm;
GO
CREATE PROCEDURE cascadeDeleteFilm @FILM_ID INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM filmsTBL 
WHERE FILM_ID=@FILM_ID;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: deleteFilm
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure deletes a specified film record where no records within
--                 the performanceTBL table refer it.
-- Parameters:     @FILM_ID  - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deleteFilm 1;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('deleteFilm' ,'P') IS NOT NULL
DROP PROCEDURE deleteFilm;
GO
CREATE PROCEDURE deleteFilm  @FILM_ID INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM filmsTBL 
-- Only delete the record if it is not referred to by a Foreign Key
WHERE FILM_ID=@FILM_ID  
AND NOT EXISTS ( SELECT * FROM performanceTBL WHERE FILM_ID=@FILM_ID );
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: cascadeDeleteCustomer
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure cascade deletes the record for a specified customer.
-- Parameters:     @CUSTOMER_ID  - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deleteCustomer 1;
--
-- Notes:          Only an Administrator should be given permission to use
--                 this procedure. All other users should utilise the deleteCustomer
--                 procedure instead.
-- ----------------------------------------------------------------------------
IF OBJECT_ID('cascadeDeleteCustomer' ,'P') IS NOT NULL
DROP PROCEDURE cascadeDeleteCustomer;
GO
CREATE PROCEDURE cascadeDeleteCustomer @CUSTOMER_ID INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM customersTBL WHERE CUSTOMER_ID=@CUSTOMER_ID;  
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: deleteCustomer
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure deletes the record for a specified customer where no record 
--                 references it within the bookingsTBL.
-- Parameters:     @CUSTOMER_ID  - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deleteCustomer 1;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('deleteCustomer' ,'P') IS NOT NULL
DROP PROCEDURE deleteCustomer;
GO
CREATE PROCEDURE deleteCustomer @CUSTOMER_ID INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM customersTBL WHERE CUSTOMER_ID=@CUSTOMER_ID   
AND NOT EXISTS ( SELECT * FROM bookingsTBL WHERE CUSTOMER_ID=@CUSTOMER_ID );  
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: cascadeDeleteScreen
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure cascade deletes a specified screen record.
-- Parameters:     @SCREEN_NO  - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deleteScreen 9;
--
-- Notes:          Only an Administrator should be given permission to use
--                 this procedure. All other users should utilise the deleteScreen
--                 procedure instead.
-- ----------------------------------------------------------------------------
IF OBJECT_ID('cascadeDeleteScreen' ,'P') IS NOT NULL
DROP PROCEDURE cascadeDeleteScreen;
GO
CREATE PROCEDURE cascadeDeleteScreen @SCREEN_NO INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM screenTBL 
WHERE SCREEN_NO=@SCREEN_NO;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: deleteScreen
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure deletes a specified screen record where no records within
--                 the performanceTBL table refer it.
-- Parameters:     @SCREEN_NO  - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deleteScreen 9;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('deleteScreen' ,'P') IS NOT NULL
DROP PROCEDURE deleteScreen;
GO
CREATE PROCEDURE deleteScreen  @SCREEN_NO INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM screenTBL 
WHERE SCREEN_NO=@SCREEN_NO  
AND NOT EXISTS ( SELECT * FROM performanceTBL WHERE SCREEN_NO=@SCREEN_NO );
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: deleteBooking
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure deletes the record for a specified booking.
-- Parameters:     @BOOKING_ID - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deleteBooking 1;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('deleteBooking' ,'P') IS NOT NULL
DROP PROCEDURE deleteBooking;
GO
CREATE PROCEDURE deleteBooking @BOOKING_ID INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM bookingsTBL WHERE BOOKING_ID=@BOOKING_ID;   
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: cascadeDeletePerformance
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure cascade deletes the record for a specified performance
-- Parameters:     @PERFORMANCE  - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deletePerformance 1;
--
-- Notes:          Only an Administrator should be given permission to use
--                 this procedure. All other users should utilise the deletePerformance
--                 procedure instead.
-- ----------------------------------------------------------------------------
IF OBJECT_ID('cascadeDeletePerformance' ,'P') IS NOT NULL
DROP PROCEDURE cascadeDeletePerformance;
GO
CREATE PROCEDURE cascadeDeletePerformance @PERFORMANCE_ID INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM performanceTBL 
WHERE PERFORMANCE_ID=@PERFORMANCE_ID;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: deletePerformance
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure deletes the record for a specified performance where no record
--                 references it within bookingsTBL.
-- Parameters:     @PERFORMANCE  - The ID number for the record being deleted.
--
-- Example usage:  EXECUTE deletePerformance 1;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('deletePerformance' ,'P') IS NOT NULL
DROP PROCEDURE deletePerformance;
GO
CREATE PROCEDURE deletePerformance @PERFORMANCE_ID INT
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM performanceTBL 
WHERE PERFORMANCE_ID=@PERFORMANCE_ID  
AND NOT EXISTS ( SELECT * FROM bookingsTBL WHERE PERFORMANCE_ID=@PERFORMANCE_ID );
END;
GO

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @ CREATE THE UPDATE PROCEDURES @
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

PRINT 'Create the UPDATE procedures.'

-- ----------------------------------------------------------------------------
-- Procedure Name: updateFilm
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure updates the record for a specified film.
-- Parameters:     @FILM              - The ID number for the record being updated.
--                 @TITLE             - The film's title.
--                 @GENRE             - The genre of the film.
--                 @DURATION          - The duration of the film in the TIME format.
--                 @ACTOR_SURNAME     - The surname of the lead actor.
--                 @ACTOR_FORENAME    - The first name of the lead actor.
--                 @ACTRESS_SURNAME   - The surname of the lead actress.
--                 @ACTRESS_FORENAME  - The first name of the lead actress.
--                 @DIRECTOR_SURNAME  - The surname of the director.
--                 @DIRECTOR_FORENAME - The first name of the director
--
-- Example usage:  EXECUTE updateFilm 2,  'La Dolce Vita', 'Drama', '03:12:22',
--                 'Mastroianni','Marcello','Vitti','Monica','Fellini','Federico';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('updateFilm' ,'P') IS NOT NULL
DROP PROCEDURE updateFilm;
GO
CREATE PROCEDURE updateFilm @FILM_ID INT,
                @TITLE VARCHAR(100),
                @GENRE VARCHAR(25),
                @DURATION TIME,
                @ACTOR_SURNAME VARCHAR(35),
                @ACTOR_FORENAME VARCHAR(35),
                @ACTRESS_SURNAME VARCHAR(35),
                @ACTRESS_FORENAME VARCHAR(35),
                @DIRECTOR_SURNAME VARCHAR(35),
                @DIRECTOR_FORENAME VARCHAR(35)
AS
BEGIN
SET NOCOUNT ON;
UPDATE filmsTBL 
SET TITLE=@TITLE,
    GENRE=@GENRE,
    DURATION=@DURATION,
    ACTOR_SURNAME=@ACTOR_SURNAME,
    ACTOR_FORENAME=@ACTOR_FORENAME,
    ACTRESS_SURNAME=@ACTRESS_SURNAME,
    ACTRESS_FORENAME=@ACTRESS_FORENAME,
    DIRECTOR_SURNAME=@DIRECTOR_SURNAME,
    DIRECTOR_FORENAME=@DIRECTOR_FORENAME
WHERE FILM_ID=@FILM_ID;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: updateCustomer
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure updates the record for a specified customer.
-- Parameters:     @CUSTOMER_RECORD - The ID number for the record being updated.
--                 @FIRSTNAME       - The customer's first name.
--                 @LASTNAME        - The customer's surname.
--                 @ADDRESSLINE1    - The customer's address (Line 1)
--                 @ADDRESSLINE2    - The customer's address (Line 2)
--                 @POSTCODE        - The customer's postcode.
--                 @EMAIL           - The email address of the customer.
--                 @PHONE_NO        - The customer's phone number
--
-- Example usage:  EXECUTE updateCustomer 'Randolph', 'Scott', '22 Pelican Grove', 'Liverpool',
--                                        'L19 0NE', 'randyscott123@gmail.com', '01516666666';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('updateCustomer' ,'P') IS NOT NULL
DROP PROCEDURE updateCustomer;
GO
CREATE PROCEDURE updateCustomer @CUSTOMER_ID INT,
                @FIRSTNAME VARCHAR(35),
                @LASTNAME VARCHAR(35),
                @ADDRESSLINE1 VARCHAR(50),
                @ADDRESSLINE2 VARCHAR(50),
                @POSTCODE VARCHAR(10),
                @EMAIL VARCHAR(50),
                @PHONE_NO VARCHAR(15)
AS
BEGIN
SET NOCOUNT ON;
UPDATE customersTBL
SET FIRSTNAME=@FIRSTNAME,
    LASTNAME=@LASTNAME,
    ADDRESSLINE1=@ADDRESSLINE1,
    ADDRESSLINE2=@ADDRESSLINE2,
    POSTCODE=@POSTCODE,
    EMAIL=@EMAIL,
    PHONE_NO=@PHONE_NO
WHERE CUSTOMER_ID=@CUSTOMER_ID
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: updateScreen
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure updates the record for a specified film.
-- Parameters:     @SCREEN_NO           - The ID number of a screen.
--                 @CAPACITY            - The capacity of the screening room. 
--                 @HAS_DISABLED_ACCESS - 1 if the screening room has disabled access, otherwise 0.
--                 @HAS_HEARING_LOOP    - 1 if the screening room has a hearing loop, otherwise 0.
--
-- Example usage:  EXECUTE updateScreen 1, 200, 1, 0;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('updateScreen' ,'P') IS NOT NULL
DROP PROCEDURE updateScreen;
GO
CREATE PROCEDURE updateScreen @SCREEN_NO INT,
                @CAPACITY SMALLINT, 
                @HAS_DISABLED_ACCESS BIT,
                @HAS_HEARING_LOOP BIT
AS
BEGIN
SET NOCOUNT ON;
UPDATE screenTBL 
SET CAPACITY=@CAPACITY,
    HAS_DISABLED_ACCESS=@HAS_DISABLED_ACCESS,
    HAS_HEARING_LOOP=@HAS_HEARING_LOOP
WHERE SCREEN_NO=@SCREEN_NO
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: updateBooking
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure updates the record for a specified booking.
-- Parameters:     @BOOKING_ID   - The ID number for the record being updated.
--                 @CUSTOMER_ID  - The customer's ID number
--                 @PERFORMANCE_ID - The ID number for the performance.
--                 @NO_OF_TICKETS  - The number of tickets being booked.
--
-- Example usage:  EXECUTE updateBooking 2,4,2,5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('updateBooking' ,'P') IS NOT NULL
DROP PROCEDURE updateBooking;
GO
CREATE PROCEDURE updateBooking @BOOKING_ID INT,
                 @CUSTOMER_ID INT,
                 @PERFORMANCE_ID INT,
                 @NO_OF_TICKETS TINYINT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRANSACTION;
  SAVE TRANSACTION updateBookingSave;
  BEGIN TRY
    UPDATE bookingsTBL
    SET CUSTOMER_ID=@CUSTOMER_ID,
        PERFORMANCE_ID=@PERFORMANCE_ID,
        NO_OF_TICKETS=@NO_OF_TICKETS
    WHERE BOOKING_ID=@BOOKING_ID
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION updateBookingSave
        PRINT 'Unable to update Booking record'
    END
  END CATCH
  COMMIT TRANSACTION
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: updatePerformance
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure updates the record for a specified performance
-- Parameters:     @PERFORMANCE_ID   - The ID number for the record being updated.
--                 @FILM_ID          - The film's ID number.
--                 @SCREEN_NO        - The number of the screen where the film will be projected. 
--                 @PERFORMANCE_DATE - The date when the film will be projected.
--                 @START_TIME       - The start time for the performance.
--                 @PRICE            - The cost of a single ticket for the performance.
--                 @IN_3D            - 1 if the film is in 3D, otherwise 0.
--
-- Example usage:  EXECUTE updatePerformance 2,11,3,'2018-08-25','20:00:00',12.99,0;
--
-- Notes:          The END_TIME is calculated using the getEndTime function.
-- ----------------------------------------------------------------------------
IF OBJECT_ID('updatePerformance' ,'P') IS NOT NULL
DROP PROCEDURE updatePerformance;
GO
CREATE PROCEDURE updatePerformance @PERFORMANCE_ID INT,
                   @FILM_ID INT,
                   @SCREEN_NO INT,
                   @PERFORMANCE_DATE DATE,
                   @START_TIME TIME,
                   @PRICE MONEY,
                   @IN_3D BIT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRANSACTION;
  SAVE TRANSACTION updatePerformanceSave;
  BEGIN TRY
    -- Calculate the END_TIME
    DECLARE @duration TIME
    DECLARE @END_TIME TIME
    -- Get the duration for the film from filmTBL
    SET @duration = (SELECT duration from filmsTBL where film_ID = @FILM_ID)
    -- Calculate the end time for the film
    SET @END_TIME = dbo.getEndTime(@START_TIME,@duration);

    -- UPDATE the record
    UPDATE performanceTBL
    SET FILM_ID=@FILM_ID,
        SCREEN_NO=@SCREEN_NO,
        PERFORMANCE_DATE=@PERFORMANCE_DATE,
        START_TIME=@START_TIME,
        END_TIME=@END_TIME,
        PRICE=@PRICE,
        IN_3D=@IN_3D
    WHERE PERFORMANCE_ID=@PERFORMANCE_ID
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION updatePerformanceSave
        PRINT 'Unable to update Performance record'
    END
  END CATCH
  COMMIT TRANSACTION
END;
GO

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @ CREATE THE SELECT PROCEDURES @
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

PRINT 'Create the SELECT procedures and functions.'

-- ----------------------------------------------------------------------------
-- Procedure Name: getFilmRecordByID
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the record for a specified film.
-- Parameters:     @FILM_ID  - The ID number for a film.
--
-- Example usage:  EXECUTE getFilmRecordByID 2;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getFilmRecordByID' ,'P') IS NOT NULL
DROP PROCEDURE getFilmRecordByID;
GO
CREATE PROCEDURE getFilmRecordByID @FILM_ID INT
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM filmsTBL
WHERE FILM_ID=@FILM_ID
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getFilmIDsByTitle
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Parameters:     @TITLE - The start of or the whole of a film title.
--
-- Example usage:  EXECUTE getFilmIDsByTitle 'La';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getFilmIDsByTitle' ,'P') IS NOT NULL
DROP PROCEDURE getFilmIDsByTitle;
GO
CREATE PROCEDURE getFilmIDsByTitle @TITLE VARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @QUERY VARCHAR(100)

-- Add the supplied title and wildcard symbol to the query
SET @QUERY=@TITLE+'%'
SELECT FILM_ID, TITLE FROM filmsTBL
WHERE TITLE LIKE @QUERY
-- Sort the results by title in ascending order
ORDER BY TITLE ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getFilmRecordsByActorSurname
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns details for all film records with a specified actor surname.
-- Parameters:     @ACTOR_SURNAME - An actor's surname.
--
-- Example usage:  EXECUTE getFilmRecordsByActorSurname 'Mastroianni';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getFilmRecordsByActorSurname' ,'P') IS NOT NULL
DROP PROCEDURE getFilmRecordsByActorSurname;
GO
CREATE PROCEDURE getFilmRecordsByActorSurname @ACTOR_SURNAME VARCHAR(35)
AS
BEGIN
SET NOCOUNT ON;
-- Format the returned results as hh:mm
SELECT ACTOR_SURNAME, ACTOR_FORENAME, TITLE, GENRE,
       FORMAT(duration, N'hh\:mm') "DURATION"       -- format duration as hh:mm
FROM filmsTBL
WHERE
ACTOR_SURNAME=@ACTOR_SURNAME
-- Sort the results first by duration in ascending order, 
-- then by title in ascending order.
ORDER BY DURATION ASC, TITLE ASC;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getFilmRecordsByActressSurname
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns details for all film records with a specified actor surname.
-- Parameters:     @ACTRESS_SURNAME - An actor's surname.
--
-- Example usage:  EXECUTE getFilmRecordsByActressSurname 'Loren';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getFilmRecordsByActressSurname' ,'P') IS NOT NULL
DROP PROCEDURE getFilmRecordsByActressSurname;
GO
CREATE PROCEDURE getFilmRecordsByActressSurname @ACTRESS_SURNAME VARCHAR(35)
AS
BEGIN
SET NOCOUNT ON;
SELECT ACTRESS_SURNAME, ACTRESS_FORENAME, TITLE, GENRE,
       FORMAT(duration, N'hh\:mm') "DURATION" 
FROM filmsTBL
WHERE
ACTRESS_SURNAME=@ACTRESS_SURNAME
ORDER BY DURATION ASC, TITLE ASC;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getFilmRecordsByDirectorSurname
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns details for all film records with a specified director surname.
-- Parameters:     @DIRECTOR_SURNAME - A film director's surname.
--
-- Example usage:  EXECUTE getFilmRecordsByDirectorSurname 'Hitchcock';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getFilmRecordsByDirectorSurname' ,'P') IS NOT NULL
DROP PROCEDURE getFilmRecordsByDirectorSurname;
GO
CREATE PROCEDURE getFilmRecordsByDirectorSurname @DIRECTOR_SURNAME VARCHAR(35)
AS
BEGIN
SET NOCOUNT ON;
SELECT DIRECTOR_SURNAME, DIRECTOR_FORENAME, TITLE, GENRE,
       FORMAT(duration, N'hh\:mm') "DURATION" 
FROM filmsTBL
WHERE
DIRECTOR_SURNAME=@DIRECTOR_SURNAME
ORDER BY DURATION ASC, TITLE ASC;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getFilmRecordsByDuration
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns details for all films between duration @MIN_LENGTH and @MAX_LENGTH.
-- Parameters:     @MIN_LENGTH - The minimum duration that a film should run for.
--                 @MAX_LENGTH - The maximum duration that a film should run for.
--
-- Example usage:  EXECUTE getFilmRecordsByDuration '00:45','02:30';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getFilmRecordsByDuration' ,'P') IS NOT NULL
DROP PROCEDURE getFilmRecordsByDuration;
GO
CREATE PROCEDURE getFilmRecordsByDuration @MIN_LENGTH TIME, @MAX_LENGTH TIME
AS
BEGIN
SET NOCOUNT ON;
SELECT TITLE,GENRE,FORMAT(duration, N'hh\:mm') "DURATION" from filmsTBL
WHERE
-- Time datatypes cannot be compared so they must first be cast to datetime.
CAST(DURATION AS DATETIME) >= CAST(@MIN_LENGTH AS DATETIME)
AND 
CAST(DURATION AS DATETIME) <= CAST(@MAX_LENGTH AS DATETIME)
ORDER BY DURATION ASC, TITLE ASC;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getFilmRecordsByGenre
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns details for all films belonging to the genre specified.
-- Parameters:     @GENRE - The genre that the returned films belong to.
--
-- Example usage:  EXECUTE getFilmRecordsByGenre 'Comedy';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getFilmRecordsByGenre' ,'P') IS NOT NULL
DROP PROCEDURE getFilmRecordsByGenre;
GO
CREATE PROCEDURE getFilmRecordsByGenre @GENRE VARCHAR(25)
AS
BEGIN
SET NOCOUNT ON;
SELECT TITLE,GENRE,FORMAT(duration, N'hh\:mm') "DURATION" from filmsTBL
WHERE
GENRE=@GENRE
ORDER BY TITLE ASC;
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getAllScreenNumbers
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This function returns all screen numbers.
-- Parameters:     None
--
-- Example usage:  SELECT * FROM dbo.getAllScreenNumbers();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllScreenNumbers' ,'FN') IS NOT NULL
DROP FUNCTION getAllScreenNumbers;
GO
CREATE FUNCTION getAllScreenNumbers ( )
RETURNS TABLE
AS
RETURN 
(
  -- Select unique screen numbers from the table 
  SELECT DISTINCT SCREEN_NO from screenTBL
);
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getAllScreenDetails
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns all screen details. 
-- Parameters:     None
--
-- Example usage:  EXECUTE getAllScreenDetails;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllScreenDetails' ,'P') IS NOT NULL
DROP PROCEDURE getAllScreenDetails;
GO
CREATE PROCEDURE getAllScreenDetails
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM screenTBL
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getScreenDetailsByMinimumCapacity
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns all screen details. 
-- Parameters:     @MIN_CAPACITY - The minimum amount of seats available in the screening room.
--
-- Example usage:  EXECUTE getScreenDetailsByMinimumCapacity 250;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getScreenDetailsByMinimumCapacity' ,'P') IS NOT NULL
DROP PROCEDURE getScreenDetailsByMinimumCapacity;
GO
CREATE PROCEDURE getScreenDetailsByMinimumCapacity @MIN_CAPACITY SMALLINT
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM screenTBL
WHERE CAPACITY>=@MIN_CAPACITY
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getScreenDetailsByScreenNumber
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the details for a specified screen. 
-- Parameters:     @SCREEN_NO - The ID number of a screen.
--
-- Example usage:  EXECUTE getScreenDetailsByScreenNumber 2;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getScreenDetailsByScreenNumber' ,'P') IS NOT NULL
DROP PROCEDURE getScreenDetailsByScreenNumber;
GO
CREATE PROCEDURE getScreenDetailsByScreenNumber @SCREEN_NO INT
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM screenTBL
WHERE SCREEN_NO=@SCREEN_NO
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getScreensWithDisabledAccess
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the details for screens with disabled access. 
-- Parameters:     None
--
-- Example usage:  EXECUTE getScreensWithDisabledAccess;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getScreensWithDisabledAccess' ,'P') IS NOT NULL
DROP PROCEDURE getScreensWithDisabledAccess;
GO
CREATE PROCEDURE getScreensWithDisabledAccess
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM screenTBL
WHERE HAS_DISABLED_ACCESS=1
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getScreensWithHearingLoop
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the details for screens with hearing loops. 
-- Parameters:     None
--
-- Example usage:  EXECUTE getScreensWithHearingLoop;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getScreensWithHearingLoop' ,'P') IS NOT NULL
DROP PROCEDURE getScreensWithHearingLoop;
GO
CREATE PROCEDURE getScreensWithHearingLoop
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM screenTBL
WHERE HAS_HEARING_LOOP=1
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getBookingRecordByID
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the record for a specified booking.
-- Parameters:     @BOOKING_ID - The ID number for a booking record.
--
-- Example usage:  EXECUTE getBookingRecordByID 2;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getBookingRecordByID' ,'P') IS NOT NULL
DROP PROCEDURE getBookingRecordByID;
GO
CREATE PROCEDURE getBookingRecordByID @BOOKING_ID INT
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM bookingsTBL
WHERE BOOKING_ID=@BOOKING_ID
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getBookingRecordsByCustomerID
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the booking records for a specified customer ID.
-- Parameters:     @CUSTOMER_ID  - Customer ID number used to find booking records.
--
-- Example usage:  EXECUTE getBookingRecordsByCustomerID 7;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getBookingRecordsByCustomerID' ,'P') IS NOT NULL
DROP PROCEDURE getBookingRecordsByCustomerID;
GO
CREATE PROCEDURE getBookingRecordsByCustomerID @CUSTOMER_ID INT
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM bookingsTBL
WHERE CUSTOMER_ID=@CUSTOMER_ID
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getBookingRecordsByFilmID
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the booking records for a specified film ID.
-- Parameters:     @FILM_ID  - Film ID number used to find booking records.
--
-- Example usage:  EXECUTE getBookingRecordsByFilmID 11;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getBookingRecordsByFilmID' ,'P') IS NOT NULL
DROP PROCEDURE getBookingRecordsByFilmID;
GO
CREATE PROCEDURE getBookingRecordsByFilmID @FILM_ID INT
AS
BEGIN
SET NOCOUNT ON;
SELECT BT.BOOKING_ID,BT.CUSTOMER_ID,BT.PERFORMANCE_ID,BT.NO_OF_TICKETS 
FROM bookingsTBL "BT"
-- Perform an INNER JOIN on the performance table to get performance records
-- with the supplied filmID, so that the booking records can be filtered to
-- contain the appropiate performances. 
INNER JOIN performanceTBL "PT" ON (BT.PERFORMANCE_ID=PT.PERFORMANCE_ID)
WHERE
PT.FILM_ID=@FILM_ID
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getBookingRecordsForDate
-- Author:         Andrew Laing
-- Last updated    03/01/2019
-- Description:    This procedure searches for all booking records for the date specified.
-- Parameters:     @DATE - The date of the query.
--
-- Example usage:  EXECUTE getBookingRecordsForDate '2018-08-23';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getBookingRecordsForDate' ,'P') IS NOT NULL
DROP PROCEDURE getBookingRecordsForDate;
GO
CREATE PROCEDURE getBookingRecordsForDate @DATE DATE
AS
BEGIN
SET NOCOUNT ON;
DECLARE @theDate DATETIME
DECLARE @dayAfter DATETIME
SET @theDate = cast(@DATE as datetime)
SET @dayAfter = DATEADD(DAY, 1, @theDate) 
SELECT BT.BOOKING_ID,BT.CUSTOMER_ID,BT.PERFORMANCE_ID,BT.NO_OF_TICKETS 
FROM bookingsTBL "BT"
-- Perform an INNER JOIN to get performances on the date specified
-- Note: it is done using the two comparisons to get all records between the start of
-- the day and Midnight because comparisons can only be done with datetime.
INNER JOIN performanceTBL "PT" ON (BT.PERFORMANCE_ID=PT.PERFORMANCE_ID)
WHERE 
    PT.PERFORMANCE_DATE>=@theDate
AND 
    PT.PERFORMANCE_DATE<@dayAfter
ORDER BY PT.PERFORMANCE_DATE ASC, PT.START_TIME
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getBookingRecordsForPeriod
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for all booking records for the dates between and including
--                 @MIN_DATE and @MAX_DATE. 
-- Parameters:     @MIN_DATE - The start date of the query period.
--                 @MAX_DATE - The end date of the query period.
--
-- Example usage:  EXECUTE getBookingRecordsForPeriod '2018-08-23','2018-08-25';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getBookingRecordsForPeriod' ,'P') IS NOT NULL
DROP PROCEDURE getBookingRecordsForPeriod;
GO
CREATE PROCEDURE getBookingRecordsForPeriod @MIN_DATE DATE, @MAX_DATE DATE
AS
BEGIN
SET NOCOUNT ON;
SELECT BT.BOOKING_ID,BT.CUSTOMER_ID,BT.PERFORMANCE_ID,BT.NO_OF_TICKETS 
FROM bookingsTBL "BT"
INNER JOIN performanceTBL "PT" ON (BT.PERFORMANCE_ID=PT.PERFORMANCE_ID)
WHERE
    PT.PERFORMANCE_DATE >= CAST(@MIN_DATE AS DATETIME)
AND 
    PT.PERFORMANCE_DATE <= CAST(@MAX_DATE AS DATETIME)
ORDER BY PT.PERFORMANCE_DATE ASC, PT.START_TIME
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getBookingRecordsForToday
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for all booking records for today.
-- Parameters:     None.
--
-- Example usage:  EXECUTE getBookingRecordsForToday;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getBookingRecordsForToday' ,'P') IS NOT NULL
DROP PROCEDURE getBookingRecordsForToday;
GO
CREATE PROCEDURE getBookingRecordsForToday
AS
BEGIN
SET NOCOUNT ON;
DECLARE @todaysDate DATETIME
DECLARE @tomorrowsDate DATETIME
-- Note: getDate supplies the day and time. By converting it to a date and then
--       back to a datetime it is set to the start of the day and will therefore
--       find all records matching today instead of only those after the current time.
SET @todaysDate = cast(cast(getdate() as date ) as datetime)

-- Get the start of tomorrow by adding 1 day to today
SET @tomorrowsDate = DATEADD(DAY, 1, @todaysDate) 

SELECT BT.BOOKING_ID,BT.CUSTOMER_ID,BT.PERFORMANCE_ID,BT.NO_OF_TICKETS 
FROM bookingsTBL "BT"
INNER JOIN performanceTBL "PT" ON (BT.PERFORMANCE_ID=PT.PERFORMANCE_ID)
WHERE 
  PERFORMANCE_DATE>=@todaysDate
AND 
  PERFORMANCE_DATE<@tomorrowsDate
ORDER BY PT.PERFORMANCE_DATE ASC, PT.START_TIME
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getBookingRecordsForTomorrow
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for all booking records for tomorrow.
-- Parameters:     None.
--
-- Example usage:  EXECUTE getBookingRecordsForTomorrow;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getBookingRecordsForTomorrow' ,'P') IS NOT NULL
DROP PROCEDURE getBookingRecordsForTomorrow;
GO
CREATE PROCEDURE getBookingRecordsForTomorrow
AS
BEGIN
SET NOCOUNT ON;
DECLARE @today DATETIME
DECLARE @tomorrow DATETIME
DECLARE @dayAfterTomorrow DATETIME

-- Calculate the start of tomorrow by adding 1 day to ttoday
SET @today = cast(cast(getdate() as date ) as datetime)
SET @tomorrow = cast(DATEADD(DAY, 1, @today) as datetime) 

-- Calculate the day after tomorrow by adding 1 day to tomorrow
SET @dayAfterTomorrow = DATEADD(DAY, 1, @tomorrow)

SELECT BT.BOOKING_ID,BT.CUSTOMER_ID,BT.PERFORMANCE_ID,BT.NO_OF_TICKETS 
FROM bookingsTBL "BT"
INNER JOIN performanceTBL "PT" ON (BT.PERFORMANCE_ID=PT.PERFORMANCE_ID)
WHERE 
  PERFORMANCE_DATE>=@tomorrow
AND 
  PERFORMANCE_DATE<@dayAfterTomorrow
ORDER BY PT.PERFORMANCE_DATE ASC, PT.START_TIME
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getBookingRecordsByPerformanceID
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the booking records for a specified performance ID.
-- Parameters:     @PERFORMANCE_ID - Performance ID number used to find booking records.
--
-- Example usage:  EXECUTE getBookingRecordsByPerformanceID 7;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getBookingRecordsByPerformanceID' ,'P') IS NOT NULL
DROP PROCEDURE getBookingRecordsByPerformanceID;
GO
CREATE PROCEDURE getBookingRecordsByPerformanceID @PERFORMANCE_ID INT
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM bookingsTBL
WHERE PERFORMANCE_ID=@PERFORMANCE_ID
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBooked
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked.
-- Parameters:    None.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBooked() AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBooked' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBooked;
GO
CREATE FUNCTION getTotalNoOfTicketsBooked()
RETURNS INT
AS
BEGIN
RETURN
(
  -- If the result is null, coalesce will return 0 instead
  SELECT COALESCE(SUM(NO_OF_TICKETS),0) AS "TOTAL" FROM bookingsTBL
)
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByActorName
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified film.
-- Parameters:    @ACTOR_FORENAME - The first name of an actor.
--                @ACTOR_SURNAME  - The surname of an actor. 
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByActorName('Marcello','Mastroianni') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByActorName' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByActorName;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByActorName ( @ACTOR_FORENAME VARCHAR(35),
                             @ACTOR_SURNAME VARCHAR(35) )
RETURNS INT
AS
BEGIN

RETURN 
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS),0) AS "TOTAL"
  FROM ( filmsTBL "FT" INNER JOIN performanceTBL "PT" ON FT.FILM_ID = PT.FILM_ID ) 
       INNER JOIN bookingsTBL "BT" ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE FT.ACTOR_FORENAME=@ACTOR_FORENAME
  AND FT.ACTOR_SURNAME=@ACTOR_SURNAME
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByActressName
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified film.
-- Parameters:    @ACTRESS_FORENAME - The first name of an actress.
--                @ACTRESS_SURNAME  - The surname of an actress. 
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByActressName('Anouk','Aimee') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByActressName' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByActressName;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByActressName ( @ACTRESS_FORENAME VARCHAR(35),
                               @ACTRESS_SURNAME VARCHAR(35) )
RETURNS INT
AS
BEGIN

RETURN 
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS),0) AS "TOTAL"
  FROM ( filmsTBL "FT" INNER JOIN performanceTBL "PT" ON FT.FILM_ID = PT.FILM_ID ) 
       INNER JOIN bookingsTBL "BT" ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE FT.ACTRESS_FORENAME=@ACTRESS_FORENAME
  AND FT.ACTRESS_SURNAME=@ACTRESS_SURNAME
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByCustomerID
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked by a specified customer ID.
-- Parameters:    @CUSTOMER_ID  - The ID number for a customer record.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByCustomerID(4) AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByCustomerID' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByCustomerID;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByCustomerID ( @CUSTOMER_ID INT )
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(NO_OF_TICKETS),0) AS "TOTAL" FROM bookingsTBL
  WHERE CUSTOMER_ID=@CUSTOMER_ID
)
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByDirectorName
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified direcor.
-- Parameters:    @DIRECTOR_FORENAME - The first name of a director.
--                @DIRECTOR_SURNAME  - The surname of a director. 
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByDirectorName('Federico','Fellini') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByDirectorName' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByDirectorName;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByDirectorName ( @DIRECTOR_FORENAME VARCHAR(35),
                              @DIRECTOR_SURNAME VARCHAR(35) )
RETURNS INT
AS
BEGIN

RETURN 
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS),0) AS "TOTAL"
  FROM ( filmsTBL "FT" INNER JOIN performanceTBL "PT" ON FT.FILM_ID = PT.FILM_ID ) 
       INNER JOIN bookingsTBL "BT" ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE FT.DIRECTOR_FORENAME=@DIRECTOR_FORENAME
  AND FT.DIRECTOR_SURNAME=@DIRECTOR_SURNAME
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByFilmID
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified film.
-- Parameters:    @FILM_ID  - The ID number for a film.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByFilmID(7) AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByFilmID' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByFilmID;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByFilmID ( @FILM_ID INT )
RETURNS INT
AS
BEGIN
RETURN 
(
  SELECT COALESCE(SUM(NO_OF_TICKETS),0) AS "TOTAL" FROM bookingsTBL "BT"
  INNER JOIN performanceTBL "PT" ON ( PT.PERFORMANCE_ID=BT.PERFORMANCE_ID )
  WHERE PT.FILM_ID=@FILM_ID
)
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByFilmTitle
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified film.
-- Parameters:    @FILM_TITLE - The full title of a film.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByFilmTitle('La Haine') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByFilmTitle' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByFilmTitle;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByFilmTitle ( @FILM_TITLE VARCHAR(100) )
RETURNS INT
AS
BEGIN

RETURN 
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS),0) AS "TOTAL"
  FROM ( filmsTBL "FT" INNER JOIN performanceTBL "PT" ON FT.FILM_ID = PT.FILM_ID ) 
       INNER JOIN bookingsTBL "BT" ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE FT.TITLE Like @FILM_TITLE
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByGenre
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified genre.
-- Parameters:    @GENRE  - A film genre.(e.g., Comedy)
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByGenre('Comedy') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByGenre' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByGenre;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByGenre ( @GENRE VARCHAR(25) )
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS),0) AS "TOTAL"
  FROM ( filmsTBL "FT" INNER JOIN performanceTBL "PT" ON FT.FILM_ID = PT.FILM_ID ) 
       INNER JOIN bookingsTBL "BT" ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE FT.GENRE Like @GENRE
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByPerformanceID
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified performance.
-- Parameters:    @PERFORMANCE_ID - The ID number for a film performance.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByPerformanceID(3) AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByPerformanceID' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByPerformanceID;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByPerformanceID ( @PERFORMANCE_ID INT )
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(NO_OF_TICKETS),0) AS "TOTAL" FROM bookingsTBL
  WHERE PERFORMANCE_ID=@PERFORMANCE_ID
)
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByScreenNo
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified screen.
-- Parameters:    @SCREEN_NO  - A screen number.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByScreenNo(2) AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByScreenNo' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByScreenNo;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByScreenNo ( @SCREEN_NO INT )
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(NO_OF_TICKETS),0) AS "TOTAL" FROM bookingsTBL "BT"
  INNER JOIN performanceTBL "PT" ON ( PT.PERFORMANCE_ID=BT.PERFORMANCE_ID )
  WHERE PT.SCREEN_NO=@SCREEN_NO
)
  END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedInPeriod
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified period of time.
-- Parameters:    @MIN_DATE - The start date of the search period.
--                @MAX_DATE - The finish date of the search period.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedInPeriod('2018-08-21', '2018-08-23') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedInPeriod' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedInPeriod;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedInPeriod ( @MIN_DATE DATE, @MAX_DATE DATE )
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS), 0) AS "TOTAL"
  FROM performanceTBL "PT" 
  INNER JOIN bookingsTBL "BT" 
  ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE PT.PERFORMANCE_DATE>=@MIN_DATE
  AND
  PT.PERFORMANCE_DATE<=@MAX_DATE
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedOnDate
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked on a specified day.
-- Parameters:    @PERFORMANCE_DATE - The search date.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedOnDate('2018-08-22') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedOnDate' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedOnDate;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedOnDate ( @PERFORMANCE_DATE DATE )
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS), 0) AS "TOTAL"
  FROM performanceTBL "PT" 
  INNER JOIN bookingsTBL "BT" 
  ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE PT.PERFORMANCE_DATE=@PERFORMANCE_DATE
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByCustomerIDDuringPeriod
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified customer during 
--                a specified period of time.
-- Parameters:    @CUSTOMER_ID - A customer's ID number.
--                @MIN_DATE - The start date of the search period.
--                @MAX_DATE - The finish date of the search period.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByCustomerIDDuringPeriod(4, '2018-08-21', 
--                                                                            '2018-08-23') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByCustomerIDDuringPeriod' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByCustomerIDDuringPeriod;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByCustomerIDDuringPeriod ( @CUSTOMER_ID INT,
                          @MIN_DATE DATE, @MAX_DATE DATE )
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS), 0) AS "TOTAL"
  FROM performanceTBL "PT" 
  INNER JOIN bookingsTBL "BT" 
  ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE BT.CUSTOMER_ID=@CUSTOMER_ID
  AND
  PT.PERFORMANCE_DATE>=@MIN_DATE
  AND
  PT.PERFORMANCE_DATE<=@MAX_DATE
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByFilmIDDuringPeriod
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified film during 
--                a specified period of time.
-- Parameters:    @FILM_ID - A film's ID number.
--                @MIN_DATE - The start date of the search period.
--                @MAX_DATE - The finish date of the search period.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByFilmIDDuringPeriod(7, '2018-08-21', 
--                                                                         '2018-08-23') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByFilmIDDuringPeriod' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByFilmIDDuringPeriod;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByFilmIDDuringPeriod ( @FILM_ID INT,
                          @MIN_DATE DATE, @MAX_DATE DATE )
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS), 0) AS "TOTAL"
  FROM performanceTBL "PT" 
  INNER JOIN bookingsTBL "BT" 
  ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE PT.FILM_ID=@FILM_ID
  AND
  PT.PERFORMANCE_DATE>=@MIN_DATE
  AND
  PT.PERFORMANCE_DATE<=@MAX_DATE
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByGenreDuringPeriod
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified genre during 
--                a specified period of time.
-- Parameters:    @GENRE  - A film genre.(e.g., Comedy)
--                @MIN_DATE - The start date of the search period.
--                @MAX_DATE - The finish date of the search period.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByGenreDuringPeriod('Comedy', '2018-08-21', 
--                                                                        '2018-08-23') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByGenreDuringPeriod' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByGenreDuringPeriod;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByGenreDuringPeriod ( @GENRE VARCHAR(25),
                           @MIN_DATE DATE, @MAX_DATE DATE ) 
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(BT.NO_OF_TICKETS),0) AS "TOTAL"
  FROM ( filmsTBL "FT" INNER JOIN performanceTBL "PT" ON FT.FILM_ID = PT.FILM_ID ) 
       INNER JOIN bookingsTBL "BT" ON PT.PERFORMANCE_ID = BT.PERFORMANCE_ID
  WHERE FT.GENRE Like @GENRE
  AND
  PT.PERFORMANCE_DATE>=@MIN_DATE
  AND
  PT.PERFORMANCE_DATE<=@MAX_DATE  
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByScreenNoDuringPeriod
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a specified screen during
--                a specified time period.
-- Parameters:    @SCREEN_NO  - A screen number.
--                @MIN_DATE - The start date of the search period.
--                @MAX_DATE - The finish date of the search period.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByScreenNoDuringPeriod(3, '2018-08-21', 
--                                                                           '2018-08-23') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByScreenNoDuringPeriod' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByScreenNoDuringPeriod;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByScreenNoDuringPeriod ( @SCREEN_NO INT,
                                  @MIN_DATE DATE, @MAX_DATE DATE)
RETURNS INT
AS
BEGIN
RETURN
(
  SELECT COALESCE(SUM(NO_OF_TICKETS),0) AS "TOTAL" FROM bookingsTBL "BT"
  INNER JOIN performanceTBL "PT" ON ( PT.PERFORMANCE_ID=BT.PERFORMANCE_ID )
  WHERE PT.SCREEN_NO=@SCREEN_NO
  AND
  PT.PERFORMANCE_DATE>=@MIN_DATE
  AND
  PT.PERFORMANCE_DATE<=@MAX_DATE
)
  END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedDuringPreviousWeek
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked during the previous week.
-- Parameters:    None.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedDuringPreviousWeek() AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedDuringPreviousWeek' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedDuringPreviousWeek;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedDuringPreviousWeek()
RETURNS INT
AS
BEGIN
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();                   -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.

RETURN
(
  SELECT dbo.getTotalNoOfTicketsBookedInPeriod(@startDate, @endDate)
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByCustomerDuringPreviousWeek
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked by a customer during
--                the previous week.
-- Parameters:    @CUSTOMER_ID - A customer's ID Number
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByCustomerDuringPreviousWeek(3) AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByCustomerDuringPreviousWeek' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByCustomerDuringPreviousWeek;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByCustomerDuringPreviousWeek(@CUSTOMER_ID INT)
RETURNS INT
AS
BEGIN
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();         -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.

RETURN
(
  SELECT dbo.getTotalNoOfTicketsBookedByCustomerIDDuringPeriod(@CUSTOMER_ID,@startDate, @endDate)
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByFilmIDDuringPreviousWeek
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked for a film 
--                during the previous week.
-- Parameters:    @FILM_ID - A film's ID number.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByFilmIDDuringPreviousWeek(4) AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByFilmIDDuringPreviousWeek' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByFilmIDDuringPreviousWeek;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByFilmIDDuringPreviousWeek(@FILM_ID INT)
RETURNS INT
AS
BEGIN
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();                   -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.

RETURN
(
  SELECT dbo.getTotalNoOfTicketsBookedByFilmIDDuringPeriod(@FILM_ID,@startDate, @endDate)
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByGenreDuringPreviousWeek
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked by genre
--                during the previous week.
-- Parameters:    @GENRE - A genre of films.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByGenreDuringPreviousWeek('Comedy') AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByGenreDuringPreviousWeek' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByGenreDuringPreviousWeek;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByGenreDuringPreviousWeek(@GENRE VARCHAR(25))
RETURNS INT
AS
BEGIN
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();         -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.

RETURN
(
  SELECT dbo.getTotalNoOfTicketsBookedByGenreDuringPeriod(@GENRE,@startDate, @endDate)
);
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getTotalNoOfTicketsBookedByScreenNoDuringPreviousWeek
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns the total number of tickets booked by screen number
--                during the previous week.
-- Parameters:    @SCREEN_NO - The number of a screen.
--
-- Example usage: SELECT dbo.getTotalNoOfTicketsBookedByScreenNoDuringPreviousWeek(2) AS "TOTAL";
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTotalNoOfTicketsBookedByScreenNoDuringPreviousWeek' ,'FN') IS NOT NULL
DROP FUNCTION getTotalNoOfTicketsBookedByScreenNoDuringPreviousWeek;
GO
CREATE FUNCTION getTotalNoOfTicketsBookedByScreenNoDuringPreviousWeek(@SCREEN_NO INT)
RETURNS INT
AS
BEGIN
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();         -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.

RETURN
(
  SELECT dbo.getTotalNoOfTicketsBookedByScreenNoDuringPeriod(@SCREEN_NO,@startDate, @endDate)
);
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getCustomerRecordByID
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the record for a specified customer
-- Parameters:     @CUSTOMER_ID  - The ID number for a customer record.
--
-- Example usage:  EXECUTE getCustomerRecordByID 2;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getCustomerRecordByID' ,'P') IS NOT NULL
DROP PROCEDURE getCustomerRecordByID;
GO
CREATE PROCEDURE getCustomerRecordByID @CUSTOMER_ID INT
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM customersTBL
WHERE CUSTOMER_ID=@CUSTOMER_ID
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getCustomerRecordsByEmail
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the customer record with the specified email.
-- Parameters:     @CUSTOMER_EMAIL - A customer's postcode address.
--
-- Example usage:  EXECUTE getCustomerRecordsByEmail 'sbiggins@gmail.com';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getCustomerRecordsByEmail' ,'P') IS NOT NULL
DROP PROCEDURE getCustomerRecordsByEmail;
GO
CREATE PROCEDURE getCustomerRecordsByEmail @CUSTOMER_EMAIL VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM customersTBL
WHERE EMAIL=@CUSTOMER_EMAIL
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getCustomerRecordsByPhoneNo
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns customer records with the specified phone number.
-- Parameters:     @PHONE_NO - A customer's phone number.
--
-- Example usage:  EXECUTE getCustomerRecordsByPhoneNo '01514448383';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getCustomerRecordsByPhoneNo' ,'P') IS NOT NULL
DROP PROCEDURE getCustomerRecordsByPhoneNo;
GO
CREATE PROCEDURE getCustomerRecordsByPhoneNo @PHONE_NO VARCHAR(15)
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM customersTBL
WHERE PHONE_NO=@PHONE_NO
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getCustomerRecordsByPostcode
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the customer record with the specified postcode.
-- Parameters:     @CUSTOMER_POSTCODE  - A customer's postcode.
--
-- Example usage:  EXECUTE getCustomerRecordsByPostcode 'L22 4ES';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getCustomerRecordsByPostcode' ,'P') IS NOT NULL
DROP PROCEDURE getCustomerRecordsByPostcode;
GO
CREATE PROCEDURE getCustomerRecordsByPostcode @CUSTOMER_POSTCODE VARCHAR(10)
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM customersTBL
WHERE POSTCODE=@CUSTOMER_POSTCODE
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getCustomersWithNoBookings
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects all customers who have never made a booking.
-- Parameters:     None.
--
-- Example usage:  EXECUTE getCustomersWithNoBookings;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getCustomersWithNoBookings' ,'P') IS NOT NULL
DROP PROCEDURE getCustomersWithNoBookings;
GO
CREATE PROCEDURE getCustomersWithNoBookings
AS
BEGIN
SET NOCOUNT ON;
SELECT CUSTOMER_ID,
       FIRSTNAME,
       LASTNAME,
       EMAIL,
       POSTCODE
FROM customersTBL "CT"
WHERE dbo.getTotalNoOfTicketsBookedByCustomerID(CT.CUSTOMER_ID)=0
ORDER BY LASTNAME
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getCustomersWithNoBookingsDuringPeriod
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects all customers who did not make a booking during the specified period.
-- Parameters:     @MIN_DATE - The start date of the search period.
--                 @MAX_DATE - The finish date of the search period.
--
-- Example usage:  EXECUTE getCustomersWithNoBookingsDuringPeriod '2018-08-21','2018-08-22';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getCustomersWithNoBookingsDuringPeriod' ,'P') IS NOT NULL
DROP PROCEDURE getCustomersWithNoBookingsDuringPeriod;
GO
CREATE PROCEDURE getCustomersWithNoBookingsDuringPeriod @MIN_DATE DATE, @MAX_DATE DATE
AS
BEGIN
SET NOCOUNT ON;
SELECT CUSTOMER_ID,
       FIRSTNAME,
       LASTNAME,
       EMAIL,
       POSTCODE
FROM customersTBL "CT"
WHERE dbo.getTotalNoOfTicketsBookedByCustomerIDDuringPeriod(CT.CUSTOMER_ID,@MIN_DATE,@MAX_DATE)=0
ORDER BY LASTNAME
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getPerformanceRecordByID
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the record for a specified performance
-- Parameters:     @PERFORMANCE_ID - The ID number for a performance record.
--
-- Example usage:  EXECUTE getPerformanceRecordByID 2;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getPerformanceRecordByID' ,'P') IS NOT NULL
DROP PROCEDURE getPerformanceRecordByID;
GO
CREATE PROCEDURE getPerformanceRecordByID @PERFORMANCE_ID INT
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM performanceTBL
WHERE PERFORMANCE_ID=@PERFORMANCE_ID
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getPerformanceDetailsByDateAndStartTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for performances on a specified date at a specified time. 
-- Parameters:     @PERFORMANCE_DATE - The date when the performance will take place.
--                 @START_TIME       - The time when the performance will start.
--                 @MINS_DIFF        - How many minutes before or after the start time entered that a 
--                                     performance should start in order to be included into the result set.
--
-- Example usage:  EXECUTE getPerformanceDetailsByDateAndStartTime '2018-08-22','20:00:00','00:30:00';
--
-- Notes:          To perform the comparisons the times were cast first as DATETIMEs to allow 
--                 the add and subtract operations. The method below appears to be the fastest 
--                 method of performing the operation.
--   see: https://dwaincsql.com/2015/08/28/the-fastest-way-to-combine-date-and-time-data-types-to-a-datetime/
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getPerformanceDetailsByDateAndStartTime' ,'P') IS NOT NULL
DROP PROCEDURE getPerformanceDetailsByDateAndStartTime;
GO
CREATE PROCEDURE getPerformanceDetailsByDateAndStartTime @PERFORMANCE_DATE DATE,
                             @START_TIME TIME,
                             @MINS_DIFF TIME
AS
BEGIN
SET NOCOUNT ON;
SELECT  FT.TITLE, FT.GENRE, PT.SCREEN_NO,
    -- Return the date in UK format DD/MM/YYYY 
    FORMAT (PT.PERFORMANCE_DATE, 'd', 'en-gb' ) "PERFORMANCE_DATE",
    -- Return the time in short format hh:mm
    FORMAT(PT.START_TIME, N'hh\:mm') "START_TIME",
    FORMAT(PT.END_TIME, N'hh\:mm') "END_TIME",
    PT.PRICE,PT.IN_3D
FROM performanceTBL "PT"
INNER JOIN filmsTBL "FT" ON ( PT.FILM_ID=FT.FILM_ID )
WHERE PERFORMANCE_DATE=@PERFORMANCE_DATE
AND
CAST(START_TIME AS DATETIME) >= (CAST(@START_TIME AS DATETIME) - CAST(@MINS_DIFF AS DATETIME))
AND 
CAST(START_TIME AS DATETIME) <= (CAST(@START_TIME AS DATETIME) + CAST(@MINS_DIFF AS DATETIME))
ORDER BY START_TIME,SCREEN_NO
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getPerformanceDetailsForToday
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for all of today's performances. 
-- Parameters:     None
--
-- Example usage:  EXECUTE getPerformanceDetailsForToday;
--
-- Notes:          Today's date was first cast to a DATE format in order to get a datetime 
--                 starting at 12am rather than the time at which the query was run. It could 
--                 have been done by converting the performance date but this way the conversion 
--                 only needs to be done once.
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getPerformanceDetailsForToday' ,'P') IS NOT NULL
DROP PROCEDURE getPerformanceDetailsForToday;
GO
CREATE PROCEDURE getPerformanceDetailsForToday
AS
BEGIN
SET NOCOUNT ON;
DECLARE @todaysDate DATETIME
DECLARE @tomorrowsDate DATETIME
SET @todaysDate = cast(cast(getdate() as date ) as datetime)
SET @tomorrowsDate = DATEADD(DAY, 1, @todaysDate) 

SELECT  FT.TITLE, FT.GENRE, PT.SCREEN_NO,
    -- Return the date in UK format DD/MM/YYYY 
    FORMAT (PT.PERFORMANCE_DATE, 'd', 'en-gb' ) "PERFORMANCE_DATE",
    -- Return the time in short format hh:mm
    FORMAT(PT.START_TIME, N'hh\:mm') "START_TIME",
    FORMAT(PT.END_TIME, N'hh\:mm') "END_TIME",
    PT.PRICE,PT.IN_3D
FROM performanceTBL "PT"
INNER JOIN filmsTBL "FT" ON ( PT.FILM_ID=FT.FILM_ID )
WHERE 
  PERFORMANCE_DATE>=@todaysDate
AND 
  PERFORMANCE_DATE<@tomorrowsDate
ORDER BY START_TIME, SCREEN_NO ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getPerformanceDetailsForTomorrow
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for all of tomorrow's performances. 
-- Parameters:     None
--
-- Example usage:  EXECUTE getPerformanceDetailsForTomorrow;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getPerformanceDetailsForTomorrow' ,'P') IS NOT NULL
DROP PROCEDURE getPerformanceDetailsForTomorrow;
GO
CREATE PROCEDURE getPerformanceDetailsForTomorrow
AS
BEGIN
SET NOCOUNT ON;
DECLARE @today DATETIME
DECLARE @tomorrow DATETIME
DECLARE @dayAfterTomorrow DATETIME
SET @today = cast(cast(getdate() as date ) as datetime)
SET @tomorrow = cast(DATEADD(DAY, 1, @today) as datetime) 
SET @dayAfterTomorrow = DATEADD(DAY, 1, @tomorrow)
SELECT  FT.TITLE, FT.GENRE, PT.SCREEN_NO,
    -- Return the date in UK format DD/MM/YYYY 
    FORMAT (PT.PERFORMANCE_DATE, 'd', 'en-gb' ) "PERFORMANCE_DATE",
    -- Return the time in short format hh:mm
    FORMAT(PT.START_TIME, N'hh\:mm') "START_TIME",
    FORMAT(PT.END_TIME, N'hh\:mm') "END_TIME",
    PT.PRICE,PT.IN_3D
FROM performanceTBL "PT"
INNER JOIN filmsTBL "FT" ON ( PT.FILM_ID=FT.FILM_ID )
WHERE 
  PERFORMANCE_DATE>=@tomorrow
AND 
  PERFORMANCE_DATE<@dayAfterTomorrow
ORDER BY START_TIME, SCREEN_NO ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getPerformanceDetailsForDate
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for performances on a specified date. 
-- Parameters:     None
--
-- Example usage:  EXECUTE getPerformanceDetailsForDate '2018-08-22';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getPerformanceDetailsForDate' ,'P') IS NOT NULL
DROP PROCEDURE getPerformanceDetailsForDate;
GO
CREATE PROCEDURE getPerformanceDetailsForDate @DATE DATE
AS
BEGIN
SET NOCOUNT ON;
DECLARE @dayAfter DATETIME
SET @dayAfter = DATEADD(DAY, 1, @DATE) 

SELECT  FT.TITLE, FT.GENRE, PT.SCREEN_NO,
    -- Return the date in UK format DD/MM/YYYY 
    FORMAT (PT.PERFORMANCE_DATE, 'd', 'en-gb' ) "PERFORMANCE_DATE",
    -- Return the time in short format hh:mm
    FORMAT(PT.START_TIME, N'hh\:mm') "START_TIME",
    FORMAT(PT.END_TIME, N'hh\:mm') "END_TIME",
    PT.PRICE,PT.IN_3D
FROM performanceTBL "PT"
INNER JOIN filmsTBL "FT" ON ( PT.FILM_ID=FT.FILM_ID )
WHERE 
  PERFORMANCE_DATE>=@DATE
AND 
  PERFORMANCE_DATE<@dayAfter
ORDER BY START_TIME, SCREEN_NO ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getPerformanceDetailsByFilmTitle
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure returns the performance records for a film specified by title.
-- Parameters:     @FILM_TITLE - The title of a film.
--
-- Example usage:  EXECUTE getPerformanceDetailsByFilmTitle 'Lovely Donuts';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getPerformanceDetailsByFilmTitle' ,'P') IS NOT NULL
DROP PROCEDURE getPerformanceDetailsByFilmTitle;
GO
CREATE PROCEDURE getPerformanceDetailsByFilmTitle @FILM_TITLE VARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
SELECT  FT.TITLE, FT.GENRE, PT.SCREEN_NO,
    -- Return the date in UK format DD/MM/YYYY 
    FORMAT (PT.PERFORMANCE_DATE, 'd', 'en-gb' ) "PERFORMANCE_DATE",
    -- Return the time in short format hh:mm
    FORMAT(PT.START_TIME, N'hh\:mm') "START_TIME",
    FORMAT(PT.END_TIME, N'hh\:mm') "END_TIME",
    PT.PRICE, PT.IN_3D
FROM performanceTBL "PT"
INNER JOIN filmsTBL "FT" ON ( PT.FILM_ID=FT.FILM_ID )
WHERE FT.TITLE=@FILM_TITLE
ORDER BY PT.PERFORMANCE_DATE ASC, PT.START_TIME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getAll3DPerformanceDetails
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for all 3D performances. 
-- Parameters:     None
--
-- Example usage:  EXECUTE getAll3DPerformanceDetails;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAll3DPerformanceDetails' ,'P') IS NOT NULL
DROP PROCEDURE getAll3DPerformanceDetails;
GO
CREATE PROCEDURE getAll3DPerformanceDetails
AS
BEGIN
SET NOCOUNT ON;
SELECT  FT.TITLE, FT.GENRE, PT.SCREEN_NO,
    -- Return the date in UK format DD/MM/YYYY 
    FORMAT (PT.PERFORMANCE_DATE, 'd', 'en-gb' ) "PERFORMANCE_DATE",
    -- Return the time in short format hh:mm
    FORMAT(PT.START_TIME, N'hh\:mm') "START_TIME",
    FORMAT(PT.END_TIME, N'hh\:mm') "END_TIME",
    PT.PRICE,PT.IN_3D
FROM performanceTBL "PT"
INNER JOIN filmsTBL "FT" ON ( PT.FILM_ID=FT.FILM_ID )
WHERE PT.IN_3D=1
ORDER BY PT.PERFORMANCE_DATE ASC, PT.START_TIME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: get3DPerformanceDetailsByDateAndStartTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    This procedure searches for 3D performances on a specified date at a specified time. 
-- Parameters:     @PERFORMANCE_DATE - The date when the performance will take place.
--                 @START_TIME     - The time when the performance will start.
--                 @MINS_DIFF      - How many minutes before or after the start time entered that a 
--                                   performance should start in order to be included into the result set.
--
-- Example usage: EXECUTE get3DPerformanceDetailsByDateAndStartTime '2018-08-22','20:00:00','00:30:00';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('get3DPerformanceDetailsByDateAndStartTime' ,'P') IS NOT NULL
DROP PROCEDURE get3DPerformanceDetailsByDateAndStartTime;
GO
CREATE PROCEDURE get3DPerformanceDetailsByDateAndStartTime  @PERFORMANCE_DATE DATE,
                              @START_TIME TIME,
                              @MINS_DIFF TIME
AS
BEGIN
SET NOCOUNT ON;
SELECT  FT.TITLE, FT.GENRE, PT.SCREEN_NO,
    -- Return the date in UK format DD/MM/YYYY 
    FORMAT (PT.PERFORMANCE_DATE, 'd', 'en-gb' ) "PERFORMANCE_DATE",
    -- Return the time in short format hh:mm
    FORMAT(PT.START_TIME, N'hh\:mm') "START_TIME",
    FORMAT(PT.END_TIME, N'hh\:mm') "END_TIME",
    PT.PRICE,PT.IN_3D
FROM performanceTBL "PT"
INNER JOIN filmsTBL "FT" ON ( PT.FILM_ID=FT.FILM_ID )
WHERE PT.IN_3D=1
AND PERFORMANCE_DATE=@PERFORMANCE_DATE
AND
CAST(START_TIME AS DATETIME) >= (CAST(@START_TIME AS DATETIME) - CAST(@MINS_DIFF AS DATETIME))
AND 
CAST(START_TIME AS DATETIME) <= (CAST(@START_TIME AS DATETIME) + CAST(@MINS_DIFF AS DATETIME))
ORDER BY PT.PERFORMANCE_DATE ASC, PT.SCREEN_NO, PT.START_TIME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNFilmBookingsOfAllTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N films which received the highest number of bookings.
-- Parameters:     @N - The number of films to return.
--
-- Example usage:  EXECUTE getTopNFilmBookingsOfAllTime 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNFilmBookingsOfAllTime' ,'P') IS NOT NULL
DROP PROCEDURE getTopNFilmBookingsOfAllTime;
GO
CREATE PROCEDURE getTopNFilmBookingsOfAllTime @N INT
AS
BEGIN
SET NOCOUNT ON;
SELECT TOP (@N) FILM_ID, 
       TITLE, 
       GENRE, 
       FORMAT(DURATION, N'hh\:mm') AS DURATION, 
       -- get total number of tickets booked for film
       (SELECT dbo.getTotalNoOfTicketsBookedByFilmID(FT.FILM_ID)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, TITLE ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNBookingCustomersOfAllTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N customers who made the highest number of bookings.
-- Parameters:     @N - The number of customers to return.
--
-- Example usage:  EXECUTE getTopNBookingCustomersOfAllTime 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNBookingCustomersOfAllTime' ,'P') IS NOT NULL
DROP PROCEDURE getTopNBookingCustomersOfAllTime;
GO
CREATE PROCEDURE getTopNBookingCustomersOfAllTime @N INT
AS
BEGIN
SET NOCOUNT ON;
SELECT TOP (@N) 
    CUSTOMER_ID,
    FIRSTNAME,
    LASTNAME,
    EMAIL,
    POSTCODE,
    (SELECT dbo.getTotalNoOfTicketsBookedByCustomerID(CT.CUSTOMER_ID)) AS "TOTAL_BOOKINGS" 
FROM customersTBL "CT"
ORDER BY TOTAL_BOOKINGS DESC, LASTNAME ASC, FIRSTNAME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNActorBookingsOfAllTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N actors who received the highest number of bookings.
-- Parameters:     @N - The number of actors to return.
--
-- Example usage:  EXECUTE getTopNActorBookingsOfAllTime 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNActorBookingsOfAllTime' ,'P') IS NOT NULL
DROP PROCEDURE getTopNActorBookingsOfAllTime;
GO
CREATE PROCEDURE getTopNActorBookingsOfAllTime @N INT
AS
BEGIN
SET NOCOUNT ON;

-- DISTINCT TOP() Returns n Unique rows from the top of the results
SELECT DISTINCT TOP (@N) 
     ACTOR_FORENAME,
     ACTOR_SURNAME,
     (SELECT dbo.getTotalNoOfTicketsBookedByActorName(FT.ACTOR_FORENAME, FT.ACTOR_SURNAME)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, ACTOR_SURNAME ASC, ACTOR_FORENAME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNActressBookingsOfAllTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N actresses who received the highest number of bookings.
-- Parameters:     @N - The number of actresses to return.
--
-- Example usage:  EXECUTE getTopNActressBookingsOfAllTime 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNActressBookingsOfAllTime' ,'P') IS NOT NULL
DROP PROCEDURE getTopNActressBookingsOfAllTime;
GO
CREATE PROCEDURE getTopNActressBookingsOfAllTime @N INT
AS
BEGIN
SET NOCOUNT ON;
SELECT DISTINCT TOP (@N) 
     ACTRESS_FORENAME,
     ACTRESS_SURNAME,
     (SELECT dbo.getTotalNoOfTicketsBookedByActressName(FT.ACTRESS_FORENAME, 
                                                        FT.ACTRESS_SURNAME)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, ACTRESS_SURNAME ASC, ACTRESS_FORENAME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNDirectorBookingsOfAllTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N directors who received the highest number of bookings.
-- Parameters:     @N - The number of directors to return.
--
-- Example usage:  EXECUTE getTopNDirectorBookingsOfAllTime 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNDirectorBookingsOfAllTime' ,'P') IS NOT NULL
DROP PROCEDURE getTopNDirectorBookingsOfAllTime;
GO
CREATE PROCEDURE getTopNDirectorBookingsOfAllTime @N INT
AS
BEGIN
SET NOCOUNT ON;
SELECT DISTINCT TOP (@N) 
     DIRECTOR_FORENAME,
     DIRECTOR_SURNAME,
     (SELECT dbo.getTotalNoOfTicketsBookedByDirectorName(FT.DIRECTOR_FORENAME, FT.DIRECTOR_SURNAME)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, DIRECTOR_SURNAME ASC, DIRECTOR_FORENAME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNGenreBookingsOfAllTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N genres which received the highest number of bookings.
-- Parameters:     @N - The number of genres to return.
--
-- Example usage:  EXECUTE getTopNGenreBookingsOfAllTime 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNGenreBookingsOfAllTime' ,'P') IS NOT NULL
DROP PROCEDURE getTopNGenreBookingsOfAllTime;
GO
CREATE PROCEDURE getTopNGenreBookingsOfAllTime @N INT
AS
BEGIN
SET NOCOUNT ON;
SELECT DISTINCT TOP (@N) 
     GENRE, 
     (SELECT dbo.getTotalNoOfTicketsBookedByGenre(FT.GENRE)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, GENRE ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNScreenBookingsOfAllTime
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N screens which received the highest number of bookings.
-- Parameters:     @N - The number of screens to return.
--
-- Example usage:  EXECUTE getTopNScreenBookingsOfAllTime 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNScreenBookingsOfAllTime' ,'P') IS NOT NULL
DROP PROCEDURE getTopNScreenBookingsOfAllTime;
GO
CREATE PROCEDURE getTopNScreenBookingsOfAllTime @N INT
AS
BEGIN
SET NOCOUNT ON;
SELECT DISTINCT PT.SCREEN_NO, 
                (SELECT dbo.getTotalNoOfTicketsBookedByScreenNo(PT.SCREEN_NO)) AS "TOTAL_BOOKINGS" 
from performanceTBL "PT"
ORDER BY TOTAL_BOOKINGS DESC, PT.SCREEN_NO ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNFilmBookingsDuringPeriod
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N films which received the highest number of bookings during 
--                 the specified search period.
-- Parameters:     @N        - The number of films to return.
--                 @MIN_DATE - The start date of the search period.
--                 @MAX_DATE - The finish date of the search period.
--
-- Example usage:  EXECUTE getTopNFilmBookingsDuringPeriod 5, '2018-08-21', '2018-08-23';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNFilmBookingsDuringPeriod' ,'P') IS NOT NULL
DROP PROCEDURE getTopNFilmBookingsDuringPeriod;
GO
CREATE PROCEDURE getTopNFilmBookingsDuringPeriod @N INT, @MIN_DATE DATE, @MAX_DATE DATE
AS
BEGIN
SET NOCOUNT ON;
SELECT TOP (@N) FILM_ID, 
       TITLE, 
       GENRE, 
       FORMAT(DURATION, N'hh\:mm') AS DURATION, 
       (SELECT dbo.getTotalNoOfTicketsBookedByFilmIDDuringPeriod(FT.FILM_ID,@MIN_DATE,@MAX_DATE)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, TITLE ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNBookingCustomersDuringPeriod
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N customers who made the highest number of bookings during 
--                 the specified search period.
-- Parameters:     @N        - The number of customers to return.
--                 @MIN_DATE - The start date of the search period.
--                 @MAX_DATE - The finish date of the search period.
--
-- Example usage: EXECUTE getTopNBookingCustomersDuringPeriod 5, '2018-08-21', '2018-08-23';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNBookingCustomersDuringPeriod' ,'P') IS NOT NULL
DROP PROCEDURE getTopNBookingCustomersDuringPeriod;
GO
CREATE PROCEDURE getTopNBookingCustomersDuringPeriod @N INT, @MIN_DATE DATE, @MAX_DATE DATE
AS
BEGIN
SET NOCOUNT ON;
SELECT TOP (@N) 
    CUSTOMER_ID,
    FIRSTNAME,
    LASTNAME,
    EMAIL,
    POSTCODE,
    (SELECT dbo.getTotalNoOfTicketsBookedByCustomerIDDuringPeriod(CT.CUSTOMER_ID,
                                                                  @MIN_DATE,@MAX_DATE)) AS "TOTAL_BOOKINGS" 
FROM customersTBL "CT"
ORDER BY TOTAL_BOOKINGS DESC, LASTNAME ASC, FIRSTNAME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNGenreBookingsDuringPeriod
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N genres which received the highest number of bookings 
--                 during the specified search period.
-- Parameters:     @N        - The number of genres to return.
--                 @MIN_DATE - The start date of the search period.
--                 @MAX_DATE - The finish date of the search period.
--
-- Example usage:  EXECUTE getTopNGenreBookingsDuringPeriod 5, '2018-08-21', '2018-08-23';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNGenreBookingsDuringPeriod' ,'P') IS NOT NULL
DROP PROCEDURE getTopNGenreBookingsDuringPeriod;
GO
CREATE PROCEDURE getTopNGenreBookingsDuringPeriod @N INT, @MIN_DATE DATE, @MAX_DATE DATE
AS
BEGIN
SET NOCOUNT ON;
SELECT DISTINCT TOP (@N) 
     GENRE, 
     (SELECT dbo.getTotalNoOfTicketsBookedByGenreDuringPeriod(FT.GENRE,@MIN_DATE,@MAX_DATE)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, GENRE ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNScreenBookingsDuringPeriod
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N screens which received the highest number of bookings 
--                 during the specified search period.
-- Parameters:     @N        - The number of screens to return.
--                 @MIN_DATE - The start date of the search period.
--                 @MAX_DATE - The finish date of the search period.
--
-- Example usage:  EXECUTE getTopNScreenBookingsDuringPeriod 5, '2018-08-21', '2018-08-23';
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNScreenBookingsDuringPeriod' ,'P') IS NOT NULL
DROP PROCEDURE getTopNScreenBookingsDuringPeriod;
GO
CREATE PROCEDURE getTopNScreenBookingsDuringPeriod @N INT, @MIN_DATE DATE, @MAX_DATE DATE
AS
BEGIN
SET NOCOUNT ON;
SELECT DISTINCT PT.SCREEN_NO, 
                (SELECT dbo.getTotalNoOfTicketsBookedByScreenNoDuringPeriod(PT.SCREEN_NO,
                                                                 @MIN_DATE, @MAX_DATE)) AS "TOTAL_BOOKINGS" 
from performanceTBL "PT"
ORDER BY TOTAL_BOOKINGS DESC, PT.SCREEN_NO ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNFilmBookingsDuringPreviousWeek
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N films which received the highest number of bookings 
--                 during the previous week.
-- Parameters:     @N - The number of films to return.
--
-- Example usage:  EXECUTE getTopNFilmBookingsDuringPreviousWeek 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNFilmBookingsDuringPreviousWeek' ,'P') IS NOT NULL
DROP PROCEDURE getTopNFilmBookingsDuringPreviousWeek;
GO
CREATE PROCEDURE getTopNFilmBookingsDuringPreviousWeek @N INT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();         -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.
SELECT TOP (@N) FILM_ID, 
       TITLE, 
       GENRE, 
       FORMAT(DURATION, N'hh\:mm') AS DURATION, 
      (SELECT dbo.getTotalNoOfTicketsBookedByFilmIDDuringPeriod(FT.FILM_ID,
                                                                @startDate, @endDate)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, TITLE ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNBookingCustomersDuringPreviousWeek
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N customers who made the highest number of bookings 
--                 during the previous week.
-- Parameters:     @N - The number of customers to return.
--
-- Example usage:  EXECUTE getTopNBookingCustomersDuringPreviousWeek 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNBookingCustomersDuringPreviousWeek' ,'P') IS NOT NULL
DROP PROCEDURE getTopNBookingCustomersDuringPreviousWeek;
GO
CREATE PROCEDURE getTopNBookingCustomersDuringPreviousWeek @N INT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();                   -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.
SELECT TOP (@N) 
       CUSTOMER_ID,
       FIRSTNAME,
       LASTNAME,
       EMAIL,
       POSTCODE,
       (SELECT dbo.getTotalNoOfTicketsBookedByCustomerIDDuringPeriod(CT.CUSTOMER_ID,
                                                         @startDate, @endDate)) AS "TOTAL_BOOKINGS" 
FROM customersTBL "CT"
ORDER BY TOTAL_BOOKINGS DESC, LASTNAME ASC, FIRSTNAME ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNGenreBookingsDuringPreviousWeek
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N genres which received the highest number of bookings 
--                 during the previous week.
-- Parameters:     @N - The number of genres to return.
--
-- Example usage:  EXECUTE getTopNGenreBookingsDuringPreviousWeek 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNGenreBookingsDuringPreviousWeek' ,'P') IS NOT NULL
DROP PROCEDURE getTopNGenreBookingsDuringPreviousWeek;
GO
CREATE PROCEDURE getTopNGenreBookingsDuringPreviousWeek @N INT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();                   -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.
SELECT DISTINCT TOP (@N) 
     GENRE, 
     (SELECT dbo.getTotalNoOfTicketsBookedByGenreDuringPeriod(FT.GENRE,
                                                  @startDate, @endDate)) AS "TOTAL_BOOKINGS" 
FROM filmsTBL "FT"
ORDER BY TOTAL_BOOKINGS DESC, GENRE ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Procedure Name: getTopNScreenBookingsDuringPreviousWeek
-- Author:         Andrew Laing
-- Last updated:   03/01/2019
-- Description:    Selects the top N screens which received the highest number of bookings
--                 during the previous week.
-- Parameters:     @N - The number of screens to return.
--
-- Example usage:  EXECUTE getTopNScreenBookingsDuringPreviousWeek 5;
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getTopNScreenBookingsDuringPreviousWeek' ,'P') IS NOT NULL
DROP PROCEDURE getTopNScreenBookingsDuringPreviousWeek;
GO
CREATE PROCEDURE getTopNScreenBookingsDuringPreviousWeek @N INT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @startDate DATETIME;
DECLARE @endDate DATETIME;
SET @endDate = GETDATE();                   -- set end date as today.
SET @startDate = DATEADD(DAY, -7, @EndDate) -- set start date as today minus 7 days.
SELECT DISTINCT PT.SCREEN_NO, 
                (SELECT dbo.getTotalNoOfTicketsBookedByScreenNoDuringPeriod(PT.SCREEN_NO,
                                                                @startDate, @endDate)) AS "TOTAL_BOOKINGS" 
from performanceTBL "PT"
ORDER BY TOTAL_BOOKINGS DESC, SCREEN_NO ASC
END;
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAll3DPerformanceIDs
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns all 3D performance IDs stored within performanceTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAll3DPerformanceIDs();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAll3DPerformanceIDs' ,'FN') IS NOT NULL
DROP FUNCTION getAll3DPerformanceIDs;
GO
CREATE FUNCTION getAll3DPerformanceIDs ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT PERFORMANCE_ID from performanceTBL
  WHERE IN_3D=1
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllBookingIDs
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns all booking IDs stored within bookingsTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM getAllBookingIDs();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllBookingIDs' ,'FN') IS NOT NULL
DROP FUNCTION getAllBookingIDs;
GO
CREATE FUNCTION getAllBookingIDs ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT BOOKING_ID from bookingsTBL
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllCustomerIDs
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns all customer IDs stored within customersTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAllCustomerIDs();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllCustomerIDs' ,'FN') IS NOT NULL
DROP FUNCTION getAllCustomerIDs;
GO
CREATE FUNCTION getAllCustomerIDs ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT CUSTOMER_ID from customersTBL
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllActorNames
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns actor names within filmsTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAllActorNames();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllActorNames' ,'FN') IS NOT NULL
DROP FUNCTION getAllActorNames;
GO
CREATE FUNCTION getAllActorNames ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT ACTOR_FORENAME,ACTOR_SURNAME from filmsTBL
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllActressNames
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns actress names within filmsTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAllActressNames();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllActressNames' ,'FN') IS NOT NULL
DROP FUNCTION getAllActressNames;
GO
CREATE FUNCTION getAllActressNames ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT ACTRESS_FORENAME,ACTRESS_SURNAME from filmsTBL
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllDirectorNames
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns directors within filmsTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAllDirectorNames();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllDirectorNames' ,'FN') IS NOT NULL
DROP FUNCTION getAllDirectorNames;
GO
CREATE FUNCTION getAllDirectorNames ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT DIRECTOR_FORENAME,DIRECTOR_SURNAME from filmsTBL
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllFilmGenres
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns all genres used within filmsTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAllFilmGenres();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllFilmGenres' ,'FN') IS NOT NULL
DROP FUNCTION getAllFilmGenres;
GO
CREATE FUNCTION getAllFilmGenres ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT GENRE from filmsTBL
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllFilmIDs
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns all film IDs stored within filmsTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAllFilmIDs();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllFilmIDs' ,'FN') IS NOT NULL
DROP FUNCTION getAllFilmIDs;
GO
CREATE FUNCTION getAllFilmIDs ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT FILM_ID from filmsTBL
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllFilmTitles
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns all film titles stored within filmsTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAllFilmTitles();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllFilmTitles' ,'FN') IS NOT NULL
DROP FUNCTION getAllFilmTitles;
GO
CREATE FUNCTION getAllFilmTitles ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT TITLE from filmsTBL
);
GO

-- ----------------------------------------------------------------------------
-- Function Name: getAllPerformanceIDs
-- Author:        Andrew Laing
-- Last updated:  03/01/2019
-- Description:   This function returns all performance IDs stored within performanceTBL.
-- Parameters:    None
--
-- Example usage: SELECT * FROM dbo.getAllPerformanceIDs();
-- ----------------------------------------------------------------------------
IF OBJECT_ID('getAllPerformanceIDs' ,'FN') IS NOT NULL
DROP FUNCTION getAllPerformanceIDs;
GO
CREATE FUNCTION getAllPerformanceIDs ( )
RETURNS TABLE
AS
RETURN 
(
  SELECT DISTINCT PERFORMANCE_ID from performanceTBL
);
GO

PRINT 'Database creation finished.'

SET NOEXEC OFF    -- Reset NOEXEC if the script was stopped because the DB already exists
