--Start procedure

CREATE OR REPLACE PROCEDURE game_insert
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
--End insert procedure

/*Create a stored procedure to update country into a table*/
CREATE OR REPLACE PROCEDURE game_update 
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
    v_IMAGES IN GAMES.v_IMAGES%TYPE
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
--End update

/*Create a stored procedure to delete country into a table*/
CREATE OR REPLACE PROCEDURE game_delete(V_GAME_ID IN GAMES.GAME_ID%TYPE)
IS
BEGIN
  DELETE GAMES where game_id = v_GAME_ID;
  COMMIT;
END;
--End delete procedure

/*Create a stored procedure to print info about game*/
CREATE OR REPLACE PROCEDURE game_info(
    v_GAME_ID NUMBER 
)
IS
  v_game GAMES%ROWTYPE;
BEGIN
  -- get contact based on customer id
  SELECT *
  INTO v_game
  FROM GAMES
  WHERE GAME_ID = v_GAME_ID;

  -- print out contact's information
  dbms_output.put_line('Game: ' || v_game.name || ' platform ' ||
  v_game.platform || ' release ' || v_game.year);

EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line( SQLERRM );
END;
--End procedures

SET SERVEROUTPUT ON;
EXEC game_info(100);