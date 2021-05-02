CREATE OR REPLACE TYPE platform1 AS OBJECT (
PLATFORM VARCHAR2(26 BYTE)
);

CREATE OR REPLACE TYPE platform2 AS OBJECT (
GENRE VARCHAR2(26 BYTE)
);

CREATE OR REPLACE TYPE platform3 AS OBJECT (
PUBLISHER VARCHAR2(128 BYTE)
);

CREATE OR REPLACE TYPE platform_tbl1 IS TABLE OF  platform1
CREATE OR REPLACE TYPE platform_tbl2 IS TABLE OF  platform2
CREATE OR REPLACE TYPE platform_tbl3 IS TABLE OF  platform3

CREATE OR REPLACE TYPE platform AS OBJECT (
GAME_ID NUMBER(38,0),
NAME VARCHAR2(128 BYTE),
PLATFORM VARCHAR2(26 BYTE),
YEAR NUMBER(38,0),
GENRE VARCHAR2(26 BYTE),
PUBLISHER VARCHAR2(128 BYTE),
NA_SALES NUMBER(26,5),
EU_SALES NUMBER(26,5),
JP_SALES NUMBER(26,5), 
OTHER_SALES NUMBER(26,5),
GLOBAL_SALES NUMBER(26,5)
);

CREATE OR REPLACE TYPE platform_tbl IS TABLE OF  platform


CREATE OR REPLACE PACKAGE proc_pack AS
PROCEDURE list;

PROCEDURE game_insert
 (
    GAME_ID IN GAMES.GAME_ID%TYPE, 
    NAME IN GAMES.NAME%TYPE, 
    PLATFORM IN GAMES.PLATFORM%TYPE, 
    YEAR IN GAMES.YEAR%TYPE, 
    GENRE IN GAMES.GENRE%TYPE, 
    PUBLISHER IN GAMES.PUBLISHER%TYPE, 
    NA_SALES IN GAMES.NA_SALES%TYPE, 
    EU_SALES IN GAMES.EU_SALES%TYPE, 
    JP_SALES IN GAMES.JP_SALES%TYPE, 
    OTHER_SALES IN GAMES.OTHER_SALES%TYPE,
    GLOBAL_SALES IN GAMES.GLOBAL_SALES%TYPE,
    IMAGES IN GAMES.IMAGES%TYPE
 );
PROCEDURE game_delete(v_GAME_ID IN GAMES.GAME_ID%TYPE);
PROCEDURE game_update 
(
    v_GAME_ID IN GAMES.GAME_ID%TYPE, 
    v_NAME IN GAMES.NAME%TYPE, 
    v_PLATFORM IN GAMES.PLATFORM%TYPE, 
    v_YEAR IN GAMES.YEAR%TYPE, 
    v_GENRE IN GAMES.GENRE%TYPE, 
    v_PUBLISHER IN GAMES.PUBLISHER%TYPE, 
    v_NA_SALES IN GAMES.NA_SALES%TYPE,
    v_EU_SALES IN GAMES.EU_SALES%TYPE,
    v_JP_SALES IN GAMES.JP_SALES%TYPE, 
    v_OTHER_SALES IN GAMES.OTHER_SALES%TYPE,
    v_GLOBAL_SALES IN GAMES.GLOBAL_SALES%TYPE,
    v_IMAGES IN GAMES.IMAGES%TYPE
);
PROCEDURE game_info(
    v_rank NUMBER 
);
END proc_pack;
/

CREATE OR REPLACE PACKAGE body proc_pack AS
PROCEDURE list IS

   CURSOR cur is 
      select DISTINCT YEAR from GAMES; 
   TYPE col IS TABLE of GAMES.YEAR%type INDEX BY binary_integer; 
   main_t col; 
   counter integer :=0; 
BEGIN 
   FOR i IN cur LOOP 
      counter := counter +1; 
      main_t(counter) := i.YEAR; 
      dbms_output.put_line('Years('||counter||'):'||main_t(counter)); 
   END LOOP; 
END;
PROCEDURE game_insert
 (
    GAME_ID IN GAMES.GAME_ID%TYPE, 
    NAME IN GAMES.NAME%TYPE, 
    PLATFORM IN GAMES.PLATFORM%TYPE, 
    YEAR IN GAMES.YEAR%TYPE, 
    GENRE IN GAMES.GENRE%TYPE, 
    PUBLISHER IN GAMES.PUBLISHER%TYPE, 
    NA_SALES IN GAMES.NA_SALES%TYPE, 
    EU_SALES IN GAMES.EU_SALES%TYPE, 
    JP_SALES IN GAMES.JP_SALES%TYPE, 
    OTHER_SALES IN GAMES.OTHER_SALES%TYPE,
    GLOBAL_SALES IN GAMES.GLOBAL_SALES%TYPE,
    IMAGES IN GAMES.IMAGES%TYPE
 )
IS 
BEGIN  
INSERT INTO GAMES
    (                    
    GAME_ID, 
    NAME, 
    PLATFORM, 
    YEAR, 
    GENRE, 
    PUBLISHER, 
    NA_SALES, 
    EU_SALES, 
    JP_SALES, 
    OTHER_SALES,
    GLOBAL_SALES,
    IMAGES
    ) 
     VALUES 
    ( 
    GAME_ID, 
    NAME, 
    PLATFORM, 
    YEAR, 
    GENRE, 
    PUBLISHER, 
    NA_SALES, 
    EU_SALES, 
    JP_SALES, 
    OTHER_SALES,
    GLOBAL_SALES,
    IMAGES
    );
commit;
END;

PROCEDURE game_delete(v_GAME_ID IN GAMES.GAME_ID%TYPE)
IS
BEGIN
  DELETE GAMES where GAME_ID = v_GAME_ID;
  COMMIT;
END;

PROCEDURE game_update 
(
    v_GAME_ID IN GAMES.GAME_ID%TYPE, 
    v_NAME IN GAMES.NAME%TYPE, 
    v_PLATFORM IN GAMES.PLATFORM%TYPE, 
    v_YEAR IN GAMES.YEAR%TYPE, 
    v_GENRE IN GAMES.GENRE%TYPE, 
    v_PUBLISHER IN GAMES.PUBLISHER%TYPE, 
    v_NA_SALES IN GAMES.NA_SALES%TYPE,
    v_EU_SALES IN GAMES.EU_SALES%TYPE,
    v_JP_SALES IN GAMES.JP_SALES%TYPE, 
    v_OTHER_SALES IN GAMES.OTHER_SALES%TYPE,
    v_GLOBAL_SALES IN GAMES.GLOBAL_SALES%TYPE,
    v_IMAGES IN GAMES.IMAGES
)
IS
BEGIN
    UPDATE GAMES SET 
    NAME = v_NAME, 
    PLATFORM = v_PLATFORM, 
    YEAR = v_YEAR, 
    GENRE = v_GENRE, 
    PUBLISHER = v_PUBLISHER, 
    NA_SALES = v_NA_SALES, 
    EU_SALES = v_EU_SALES, 
    JP_SALES = v_JP_SALES, 
    OTHER_SALES = v_OTHER_SALES,
    GLOBAL_SALES = v_GLOBAL_SALES,
    IMAGES = v_IMAGES
  where GAME_ID = v_GAME_ID;
  COMMIT;
END;
PROCEDURE game_info(
    v_rank NUMBER 
)
IS
  v_game GAMES%ROWTYPE;
BEGIN
  -- get contact based on customer id
  SELECT *
  INTO v_game
  FROM GAMES
  WHERE GAME_ID = v_rank;

  -- print out contact's information
  dbms_output.put_line('Game: ' || v_game.name || ' platform ' ||
  v_game.platform || ' release ' || v_game.year);

EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line( SQLERRM );
END;
END proc_pack;
/


CREATE OR REPLACE PACKAGE func_pack AS
FUNCTION f_platform 
RETURN platform_tbl1;
FUNCTION f_genre
RETURN platform_tbl2;
FUNCTION f_PUBLISHER
RETURN platform_tbl3;
FUNCTION f_all
RETURN platform_tbl;
END func_pack;


CREATE OR REPLACE Package body func_pack AS
FUNCTION f_platform 
RETURN platform_tbl1
IS
CURSOR curs is
    SELECT DISTINCT PLATFORM
    FROM Games;
  --  GROUP BY PLATFORM; 
--v_PLATFORM VARCHAR2(26 BYTE); 
v_tbl platform_tbl1 := platform_tbl1();
BEGIN
FOR i IN curs LOOP
v_tbl.EXTEND();
EXIT WHEN curs%NOTFOUND;
      v_tbl(v_tbl.count):= platform1(null);
      v_tbl(v_tbl.count).PLATFORM := i.PLATFORM;
--SELECT PLATFORM INTO v_PLATFORM FROM Games;
--v_tbl(1) := platform1(v_PLATFORM);
END LOOP; 
RETURN v_tbl;
END;

FUNCTION f_genre
RETURN platform_tbl2 
IS
CURSOR curs is
    SELECT DISTINCT GENRE
    FROM Games;
  --  GROUP BY PLATFORM; 
--v_PLATFORM VARCHAR2(26 BYTE); 
v_tbl platform_tbl2 := platform_tbl2();
BEGIN
FOR i IN curs LOOP
v_tbl.EXTEND();
EXIT WHEN curs%NOTFOUND;
      v_tbl(v_tbl.count):= platform2( null);
      v_tbl(v_tbl.count).GENRE := i.GENRE;
--SELECT PLATFORM INTO v_PLATFORM FROM Games;
--v_tbl(1) := platform1(v_PLATFORM);
END LOOP; 
RETURN v_tbl;
END;

FUNCTION f_PUBLISHER
RETURN platform_tbl3 
IS
CURSOR curs is
    SELECT DISTINCT PUBLISHER
    FROM Games;
  --  GROUP BY PLATFORM; 
--v_PLATFORM VARCHAR2(26 BYTE); 
v_tbl platform_tbl3 := platform_tbl3();
BEGIN
FOR i IN curs LOOP
v_tbl.EXTEND();
EXIT WHEN curs%NOTFOUND;
      v_tbl(v_tbl.count):= platform3(null);
      v_tbl(v_tbl.count).PUBLISHER := i.PUBLISHER;
--SELECT PLATFORM INTO v_PLATFORM FROM Games;
--v_tbl(1) := platform1(v_PLATFORM);
END LOOP; 
RETURN v_tbl;
END;

FUNCTION f_all
RETURN platform_tbl 
IS
CURSOR curs is
    SELECT *
    FROM Games;
  --  GROUP BY PLATFORM; 
--v_PLATFORM VARCHAR2(26 BYTE); 
v_tbl platform_tbl := platform_tbl();
BEGIN
FOR i IN curs LOOP
v_tbl.EXTEND();
EXIT WHEN curs%NOTFOUND;
      v_tbl(v_tbl.count):= platform(null,null,null,null,null,null,null,null,null,null,null );
      v_tbl(v_tbl.count).GAME_ID := i.GAME_ID;
      v_tbl(v_tbl.count).NAME := i.NAME;
      v_tbl(v_tbl.count).YEAR := i.YEAR;
      v_tbl(v_tbl.count).GENRE := i.GENRE;
      v_tbl(v_tbl.count).PUBLISHER := i.PUBLISHER;
      v_tbl(v_tbl.count).NA_SALES := i.NA_SALES;
      v_tbl(v_tbl.count).EU_SALES := i.EU_SALES;
      v_tbl(v_tbl.count).JP_SALES := i.JP_SALES;
      v_tbl(v_tbl.count).OTHER_SALES := i.OTHER_SALES;
      v_tbl(v_tbl.count).GLOBAL_SALES := i.GLOBAL_SALES;
      
      
--SELECT PLATFORM INTO v_PLATFORM FROM Games;
--v_tbl(1) := platform1(v_PLATFORM);
END LOOP; 
RETURN v_tbl;
END;
END func_pack;

--Auto increment
--1
create sequence GAME_ID start with 1 increment by 1 nomaxvalue;

--2
UPDATE GAMES
   SET GAME_ID = GAME_ID.nextval;

--3
ALTER TABLE GAMES
  ADD CONSTRAINT GAMES PRIMARY KEY( GAME_ID )

--4
  CREATE TRIGGER auto_incr
  BEFORE INSERT ON GAMES
  FOR EACH ROW
BEGIN
  :new.GAME_ID := GAME_ID.nextval;
END;
--End auto increment

select * from TABLE(f_platform())
select * from TABLE(f_genre())
select * from TABLE(f_PUBLISHER())
select * from TABLE(f_all())