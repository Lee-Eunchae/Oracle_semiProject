
----------------------[PRC_PROFESSOR_INSERT] 프로시저----------------------
create or replace PROCEDURE PRC_PROFESSOR_INSERT    -- 교수입력 프로시저
(
V_P_ID IN TBL_PROFESSOR.P_ID%TYPE                   -- 교수자 ID
,V_P_NAME IN TBL_PROFESSOR.P_NAME%TYPE              -- 교수자 이름
,V_P_SSN IN TBL_PROFESSOR.P_SSN%TYPE                -- 교수자 주민번호
)
IS

V_P_PW  TBL_PROFESSOR.P_PW%TYPE;

BEGIN

    V_P_PW :=V_P_SSN;

    INSERT INTO TBL_PROFESSOR
    VALUES(V_P_ID,V_P_PW,V_P_NAME,V_P_SSN);

    COMMIT;
END;
--==>> Procedure PRC_PROFESSOR_INSERT이(가) 컴파일되었습니다.
-----------------------------------------------------------------------------
----------------------[PRC_BOOK] 프로시저--------------------------
CREATE OR REPLACE PROCEDURE PRC_BOOK        -- 관리자 BOOK 등록 프로시저
(
 V_NAME IN TBL_TEXTBOOK.T_NAME%TYPE         --교재명
,V_PUB  IN TBL_TEXTBOOK.T_PUB%TYPE          --출판사
)
IS

 V_CODE TBL_TEXTBOOK.T_CODE%TYPE;

BEGIN

    SELECT NVL(MAX(T_CODE) , 0 )            --교재코드번호 COUNT 자동 증가 
    INTO V_CODE
    FROM TBL_TEXTBOOK;
    
    INSERT INTO TBL_TEXTBOOK(T_CODE,T_NAME,T_PUB)   
    VALUES (V_CODE+1  , V_NAME , V_PUB);

END;
--==>> Procedure PRC_BOOK이(가) 컴파일되었습니다.
-------------------------------------------------------------------
----------------------[PRC_ADMIN_COURSE_INSERT] 프로시저-----------------------

create or replace PROCEDURE PRC_ADMIN_COURSE_INSERT     -- 과정등록 프로시저
(
    V_A_C_NAME IN TBL_COURSE.C_NAME%TYPE    -- 과정 이름
)
IS
    V_A_CODE TBL_COURSE.C_CODE%TYPE;        -- 과정코드

BEGIN
    -- 순차적으로 부여될 과정 코드
    SELECT NVL(MAX(C_CODE) , 0 ) INTO V_A_CODE  
    FROM TBL_COURSE;

    -- INSERT 구문
    INSERT INTO TBL_COURSE(C_CODE,C_NAME)       
    VALUES(V_A_CODE +1 , V_A_C_NAME);

    COMMIT;

END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
--[PRC_ADMIN_COURSE_INSERT] 프로시저 확인

EXEC PRC_ADMIN_COURSE_INSERT('SARANGNI');
--==>> Procedure PRC_ADMIN_COURSE_INSERT이(가) 컴파일되었습니다.
SELECT *
FROM TBL_COURSE;
--==>> 7   SARANGNI
-------------------------------------------------------------------------------
----------------------[PRC_ADMIN_CLASSROOM_INSERT] 프로시저 ----------------------
create or replace PROCEDURE  PRC_ADMIN_CLASSROOM_INSERT     -- 강의실 등록 프로시저
(  V_CR_LOC IN TBL_CLASSROOM.CR_LOC%TYPE
 , V_CR_CAPA IN TBL_CLASSROOM.CR_CAPA%TYPE
)
IS
    V_CR_CODE TBL_CLASSROOM.CR_CODE%TYPE;

BEGIN
    SELECT NVL(MAX(CR_CODE),0) INTO V_CR_CODE FROM TBL_CLASSROOM;

    INSERT INTO TBL_CLASSROOM(CR_CODE,CR_LOC,CR_CAPA)
    VALUES(V_CR_CODE+1,V_CR_LOC,V_CR_CAPA);
END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
--[PRC_ADMIN_CLASSROOM_INSERT] 프로시저 확인

-- 새로운 강의장 이름, 정원 입력
EXEC PRC_ADMIN_CLASSROOM_INSERT('G',45);
--==>> Procedure PRC_ADMIN_CLASSROOM_INSERT이(가) 컴파일되었습니다.

SELECT *
FROM TBL_CLASSROOM;
--==>> 4   G   45
-------------------------------------------------------------------------------
----------------------[PRC_STUDENT_INSERT] 프로시저 ----------------------

create or replace PROCEDURE PRC_STUDENT_INSERT
(
   V_S_ID IN TBL_STUDENT.S_ID%TYPE
 , V_S_NAME IN TBL_STUDENT.S_NAME%TYPE
 , V_S_SSN IN TBL_STUDENT.S_SSN%TYPE
)
IS

    V_S_PW  TBL_STUDENT.S_PW%TYPE;

BEGIN

    V_S_PW :=V_S_SSN;

    INSERT INTO TBL_STUDENT
    VALUES(V_S_ID,V_S_PW,V_S_NAME,V_S_SSN);

    COMMIT;
END;
--==>> Procedure PRC_STUDENT_INSERT이(가) 컴파일되었습니다.
--------------------------------------------------------------------------
----------------------[PRC_SUBJECT_INSERT] 프로시저 ----------------------
create or replace PROCEDURE PRC_SUBJECT_INSERT
 ( V_S_NAME  IN TBL_SUBJECT.S_NAME%TYPE
 )
 IS
    V_S_CODE TBL_SUBJECT.S_CODE%TYPE;
 BEGIN
    SELECT NVL(MAX(S_CODE), 0) + 1 INTO V_S_CODE
    FROM TBL_SUBJECT;

    INSERT INTO TBL_SUBJECT(S_CODE, S_NAME) VALUES (V_S_CODE, V_S_NAME);
 END;
 --==>> Procedure PRC_SUBJECT_INSERT이(가) 컴파일되었습니다.
 --------------------------------------------------------------------------
 ----------------------[PRC_ADMIN_C_O_INSERT] 프로시저---------------------
create or replace PROCEDURE PRC_ADMIN_C_O_INSERT    -- 과정등록 프로시저
(V_C_NAME       TBL_COURSE.C_NAME%TYPE          -- 과정명
,V_C_O_START    TBL_COURSE_OPEN.C_O_START%TYPE  -- 과정 시작날짜
,V_C_O_END      TBL_COURSE_OPEN.C_O_END%TYPE    -- 과정 끝난날짜
,V_CR_LOC       TBL_CLASSROOM.CR_LOC%TYPE       -- 강의실 위치
)
IS
    V_C_O_CODE  TBL_COURSE_OPEN.C_O_CODE%TYPE;  -- 개설과정코드
    V_C_CODE    TBL_COURSE.C_CODE%TYPE;         -- 과정코드
    V_CR_CODE   TBL_CLASSROOM.CR_CODE%TYPE;     -- 강의실 코드

BEGIN
    -- 과정개설 테이블에서 개설과정코드를 1씩증가하여 V_C_O_CODE 에 INTO
    SELECT NVL(MAX(C_O_CODE),0) + 1 INTO V_C_O_CODE 
    FROM TBL_COURSE_OPEN;

    -- 과정 테이블에서 과정명이 입력 파라미터 값과 같을때 V_C_CODE 에 INTO
    SELECT C_CODE INTO V_C_CODE
    FROM TBL_COURSE
    WHERE C_NAME = V_C_NAME;

    -- 강의실 테이블에서 강의실 위치가 입력 파라미터와 같을 때 INTO
    SELECT CR_CODE INTO V_CR_CODE
    FROM TBL_CLASSROOM
    WHERE CR_LOC = V_CR_LOC;

    -- INSERT INTO 
    INSERT INTO TBL_COURSE_OPEN(C_O_CODE, C_CODE, CR_CODE, C_O_START, C_O_END)
    VALUES (V_C_O_CODE, V_C_CODE, V_CR_CODE, V_C_O_START, V_C_O_END);

    COMMIT;

        EXCEPTION
        WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('오류!오류!');
                ROLLBACK;

END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
--------------------------------------------------------------------------------
 ----------------------[PRC_ADMIN_S_O_INSERT] 프로시저--------------------------
create or replace PROCEDURE PRC_ADMIN_S_O_INSERT    -- 과목 개설 프로시저
(V_C_O_CODE     IN TBL_COURSE_OPEN.C_O_CODE%TYPE    -- 개설 과정 코드
,V_S_NAME      IN TBL_SUBJECT.S_NAME%TYPE           -- 과목명
,V_S_O_START  IN  TBL_SUBJECT_OPEN.S_O_START%TYPE   -- 과목 시작 기간
,V_S_O_END    IN  TBL_SUBJECT_OPEN.S_O_END%TYPE     -- 과목 끝난 기간
,V_T_NAME     IN  TBL_TEXTBOOK.T_NAME%TYPE          -- 교재명
,V_P_NAME     IN  TBL_PROFESSOR.P_NAME%TYPE         -- 교수명
)
IS
    V_S_O_CODE          TBL_SUBJECT_OPEN.S_O_CODE%TYPE; 
    V_P_ID              TBL_PROFESSOR.P_ID%TYPE;        
    V_S_CODE            TBL_SUBJECT.S_CODE%TYPE;        --과목번호
    V_T_CODE            TBL_TEXTBOOK.T_CODE%TYPE;       --교재코드 데이터 네임
    V_C_CODE            TBL_COURSE.C_CODE%TYPE;
    V_CR_CODE           TBL_CLASSROOM.CR_CODE%TYPE;     --강의실 코드 데이터 타입
    USER_DEFINE_ERROR    EXCEPTION;
BEGIN


    SELECT NVL(MAX(S_O_CODE),0) + 1 INTO V_S_O_CODE
    FROM TBL_SUBJECT_OPEN;


    SELECT P_ID INTO V_P_ID
    FROM TBL_PROFESSOR
    WHERE P_NAME = V_P_NAME;

    SELECT S_CODE INTO V_S_CODE
    FROM TBL_SUBJECT
    WHERE S_NAME = V_S_NAME;

    SELECT T_CODE INTO V_T_CODE
    FROM TBL_TEXTBOOK
    WHERE T_NAME = V_T_NAME;

    INSERT INTO TBL_SUBJECT_OPEN(S_O_CODE, C_O_CODE, P_ID, S_CODE, T_CODE, S_O_START, S_O_END)
    VALUES (V_S_O_CODE, V_C_O_CODE, V_P_ID, V_S_CODE, V_T_CODE, V_S_O_START, V_S_O_END);

    COMMIT;

END;
--==>> Procedure PRC_ADMIN_S_O_INSERT이(가) 컴파일되었습니다.
-------------------------------------------------------------------------------------------------
----------------------[PRC_SET_POINT] 프로시저---------------------

create or replace PROCEDURE PRC_SET_POINT           -- 점수 SET 프로시저
(V_S_O_CODE     TBL_SUBJECT_OPEN.S_O_CODE%TYPE      --과목 개설의 개설번호를 입력받는다.
,V_S_O_WPO      TBL_SUBJECT_OPEN.S_O_WPO%TYPE       --필기 점수를 입력받는다.
,V_S_O_SPO      TBL_SUBJECT_OPEN.S_O_SPO%TYPE       --실기 점수를 입력받는다.
,V_S_O_APO      TBL_SUBJECT_OPEN.S_O_WPO%TYPE       --출결 점수를 입력받는다.
)
IS
BEGIN
    UPDATE TBL_SUBJECT_OPEN
    SET S_O_WPO = V_S_O_WPO, S_O_APO = V_S_O_APO, S_O_SPO = V_S_O_SPO
    WHERE S_O_CODE = V_S_O_CODE;
    -- 과목개설의 개설번호가 같을때 점수들을 SET시켜준다.
    
    EXCEPTION
    WHEN OTHERS
    THEN DBMS_OUTPUT.PUT_LINE('오류!오류!');
            ROLLBACK;

    COMMIT;
END;
--==>> Procedure PRC_PRO_PRINT이(가) 컴파일되었습니다.
-------------------------------------------------------------------
----------------------[PRC_COURSE_REG_INSERT] 프로시저 ----------------------
create or replace PROCEDURE PRC_COURSE_REG_INSERT       -- 수강신청 프로시저
( 
     V_S_ID     IN TBL_STUDENT.S_ID%TYPE                       --학생아이디
    ,V_C_O_CODE IN TBL_COURSE_REGISTRATION.C_O_CODE%TYPE       --개설과정코드
)
IS
    V_C_R_CODE  TBL_COURSE_REGISTRATION.C_R_CODE%TYPE;
BEGIN
    -- 수강신청 코드의 최대값을 수강신청코드에 INTO
    SELECT NVL(MAX(C_R_CODE), 0) + 1 INTO V_C_R_CODE
    FROM TBL_COURSE_REGISTRATION;

    INSERT INTO TBL_COURSE_REGISTRATION(C_R_CODE, S_ID, C_O_CODE)
    VALUES (V_C_R_CODE, V_S_ID, V_C_O_CODE);


END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.


-------------------------------------------------------------------
----------------------[PRC_ADMIN_UPDATE] 프로시저--------------------------------
CREATE OR REPLACE PROCEDURE PRC_ADMIN_UPDATE		-- 관리자 업데이트 프로시저
( V_A_ID     IN TBL_ADMIN.A_ID%TYPE		-- 관리자 ID
, V_A_PW    IN TBL_ADMIN.A_PW%TYPE		-- 관리자 PASSWORD
)
IS
BEGIN
        UPDATE TBL_ADMIN
        SET       A_PW = V_A_PW
        WHERE A_ID = V_A_ID
            AND A_PW = V_A_PW;

        --커밋!
        COMMIT;

       EXCEPTION 
       WHEN OTHERS
            THEN DBMS_OUTPUT.PUT_LINE('입력이 잘못되었어요!');        
                     ROLLBACK;   
END;

--==>> Procedure PRC_ADMIN_UPDATE이(가) 컴파일되었습니다.


--------------------[PRC_CLASSROOM_NO_UPDATE] 프로시저-----------------------------------------
CREATE OR REPLACE PROCEDURE PRC_CLASSROOM_NO_UPDATE
( V_CR_CODE    IN TBL_CLASSROOM.CR_CODE%TYPE	-- 강의실 코드
, V_CR_LOC     IN TBL_CLASSROOM.CR_LOC%TYPE	-- 강의실 위치
, V2_CR_LOC    IN TBL_CLASSROOM.CR_LOC%TYPE     -- 2차확인용 강의실번호
)
IS
    USER_DEFINE_ERROR       EXCEPTION;
BEGIN
    IF V_CR_LOC != V2_CR_LOC
        THEN RAISE USER_DEFINE_ERROR;    
    END IF;

    UPDATE TBL_CLASSROOM
    SET CR_LOC = V_CR_LOC
    WHERE CR_CODE = V_CR_CODE;

    --커밋!
    COMMIT;

    EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20030, '강의실위치가 서로 일치하지 않아요!');
END;

--==>> Procedure PRC_CLASSROOM_NO_UPDATE이(가) 컴파일되었습니다.


---------------------[PRC_COURSENAME_UPDATE] 프로시저------------------------------------
CREATE OR REPLACE PROCEDURE PRC_COURSENAME_UPDATE
(V_C_CODE      IN TBL_COURSE.C_CODE%TYPE	-- 과정번호를 받는 파라미터
,V_C_NAME      IN TBL_COURSE.C_NAME%TYPE	-- 바꿀 과정명을 받는 파라미터
)
IS
BEGIN

    UPDATE TBL_COURSE
    SET C_NAME = V_C_NAME			-- 과정명을 입력값으로 바꿔주기!
    WHERE C_CODE =V_C_CODE;			-- 일치하는 과정번호가 있을때..

    --커밋!
    COMMIT;

    EXCEPTION 
       WHEN OTHERS
            THEN RAISE_APPLICATION_ERROR(-20011, '입력이 잘못되었어요!');        
                 ROLLBACK;     

END;

--==>> Procedure PRC_COURSENAME_UPDATE이(가) 컴파일되었습니다.


------------------------[PRC_COURSETIME_UPDATE]---------------------------------------------------

create or replace PROCEDURE PRC_COURSETIME_UPDATE
( V_C_O_CODE    IN TBL_COURSE_OPEN.C_O_CODE%TYPE	-- 과정번호를 받는 파라미터
, V_C_O_START   IN TBL_COURSE_OPEN.C_O_START%TYPE	-- 바꿀 과정 시작기간을 받는 파라미터
, V_C_O_END     IN TBL_COURSE_OPEN.C_O_END%TYPE		-- 바꿀 과정 끝기간을 받는 파라미터
)
IS
BEGIN
    UPDATE TBL_COURSE_OPEN
    SET C_O_START = V_C_O_START , C_O_END = V_C_O_END	-- 과정시작기간과 끝기간을 입력값으로 바꿔주기!
    WHERE C_O_CODE = V_C_O_CODE;			-- 과정번호가 같을 때
END;

--==>> Procedure PRC_COURSETIME_UPDATE이(가) 컴파일되었습니다.




-------------------------[PRC_PROFESSOR_UPDATE]-------------------------------------------------------

create or replace PROCEDURE PRC_PROFESSOR_UPDATE
( V_P_ID    IN TBL_PROFESSOR.P_ID%TYPE      -- 바꾸고 싶은 ID
, V_P_PW    IN TBL_PROFESSOR.P_PW%TYPE      -- 바꾸고 싶은 비밀번호
, V2_P_PW   IN TBL_PROFESSOR.P_PW%TYPE      -- 바꾸고 싶은 비밀번호 2차 확인
, V_P_NAME  IN TBL_PROFESSOR.P_NAME%TYPE
, V_P_SSN   IN TBL_PROFESSOR.P_SSN%TYPE
)
IS
    USER_DEFINE_ERROR   EXCEPTION;      -- 예외처리용 변수 선언
BEGIN

    IF V_P_PW != V2_P_PW      -- 바꾸고 싶은 비밀번호와 재확인용 비밀번호가 틀리다면...
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    UPDATE TBL_PROFESSOR
    SET P_ID = V_P_ID , P_PW = V_P_PW , P_NAME = V_P_NAME
    WHERE P_SSN = V_P_SSN;

    --커밋
    COMMIT;

    EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20010,'비밀번호가 서로 일치하지 않아요!');
END;

--==>> Procedure PRC_PROFESSOR_UPDATE이(가) 컴파일되었습니다.



------------------------------------------[PRC_SCORE_UPDATE] 프로시저----------------------------------------------
create or replace PROCEDURE PRC_SCORE_UPDATE
( V_S_O_CODE          IN TBL_SUBJECT_OPEN.S_O_CODE%TYPE			-- 과목번호를 받을 파라미터
, V_S_ID              IN TBL_STUDENT.S_ID%TYPE				-- 학생ID를 받을 파라미터
, V_S_C_WRITE         IN TBL_SCORE_CONTROL.S_C_WRITE%TYPE		-- 필기배점을 넣을 파라미터
, V_S_C_SKILL         IN TBL_SCORE_CONTROL.S_C_SKILL%TYPE		-- 실기배점을 넣을 파라미터
, V_S_C_ATTENDENCE    IN TBL_SCORE_CONTROL.S_C_ATTENDENCE%TYPE		-- 출결배점을 넣을 파라미터
)
IS
    V_C_R_CODE          TBL_COURSE_REGISTRATION.C_R_CODE%TYPE;		-- 수강신청의 개설번호를 넣을 변수
    V_C_O_CODE          TBL_COURSE_OPEN.C_O_CODE%TYPE;			-- 과정개설의 개설과정코드를 넣을 변수
    V_S_O_WPO           TBL_SUBJECT_OPEN.S_O_WPO%TYPE;			-- 과목개설의 필기배점을 넣을 변수
    V_S_O_SPO           TBL_SUBJECT_OPEN.S_O_SPO%TYPE;			-- 과목개설의 실기배점을 넣을 변수
    V_S_O_APO           TBL_SUBJECT_OPEN.S_O_APO%TYPE;			-- 과목개설의 출결배점을 넣을 변수
    USER_DEFINE_ERROR   EXCEPTION;					-- 예외처리 변수
BEGIN

    SELECT S_O_WPO , S_O_SPO, S_O_APO INTO V_S_O_WPO , V_S_O_SPO, V_S_O_APO
    FROM TBL_SUBJECT_OPEN
    WHERE S_O_CODE = V_S_O_CODE;

    IF (V_S_C_WRITE > V_S_O_WPO OR V_S_C_SKILL > V_S_O_SPO OR V_S_C_ATTENDENCE > V_S_O_APO)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    SELECT C_O_CODE INTO V_C_O_CODE			
    FROM TBL_SUBJECT_OPEN			
    WHERE S_O_CODE = V_S_O_CODE;			-- 과목개설번호가 파라미터와 같다면..
    
    SELECT C_R_CODE INTO V_C_R_CODE
    FROM TBL_COURSE_REGISTRATION
    WHERE C_O_CODE = V_C_O_CODE				-- 개설과정코드가 파라미터와 같다면..
    AND S_ID = V_S_ID;					-- 그리고 학생ID가 파라미터와 같다면..
    
    UPDATE TBL_SCORE_CONTROL
    SET S_C_WRITE = V_S_C_WRITE, S_C_SKILL = V_S_C_SKILL, S_C_ATTENDENCE = V_S_C_ATTENDENCE
    WHERE C_R_CODE = V_C_R_CODE
    AND S_O_CODE = V_S_O_CODE;


    --커밋!
    COMMIT;

    EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20078, '점수가 배점을 넘습니다!');


END;

--==>> Procedure PRC_SCORE_UPDATE이(가) 컴파일되었습니다.

------------------------------------------[PRC_STUDENT_UPDATE] 프로시저---------------------------------------------------------
create or replace PROCEDURE PRC_STUDENT_UPDATE
( V_S_SSN    IN TBL_STUDENT.S_SSN%TYPE				-- 학생의 주민번호를 받는 파라미터
, V_S_NAME   IN TBL_STUDENT.S_NAME%TYPE				-- 바꿀이름을 받는 파라미터
, V2_S_NAME  IN TBL_STUDENT.S_NAME%TYPE				-- 바꿀이름 확인용 파라미터
)
IS
    
    USER_DEFINE_ERROR   EXCEPTION; -- 이름 확인용 변수선언


BEGIN  

    IF V_S_NAME != V2_S_NAME					-- 바꿀이름과 2차 확인용 파라미터가 안맞을때!
        THEN RAISE USER_DEFINE_ERROR;				-- 별도로 예외처리!
    END IF;


    UPDATE TBL_STUDENT
    SET  S_NAME = V_S_NAME
    WHERE S_SSN = V_S_SSN; 

    --커밋!
    COMMIT;

    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20042, '이름이 서로 안맞아요!');
END;

--==>> Procedure PRC_STUDENT_UPDATE이(가) 컴파일되었습니다.


---------------------------------[PRC_SUPID_UPDATE] 프로시저--------------------------------------
create or replace PROCEDURE PRC_SUPID_UPDATE        
( V_S_O_CODE    IN TBL_SUBJECT_OPEN.S_O_CODE % TYPE	-- 개설과정번호를 받을 파라미터
, V_P_ID             IN TBL_SUBJECT_OPEN.P_ID%TYPE	-- 바꿀 교수ID를 받을 파라미터
)
IS
BEGIN
    UPDATE TBL_SUBJECT_OPEN
    SET P_ID = V_P_ID					-- 입력된 값으로 교수ID를 바꾸기
    WHERE V_S_O_CODE = S_O_CODE;			-- 개설과정번호가 맞을때

    -- 커밋
    COMMIT;
END;

--==>> Procedure PRC_SUPID_UPDATE이(가) 컴파일되었습니다.

--------------------------------[PRC_SUSTAEND_UPDATE] 프로시저---------------------------------------
create or replace PROCEDURE PRC_SUSTAEND_UPDATE
( V_S_O_CODE    IN TBL_SUBJECT_OPEN.S_O_CODE%TYPE		-- 과목개설번호를 받을 파라미터
, V_S_O_START   IN TBL_SUBJECT_OPEN.S_O_START%TYPE		-- 과목시작기간을 받을 파라미터
, V_S_O_END      IN TBL_SUBJECT_OPEN.S_O_END%TYPE		-- 과목끝기간을 받을 파라미터
)
IS
BEGIN

    UPDATE TBL_SUBJECT_OPEN
    SET S_O_START = V_S_O_START , S_O_END = V_S_O_END		-- 입력된 값으로 과목시작기간, 끝기간을 바꿔주기!
    WHERE V_S_O_CODE = S_O_CODE;				-- 과목개설번호가 파라미터와 맞을 때

END;

--==>> Procedure PRC_SUSTAEND_UPDATE이(가) 컴파일되었습니다.

--------------------------------------[PRC_SUWSAPO_UPDATE] 프로시저-------------------------------------
create or replace PROCEDURE PRC_SUWSAPO_UPDATE
( V_S_O_CODE    IN TBL_SUBJECT_OPEN.S_O_CODE%TYPE		-- 과목개설번호를 받을 파라미터
, V_S_O_WPO     IN TBL_SUBJECT_OPEN.S_O_WPO%TYPE		-- 바꿀 필기배점을 받을 파라미터
, V_S_O_SPO       IN TBL_SUBJECT_OPEN.S_O_SPO%TYPE		-- 바꿀 실기배점을 받을 파라미터
, V_S_O_APO       IN TBL_SUBJECT_OPEN.S_O_APO%TYPE		-- 바꿀 출결배점을 받을 파라미터
)
IS
BEGIN
    UPDATE TBL_SUBJECT_OPEN
    SET S_O_WPO = V_S_O_WPO , S_O_SPO = V_S_O_SPO , S_O_APO = V_S_O_APO		-- 입력된 값으로 필기, 실기, 출결 배점을 바꿔주기!
    WHERE V_S_O_CODE = S_O_CODE;						-- 과목개설번호가 파라미터와 맞을 때
END;

--==>> Procedure PRC_SUWSAPO_UPDATE이(가) 컴파일되었습니다.
-------------------------------------------------------------------------------------------------------------
----------------------[PRC_COURSE_DELETE] 프로시저 -------------------------

CREATE OR REPLACE  PROCEDURE PRC_COURSE_DELETE    --과정삭제 프로시저
(
    V_C_CODE      TBL_COURSE.C_CODE%TYPE     -- 과정 코드
  , V_C_NAME      TBL_COURSE.C_NAME%TYPE     -- 과정 이름
)
IS
BEGIN
        DELETE				  -- 과정을 지우겠다
        FROM TBL_COURSE
        WHERE  C_CODE = V_C_CODE	  -- 과정 코드와 내가 입력한 과정 코드가 같고
            AND C_NAME = V_C_NAME;	  -- 과정 이름과 내가 입력한 과정 이름이 같다면
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20100,'삭제에 필요한 항목을 다시 입력해주세요');
                     ROLLBACK;
END;
--==>> Procedure PRC_COURSE_DELETE이(가) 컴파일되었습니다.
----------------------------------------------------------------------------

----------------------[PRC_COURSE_OPEN_DELETE] 프로시저 -------------------------

CREATE OR REPLACE PROCEDURE PRC_COURSE_OPEN_DELETE     -- 과정개설 삭제 프로시저
(
    V_C_O_CODE      TBL_COURSE_OPEN.C_O_CODE%TYPE	-- 개설과정코드
  , V_C_CODE        TBL_COURSE_OPEN.C_CODE%TYPE	        -- 과정코드
  , V_CR_CODE       TBL_COURSE_OPEN.CR_CODE%TYPE	-- 강의실코드
  , V_C_O_START     TBL_COURSE_OPEN.C_O_START%TYPE 	-- 과정시작기간
  , V_C_O_END       TBL_COURSE_OPEN.C_O_END%TYPE	-- 과정끝기간
)
IS
BEGIN
        DELETE			          -- 과정개설을 지우겠다
        FROM TBL_COURSE_OPEN
        WHERE C_O_CODE = V_C_O_CODE	  -- 개설과정코드와 내가입력한 개설과정 코드가 같고
            AND C_CODE = V_C_CODE         -- 과정코드와 내가 입력한 과정코드가 같고
                AND CR_CODE = V_CR_CODE       --강의실코드가 내가 입력한 강의실 코드가 같고
                    AND C_O_START = V_C_O_START     --과정시작기간도 같고
                        AND C_O_END = V_C_O_END;    --과정 끝 기간도 같다면
        COMMIT;



	EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20101,'삭제에 필요한 항목을 다시 입력해주세요');
                     ROLLBACK;
END;
--==>> Procedure PRC_COURSE_OPEN_DELETE이(가) 컴파일되었습니다.
----------------------------------------------------------------------------


----------------------[PRC_PROFESSOR_DELETE] 프로시저 -------------------------


CREATE OR REPLACE PROCEDURE PRC_PROFESSOR_DELETE   -- 교수삭제 프로시저
(
    V_P_ID      TBL_PROFESSOR.P_ID%TYPE		-- 교수아이디
  , V_P_NAME    TBL_PROFESSOR.P_NAME%TYPE	-- 교수이름
  , V_P_SSN     TBL_PROFESSOR.P_SSN%TYPE	-- 교수 주민번호 뒷자리
)
IS
BEGIN
        DELETE					-- 교수를 지우겠다
        FROM TBL_PROFESSOR	
        WHERE P_ID = V_P_ID			-- 교수아이디와 내가 입력한 아이디가 같고
            AND P_NAME = V_P_NAME		-- 교수이름과 내가 입력한 이름이 같고
                AND P_SSN = V_P_SSN;		-- 교수 주민번호 뒷자리와 내가 입력한 값이 같다면
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20102,'삭제에 필요한 항목을 다시 입력해주세요');

                     ROLLBACK;
END;
--==>> Procedure PRC_PROFESSOR_DELETE이(가) 컴파일되었습니다.
----------------------------------------------------------------------------

----------------------[PRC_SCORE_CONTROL_DELETE] 프로시저 -------------------------


CREATE OR REPLACE PROCEDURE PRC_SCORE_CONTROL_DELETE	-- 성적삭제 프로시저
(
    V_C_R_CODE          TBL_SCORE_CONTROL.C_R_CODE%TYPE		-- 수강신청코드
  , V_S_O_CODE          TBL_SCORE_CONTROL.S_O_CODE%TYPE		-- 개설번호	
  , V_S_C_WRITE         TBL_SCORE_CONTROL.S_C_WRITE%TYPE	-- 필기
  , V_S_C_SKILL         TBL_SCORE_CONTROL.S_C_SKILL%TYPE	-- 실기
  , V_S_C_ATTENDENCE    TBL_SCORE_CONTROL.S_C_ATTENDENCE%TYPE	-- 출결
)
IS
BEGIN
        DELETE					-- 성적을 지우겠다
        FROM TBL_SCORE_CONTROL
        WHERE C_R_CODE = V_C_R_CODE		-- 수강신청 코드가 같고
            AND S_O_CODE = V_S_O_CODE    	-- 개설번호가 같고
                AND S_C_WRITE = V_S_C_WRITE  	-- 필기점수가 같고
                    AND S_C_SKILL = V_S_C_SKILL -- 실기점수가 같고
                        AND S_C_ATTENDENCE = V_S_C_ATTENDENCE;  -- 출결점수가 같다면
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20103,'삭제에 필요한 항목을 다시 입력해주세요');
                     ROLLBACK;
END;
--==>> Procedure PRC_SCORE_CONTROL_DELETE이(가) 컴파일되었습니다.
----------------------------------------------------------------------------


----------------------[PRC_STUDENT_DELETE] 프로시저 -------------------------

CREATE OR REPLACE PROCEDURE PRC_STUDENT_DELETE   -- 학생정보 삭제 프로시저
(
    V_S_ID      TBL_STUDENT.S_ID%TYPE		-- 학생 아이디
  , V_S_PW      TBL_STUDENT.S_PW%TYPE		-- 학생 비밀번호
  , V_S_NAME    TBL_STUDENT.S_NAME%TYPE		-- 학생이름
  , V_S_SSN     TBL_STUDENT.S_SSN%TYPE		-- 학생 주민번호 뒷자리
)
IS
BEGIN
        DELETE				-- 학생정보를 지우겠다
        FROM TBL_STUDENT		
        WHERE S_ID = V_S_ID			-- 학생 아이디가 같고
            AND S_PW = V_S_PW    		-- 학생 비밀번호가 같고
                AND S_NAME = V_S_NAME  		-- 학생 이름이 같고
                    AND S_SSN = V_S_SSN;  	-- 학생 주민번호 뒷자리가 같다면
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20104,'삭제에 필요한 항목을 다시 입력해주세요');
                     ROLLBACK; 
END;
--==>> Procedure PRC_STUDENT_DELETE이(가) 컴파일되었습니다.
----------------------------------------------------------------------------


----------------------[PRC_SUBJECT_DELETE] 프로시저 -------------------------
CREATE OR REPLACE PROCEDURE PRC_SUBJECT_DELETE   -- 과목삭제 프로시저
(
    V_S_CODE      TBL_SUBJECT.S_CODE%TYPE      -- 과목코드
  , V_S_NAME      TBL_SUBJECT.S_NAME%TYPE      -- 과목명
)
IS
BEGIN
        DELETE					-- 과목을 지우겠다
        FROM TBL_SUBJECT
        WHERE  S_CODE = V_S_CODE		-- 과목코드가 같고
            AND S_NAME = V_S_NAME;		-- 과목명이 같다면

        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20105,'삭제에 필요한 항목을 다시 입력해주세요');
                     ROLLBACK;
END;
--==>> Procedure PRC_SUBJECT_DELETE이(가) 컴파일되었습니다.

----------------------------------------------------------------------------


----------------------[PRC_SUBJECT_OPEN_DELETE] 프로시저 -------------------------

CREATE OR REPLACE PROCEDURE PRC_SUBJECT_OPEN_DELETE  -- 과목개설 프로시저
( V_S_O_CODE    IN TBL_SUBJECT_OPEN.S_O_CODE%TYPE    -- 개설번호
, V_C_O_CODE    IN TBL_SUBJECT_OPEN.C_O_CODE%TYPE    -- 개설과정코드
, V_P_ID        IN TBL_SUBJECT_OPEN.P_ID%TYPE	     -- 교수아이디
, V_S_CODE      IN TBL_SUBJECT_OPEN.S_CODE%TYPE	     -- 과목번호
, V_T_CODE      IN TBL_SUBJECT_OPEN.T_CODE%TYPE	     -- 교재코드
, V_S_O_WPO     IN TBL_SUBJECT_OPEN.S_O_WPO%TYPE     -- 필기배점
, V_S_O_SPO     IN TBL_SUBJECT_OPEN.S_O_SPO%TYPE     -- 실기배점
, V_S_O_APO     IN TBL_SUBJECT_OPEN.S_O_APO%TYPE     -- 출결배점
, V_S_O_START   IN TBL_SUBJECT_OPEN.S_O_START%TYPE   -- 과목시작기간
, V_S_O_END     IN TBL_SUBJECT_OPEN.S_O_END%TYPE     -- 과목끝나는기간
)
IS
BEGIN

    DELETE					-- 과목개설을 지우겠다
    FROM TBL_SUBJECT_OPEN
    WHERE S_O_CODE = V_S_O_CODE					-- 개설번호가 같고
        AND C_O_CODE = V_C_O_CODE   				-- 개설과정코드가 같고
            AND P_ID = V_P_ID       				-- 교수 아이디가 같고
                AND S_CODE = V_S_CODE  				-- 과목번호가 같고
                    AND T_CODE = V_T_CODE       		-- 교재코드가 같고
                        AND S_O_WPO = V_S_O_WPO   		-- 필기배점이 같고
                            AND S_O_SPO = V_S_O_SPO		-- 실기기배점이 같고
                                AND S_O_APO = V_S_O_APO  	-- 출결배점이 같고
                                    AND S_O_START = V_S_O_START -- 과목시작기간이 같고
                                        AND S_O_END = V_S_O_END;-- 과목끝나는기간이 같으면

    COMMIT;

    EXCEPTION
        WHEN OTHERS
            THEN RAISE_APPLICATION_ERROR(-20106,'삭제에 필요한 항목을 다시 입력해주세요');
                 ROLLBACK;
END;
--==>> Procedure PRC_SUBJECT_OPEN_DELETE이(가) 컴파일되었습니다.
----------------------------------------------------------------------------


-- 강의실 연쇄 업데이트 트리거
create or replace TRIGGER TRG_CLASSROOM_CR_CODE_UPDATE
AFTER UPDATE OF CR_CODE ON TBL_COURSE_OPEN FOR EACH ROW
BEGIN
    UPDATE TBL_CLASSROOM
    SET CR_CODE = :NEW.CR_CODE
    WHERE CR_CODE = :OLD.CR_CODE;
END;
-----------------------------------------------------------
-- 두번째 연쇄 과정개설코드 업데이트 트리거
create or replace TRIGGER TRG_COUROPEN_C_O_CODE_UPDATE -- 과정개설의 개설과정코드를 바꿀시 수강신청의 개설과정코드도 자동으로 바뀌게 TRIGGER!
AFTER UPDATE OF C_O_CODE ON TBL_SUBJECT_OPEN FOR EACH ROW
BEGIN
    UPDATE TBL_COURSE_OPEN
    SET C_O_CODE = :NEW.C_O_CODE
    WHERE C_O_CODE = :OLD.C_O_CODE;
END;
-----------------------------------------------------------
create or replace TRIGGER TRG_COURSE_C_CODE_UPDATE
AFTER UPDATE OF C_CODE ON TBL_COURSE_OPEN FOR EACH ROW
BEGIN
    UPDATE TBL_COURSE
    SET C_CODE = :NEW.C_CODE
    WHERE C_CODE = :OLD.C_CODE;
END;
----------------------------------------------------------------
-- 수강신청 후 자동 성적처리테이블 등록 트리거
create or replace TRIGGER TRG_COURSE_REG_S_C
    AFTER
    INSERT ON TBL_COURSE_REGISTRATION
    FOR EACH ROW
DECLARE
    COLENTH     NUMBER;
BEGIN
    IF (INSERTING)
        THEN
            FOR DATA_ROW IN (SELECT S_O_CODE
                               FROM TBL_SUBJECT_OPEN
                               WHERE C_O_CODE = :NEW.C_O_CODE) LOOP
                INSERT INTO TBL_SCORE_CONTROL(C_R_CODE, S_O_CODE)
                VALUES (:NEW.C_R_CODE, DATA_ROW.S_O_CODE);
            END LOOP;           
    END IF;
END;
-----------------------------------------------------------------
-- 수강신청 삭제후 중도탈락 테이블 자동등록 트리거
create or replace TRIGGER TRG_FAIL_INSERT
        AFTER
        DELETE ON TBL_COURSE_REGISTRATION
        FOR EACH ROW
        
DECLARE
    V_C_R_CODE      TBL_COURSE_REGISTRATION.C_R_CODE%TYPE;
BEGIN
                SELECT C_R_CODE         INTO V_C_R_CODE
                FROM TBL_COURSE_REGISTRATION
                WHERE C_R_CODE = :OLD.C_R_CODE;            --예전C_R_CODE와 수강신청TABLE의 C_R_CODE를 V_C_R_CODE에 저장
    IF(DELETING)                                           --삭제 발생시 중도탈락 TABLE에 넣어줌 각각의 행에 대해
        THEN INSERT INTO TBL_FAIL(C_R_CODE, F_DATE, F_REASON)
             VALUES (V_C_R_CODE, SYSDATE, NULL);
    END IF;
END;
----------------------------------------------------------------------
-- 교수 아이디 연쇄 업데이트 트리거
create or replace TRIGGER TRG_PROFESSOR_P_ID_UPDATE
AFTER UPDATE OF P_ID ON TBL_SUBJECT_OPEN FOR EACH ROW
BEGIN
    UPDATE TBL_PROFESSOR
    SET P_ID = :NEW.P_ID
    WHERE P_ID = :OLD.P_ID;
END;
----------------------------------------------------------------------
-- 수강신청 코드 연쇄 업데이트 트리거
create or replace TRIGGER TRG_REGIST_C_R_CODE_UPDATE
AFTER UPDATE OF C_R_CODE ON TBL_FAIL FOR EACH ROW
BEGIN
    UPDATE TBL_COURSE_REGISTRATION
    SET C_R_CODE = :NEW.C_R_CODE
    WHERE C_R_CODE = :OLD.C_R_CODE;
END;

----------------------------------------------------------------------
-- 과정과 과목 기간 관련 트리거
create or replace TRIGGER TRG_S_O_DATE
    BEFORE
    INSERT OR UPDATE ON TBL_SUBJECT_OPEN
    FOR EACH ROW
    DECLARE
        V_C_O_START     TBL_COURSE_OPEN.C_O_START%TYPE;     
        V_C_O_END       TBL_COURSE_OPEN.C_O_END%TYPE;
    BEGIN
        SELECT C_O_START, C_O_END INTO V_C_O_START, V_C_O_END       
        FROM TBL_COURSE_OPEN
        WHERE C_O_CODE = :NEW.C_O_CODE;                         --C_O_CODE와 참조후 C_O_CODE가 같을 때 
        IF (:NEW.S_O_START < V_C_O_START OR :NEW.S_O_END > V_C_O_END) --참조 후 과목 시작날짜 < 과정 시작날짜 OR 참조 후 종료 과목개설 종료 날짜 > 과정종료날짜 
                                                                      --일때 오류발생
            THEN RAISE_APPLICATION_ERROR(-20009, '기간 관련오류!');
        END IF;
    END;
-------------------------------------------------------------------
-- 과목간 기간 관련 트리거
create or replace TRIGGER TRG_S_O_DATE2
    BEFORE
    INSERT OR UPDATE ON TBL_SUBJECT_OPEN
    FOR EACH ROW
    DECLARE
        V_C_O_START     TBL_COURSE_OPEN.C_O_START%TYPE;
        V_C_O_END       TBL_COURSE_OPEN.C_O_END%TYPE;
    BEGIN

        FOR DATA_ROW IN (SELECT S_O_START
                         FROM TBL_SUBJECT_OPEN)LOOP


        SELECT C_O_START, C_O_END INTO V_C_O_START, V_C_O_END
        FROM TBL_COURSE_OPEN
        WHERE C_O_CODE = :NEW.C_O_CODE;
        IF ((:NEW.S_O_START < V_C_O_START AND :NEW.S_O_END > V_C_O_START)OR(:NEW.S_O_START < V_C_O_END AND :NEW.S_O_END > V_C_O_END))
            THEN RAISE_APPLICATION_ERROR(-20009, '기간 관련오류!');
        END IF;
        END LOOP;
    END;
-------------------------------------------------------------------
-- 학생 ID 연쇄 업데이트 트리거
create or replace TRIGGER TRG_STUDENT_S_ID_UPDATE
AFTER UPDATE OF S_ID ON TBL_COURSE_REGISTRATION FOR EACH ROW
BEGIN
    UPDATE TBL_STUDENT
    SET S_ID = :NEW.S_ID
    WHERE S_ID = :OLD.S_ID;
END;
------------------------------------------------------------------------
-- 과목 코드 연쇄 업데이트 트리거
create or replace TRIGGER TRG_SUBJECT_S_NAME_UPDATE
AFTER UPDATE OF S_CODE ON TBL_SUBJECT_OPEN FOR EACH ROW
BEGIN
    UPDATE TBL_SUBJECT
    SET S_CODE = :NEW.S_CODE
    WHERE S_CODE = :OLD.S_CODE;
END;
------------------------------------------------------------------------
-- 교과서 코드 연쇄 업데이트 트리거
create or replace TRIGGER TRG_TEXTBOOK_T_CODE_UPDATE
AFTER UPDATE OF T_CODE ON TBL_SUBJECT_OPEN FOR EACH ROW
BEGIN

    UPDATE TBL_TEXTBOOK
    SET T_CODE = :NEW.T_CODE
    WHERE T_CODE = :OLD.T_CODE;
END;
------------------------------------------------------------------