SELECT USER
FROM DUAL;
-- ○ TABLESPACE 생성
CREATE TABLESPACE PROJECT
DATAFILE 'c:\PROJECT\TBS_SIST01.dbf'   
SIZE 100m                                
EXTENT MANAGEMENT LOCAL                 
SEGMENT SPACE MANAGEMENT AUTO;          
--==>> Tablespace PROJECT이(가) 생성되었습니다.

-- ○ SIST01 계정에 권한부여
create user SIST01 identified by java006$
default tablespace PROJECT;

GRANT CREATE TABLE TO sist01;

ALTER USER SIST01 DEFAULT TABLESPACE USERS;

GRANT CREATE SESSION TO SIST01;

--■■■ 테이블 생성 ■■■--
--○ 관리자 테이블 생성
CREATE TABLE TBL_ADMIN
( A_ID VARCHAR2(40)    CONSTRAINT ADMINE_A_ID_NN NOT NULL -- 관리자 ID
, A_PW VARCHAR2(16)    CONSTRAINT ADMINE_A_PW_NN NOT NULL -- 관리자 PW
, CONSTRAINT TBL_ADMIN_A_ID_UK UNIQUE (A_ID)              
);

--○ 과정 테이블 생성
CREATE TABLE TBL_COURSE
( C_CODE NUMBER                                              -- 과정 코드
, C_NAME VARCHAR2(10)    CONSTRAINT COURSE_C_NAME_NN NOT NULL -- 과정 이름
, CONSTRAINT TBL_COURSE_C_CODE_PK PRIMARY KEY (C_CODE)
);

--○ 교수자 테이블 생성
CREATE TABLE TBL_PROFESSOR
( P_ID      VARCHAR2(20)                                           -- 교수자 ID
, P_PW      VARCHAR2(16)                                           -- 교수자 PW
, P_NAME    VARCHAR2(10)    CONSTRAINT PROFESSOR_T_NAME_NN NOT NULL -- 교수자 이름
, P_SSN     CHAR(7)         CONSTRAINT PROFESSOR_T_SSN_NN NOT NULL  -- 주민등록번호뒷자리
, CONSTRAINT PROFESSORL_P_ID_PK PRIMARY KEY (P_ID)
);

--○ 강의실 테이블 생성
CREATE TABLE TBL_CLASSROOM 
( CR_CODE   NUMBER                                                 -- 강의실 코드 
, CR_LOC    VARCHAR2(10) CONSTRAINT CLASSROOM_CR_LOC_NN NOT NULL    -- 강의실 위치
, CR_CAPA   NUMBER       CONSTRAINT CLASSROOM_CR_CAPA_NN NOT NULL   -- 최대정원
, CONSTRAINT CLASSROOM_CR_CODE_PK PRIMARY KEY (CR_CODE)
);

--○ 학생 테이블 생성  
CREATE TABLE TBL_STUDENT
( S_ID      VARCHAR2(20)    -- 학생 ID
, S_PW      VARCHAR2(16) CONSTRAINT STUDENT_S_PW_NN NOT NULL    -- 학생 PW
, S_NAME    VARCHAR2(10) CONSTRAINT STUDENT_S_NAME_NN NOT NULL  -- 학생 이름
, S_SSN     CHAR(7)      CONSTRAINT STUDENT_S_SSN_NN NOT NULL   -- 주민등록번호
, CONSTRAINT STUDENT_S_ID_PK PRIMARY KEY (S_ID)
);

--○ 교재 테이블 생성
CREATE TABLE TBL_TEXTBOOK
( T_CODE      NUMBER                                              -- 교재 코드
, T_NAME      VARCHAR2(10)  CONSTRAINT TEXTBOOK_T_NAME_NN NOT NULL -- 교재 이름
, T_PUB       VARCHAR2(10)  CONSTRAINT TEXTBOOK_T_PUB_NN NOT NULL  -- 출판사
, CONSTRAINT TEXTBOOK_T_CODE_PK PRIMARY KEY (T_CODE)
);

--○ 과목 테이블 생성
CREATE TABLE TBL_SUBJECT
( S_CODE    NUMBER                                              -- 과목 코드
, S_NAME    VARCHAR2(16)   CONSTRAINT SUBJECT_S_NAME_NN NOT NULL -- 과목 이름
, CONSTRAINT SUBJECT_S_CODE_PK PRIMARY KEY (S_CODE)
);

--○ 과정개설 테이블 생성
CREATE TABLE TBL_COURSE_OPEN
( C_O_CODE  NUMBER                                              -- 과정개설 코드
, C_CODE    NUMBER  CONSTRAINT COURSE_OPEN_C_CODE_NN NOT NULL    -- 과정 코드
, CR_CODE   NUMBER  CONSTRAINT COURSE_OPEN_CR_CODE_NN NOT NULL   -- 강의실 코드
, CONSTRAINT COURSE_OPEN_CODE_PK PRIMARY KEY (C_O_CODE)
);

--○ 과목개설 테이블 생성
CREATE TABLE TBL_SUBJECT_OPEN
( S_O_CODE  NUMBER                                                      -- 과목개설 코드
, C_O_CODE  NUMBER         CONSTRAINT SUBJECT_OPEN_C_O_CODE_NN NOT NULL  -- 과정개설 코드
, P_ID      VARCHAR2(20)   CONSTRAINT SUBJECT_OPEN_P_ID_NN NOT NULL      -- 교수자 아이디  
, S_CODE    NUMBER         CONSTRAINT SUBJECT_OPEN_S_CODE_NN NOT NULL    -- 과목 코드
, T_CODE    NUMBER         CONSTRAINT SUBJECT_OPEN_T_CODE_NN NOT NULL    -- 교재 코드
, S_O_WPO   NUMBER                                                      -- 필기 배점
, S_O_SPO   NUMBER                                                      -- 실기 배점
, S_O_APO   NUMBER                                                      -- 출결 배점
, S_O_START DATE           CONSTRAINT SUBJECT_OPEN_S_O_START_NN NOT NULL -- 과목 시작
, S_O_END   DATE           CONSTRAINT SUBJECT_OPEN_S_O_END_NN NOT NULL   -- 과목 끝
, CONSTRAINT TBL_SUBJECT_OPEN_S_O_CODE_PK PRIMARY KEY (S_O_CODE)
, CONSTRAINT TBL_SUBJECT_OPEN_CK CHECK (S_O_WPO + S_O_SPO + S_O_APO = 100)
, CONSTRAINT SUBJECT_OPEN_S_O_END_CK CHECK (S_O_END > S_O_START)
, CONSTRAINT SUBJECT_OPEN_S_O_START_CK CHECK (S_O_START < S_O_END)
);

--○ 수강신청 테이블 생성
CREATE TABLE TBL_COURSE_REGISTRATION
( C_R_CODE NUMBER                                                 -- 수강신청 코드
, S_ID     VARCHAR2(20) CONSTRAINT COURSE_REG_S_ID_NN NOT NULL     -- 학생 ID
, C_O_CODE NUMBER       CONSTRAINT COURSE_REG_C_O_CODE_NN NOT NULL -- 과정개설 코드
, C_R_DATE DATE                                                   -- 수강신청 일자
, CONSTRAINT COURSE_REG_C_R_CODE_PK PRIMARY KEY (C_R_CODE)
);

--○ 성적처리업무 테이블 생성
CREATE TABLE TBL_SCORE_CONTROL
( C_R_CODE          NUMBER  -- 수강신청 코드
, S_O_CODE          NUMBER  -- 성적개설 코드
, S_C_WRITE         NUMBER  -- 필기 점수
, S_C_SKILL         NUMBER  -- 실기 점수
, S_C_ATTENDENCE    NUMBER  -- 출석 점수
, CONSTRAINT SCORE_CONTROL_C_R_CODE_UK UNIQUE (C_R_CODE)
, CONSTRAINT SCORE_CONTROL_S_O_CODE_UK UNIQUE (S_O_CODE)
);

--○ 중도탈락 테이블 생성
CREATE TABLE TBL_FAIL
( C_R_CODE NUMBER   CONSTRAINT FAIL_C_R_CODE_NN NOT NULL -- 수강신청 코드
, F_DATE   DATE     CONSTRAINT FAIL_F_DATE_NN NOT NULL   -- 탈락 날짜
);


--■■■ 테이블 조건 추가 ■■■--
--○ 과정개설 테이블에 시작날, 끝날 컬럼 추가
ALTER TABLE TBL_COURSE_OPEN
ADD C_O_START DATE;

ALTER TABLE TBL_COURSE_OPEN
ADD C_O_END DATE;

ALTER TABLE TBL_COURSE_OPEN
ADD ( CONSTRAINT COURSE_OPEN_START_NN NOT NULL
    , CONSTRAINT COURSE_OPEN_END_NN NOT NULL
    , CONSTRAINT COURSE_OPEN_START CHECK (C_O_START < C_O_END) 
   , CONSTRAINT COURSE_OPEN_END CHECK (C_O_START < C_O_END));

ALTER TABLE TBL_COURSE_OPEN
ADD ( CONSTRAINT COURSE_OPEN_CR_CODE_FK FOREIGN KEY (CR_CODE)
        REFERENCES TBL_CLASSROOM(CR_CODE) ON DELETE CASCADE
    , CONSTRAINT COURSE_OPEN_C_CODE_FK FOREIGN KEY (C_CODE)
        REFERENCES TBL_COURSE (C_CODE) ON DELETE CASCADE);

--○ 과목개설 조건
ALTER TABLE TBL_SUBJECT_OPEN
ADD( CONSTRAINT SUBJECT_OPEN_S_CODE_FK FOREIGN KEY (S_CODE)
       REFERENCES TBL_SUBJECT (S_CODE) ON DELETE CASCADE
   , CONSTRAINT SUBJECT_OPEN_T_CODE_FK FOREIGN KEY (T_CODE)
       REFERENCES TBL_TEXTBOOK (T_CODE) ON DELETE CASCADE
   , CONSTRAINT SUBJECT_OPEN_C_O_CODE_FK FOREIGN KEY (C_O_CODE)
       REFERENCES TBL_COURSE_OPEN (C_O_CODE) ON DELETE CASCADE
   , CONSTRAINT SUBJECT_OPEN_P_ID_FK FOREIGN KEY (P_ID)
       REFERENCES TBL_PROFESSOR (P_ID) ON DELETE CASCADE);

--○ 수강신청 조건
ALTER TABLE TBL_COURSE_REGISTRATION
ADD( CONSTRAINT REGISTRATION_C_O_CODE_FK FOREIGN KEY (C_O_CODE)
        REFERENCES TBL_COURSE_OPEN (C_O_CODE) ON DELETE CASCADE
   , CONSTRAINT REGISTRATION_S_ID_FK FOREIGN KEY (S_ID)
        REFERENCES TBL_STUDENT (S_ID) ON DELETE CASCADE);

--○ 성적처리 조건
ALTER TABLE TBL_SCORE_CONTROL
ADD( CONSTRAINT SCORE_CONTROL_S_O_CODE_FK FOREIGN KEY (S_O_CODE)
        REFERENCES TBL_SUBJECT_OPEN (S_O_CODE) ON DELETE CASCADE
   , CONSTRAINT SCORE_CONTROL_C_R_CODE_FK FOREIGN KEY (C_R_CODE)
        REFERENCES TBL_COURSE_REGISTRATION (C_R_CODE) ON DELETE CASCADE);

--○ 중도탈락 조건
ALTER TABLE TBL_FAIL
ADD (F_REASON VARCHAR2(100 BYTE));

ALTER TABLE TBL_FAIL
ADD( CONSTRAINT FAIL_C_R_CODE_FK FOREIGN KEY (C_R_CODE)
        REFERENCES TBL_COURSE_REGISTRATION (C_R_CODE) ON DELETE CASCADE);
--==>> SIST01
--[관리자 정보 INSERT]--------------------------------------
INSERT INTO TBL_ADMIN(A_ID,A_PW) VALUES('HOJINI','JAVA006$');
/*
HOJINI   JAVA006$
*/
------------------------------------------------------------
--[PRC_PROFESSOR_INSERT] 데이터 입력 및 확인----------------
-- EXEC PRC_PROFESSOR_INSERT (교수자ID,'교수자이름','교수자 SSN');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO01','이은채','1234567');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO02','김종범','2345678');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO03','안준헌','3456789');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO04','오지은','4567890');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO05','박혜민','5647890');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO06','김동현','6789123');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다. *6

SELECT *
FROM TBL_PROFESSOR;
/*
SISTPRO01	1234567	이은채	1234567
SISTPRO02	2345678	김종범	2345678
SISTPRO03	3456789	안준헌	3456789
SISTPRO04	4567890	오지은	4567890
SISTPRO05	5647890	박혜민	5647890
SISTPRO06	6789123	김동현	6789123
*/
------------------------------------------------------------------
--[PRC_BOOK] 데이터 입력 및 확인----------------------------------
-- EXEC PRC_BOOK('책이름','출판사');
EXEC PRC_BOOK('HAPPYJAVA','동현북');
EXEC PRC_BOOK('GOODJAVA','동아북');
EXEC PRC_BOOK('BADORACLE','동명북');
EXEC PRC_BOOK('EASYORACLE','동훈북');
EXEC PRC_BOOK('HIHTML','동해북');

SELECT *
FROM TBL_TEXTBOOK;
/*
1   HAPPYJAVA   동현북
2   GOODJAVA   동아북
3   BADORACLE   동명북
4   EASYORACLE   동훈북
5   HIHTML       동해북
*/
---------------------------------------------------------------------------------
--[PRC_ADMIN_COURSE_INSERT] 데이터 입력 및 확인----------------------------------
-- EXEC PRC_ADMIN_COURSE_INSERT('과정명');
EXEC PRC_ADMIN_COURSE_INSERT('JAVA');
EXEC PRC_ADMIN_COURSE_INSERT('ORACLE');
EXEC PRC_ADMIN_COURSE_INSERT('JSP');
EXEC PRC_ADMIN_COURSE_INSERT('JDBC');
EXEC PRC_ADMIN_COURSE_INSERT('HTML5');

SELECT *
FROM TBL_COURSE;
--==>>
/*
3   JSP
4   JDBC
1   JAVA
2   ORACLE
5   HTML5
*/
------------------------------------------------------------------
--[PRC_ADMIN_CLASSROOM_INSERT] 데이터 입력 및 확인----------------

--강의실 INSERT--
-- EXEC PRC_ADMIN_CLASSROOM_INSERT('강의실위치',정원수);
EXEC PRC_ADMIN_CLASSROOM_INSERT('305호',20);
EXEC PRC_ADMIN_CLASSROOM_INSERT('306호',30);
EXEC PRC_ADMIN_CLASSROOM_INSERT('307호',35);
EXEC PRC_ADMIN_CLASSROOM_INSERT('308호',30);
EXEC PRC_ADMIN_CLASSROOM_INSERT('309호',20);

SELECT *
FROM TBL_CLASSROOM

/*
1   305호   20
2   306호   30
3   307호   35
4   308호   30
5   309호   20
*/
------------------------------------------------------------------
--[PRC_STUDENT_INSERT] 데이터 입력 및 확인------------------------
-- EXEC PRC_STUDENT_INSERT('학생 ID', '학생명', '학생SSN');
EXEC PRC_STUDENT_INSERT('CAPTAIN', '안준헌', '1234567');
EXEC PRC_STUDENT_INSERT('TEST', '김동현', '2345678');
EXEC PRC_STUDENT_INSERT('TEST2', '이은채', '2345678');
EXEC PRC_STUDENT_INSERT('TEST3', '오지은', '3456789');
EXEC PRC_STUDENT_INSERT('TEST4', '김종범', '4567891');
EXEC PRC_STUDENT_INSERT('TEST5', '박혜민', '5678910');

SELECT *
FROM TBL_STUDENT;
/*
CAPTAIN   1234567   안준헌   1234567
TEST   2345678   김동현   2345678
TEST5   5678910   박혜민   5678910
TEST4   4567891   김종범   4567891
TEST3   3456789   오지은   3456789
TEST2   2345678   이은채   2345678
*/
------------------------------------------------------------------
--[PRC_SUBJECT_INSERT] 데이터 입력 및 확인------------------------
-- EXEC PRC_SUBJECT_INSERT('과목이름');
EXEC PRC_SUBJECT_INSERT('JAVA');
EXEC PRC_SUBJECT_INSERT('ORACLE');
EXEC PRC_SUBJECT_INSERT('C++');
EXEC PRC_SUBJECT_INSERT('HTML5+CSS');
EXEC PRC_SUBJECT_INSERT('ANDROID');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다. *5

SELECT *
FROM TBL_SUBJECT;
/*
1	JAVA
2	ORACLE
3	C++
4	HTML5+CSS
5	ANDROID
*/
------------------------------------------------------------------
--[PRC_ADMIN_C_O_INSERT] 데이터 입력 및 확인------------------------
-- EXEC PRC_ADMIN_C_O_INSERT ('과정명',과정시작날짜,과정끝난날짜,강의실위치);

-- PRC_ADMIN_C_O_INSERT 프로시저 확인
-- 과정 테이블과 강의실 테이블에 있는 데이터로 입력해야함!!

EXEC PRC_ADMIN_C_O_INSERT ('ORACLE',TO_DATE('191018','YYMMDD'),TO_DATE('191118','YYMMDD'),'305호');
EXEC PRC_ADMIN_C_O_INSERT ('JAVA',TO_DATE('191218','YYMMDD'),TO_DATE('190118','YYMMDD'),'306호');
EXEC PRC_ADMIN_C_O_INSERT ('JSP',TO_DATE('190218','YYMMDD'),TO_DATE('190318','YYMMDD'),'307호');
EXEC PRC_ADMIN_C_O_INSERT ('HTML5',TO_DATE('190418','YYMMDD'),TO_DATE('190518','YYMMDD'),'308호');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다. *4
-- 과정 개설 테이블 확인
SELECT *
FROM TBL_COURSE_OPEN;
/*
3	5	4	19/04/18	19/05/18
1	2	1	19/10/18	19/11/18
2	3	3	19/02/18	19/03/18
*/
--------------------------------------------------------------------
--[PRC_ADMIN_S_O_INSERT] 데이터 입력 및 확인------------------------
-- EXEC PRC_ADMIN_S_O_INSERT(개설과정코드,과목명,과목시작날자,과목끝난날자,교재명,교수명);

-- 등록된 개설과정 코드 입력
-- 과목기간이 등록된 과정기간시작일보다 작거나 끝나는기간보다 크면 안됨!
-- 교재테이블에서 등록된 교재명과 등록된 교수명으로 데이터를 입력해야함 !!

EXEC PRC_ADMIN_S_O_INSERT(1,'JAVA',TO_DATE('191018','YYMMDD'),TO_DATE('191101','YYMMDD'),'HAPPYJAVA','이은채' );
EXEC PRC_ADMIN_S_O_INSERT(2,'ORACLE',TO_DATE('190218','YYMMDD'),TO_DATE('190225','YYMMDD'),'BADORACLE','김동현' );
EXEC PRC_ADMIN_S_O_INSERT(3,'HTML5+CSS',TO_DATE('190418','YYMMDD'),TO_DATE('190515','YYMMDD'),'HIHTML','박혜민' );


--==>> Procedure PRC_PRO_PRINT이(가) 컴파일되었습니다.

-- 과목 개설 테이블 확인
SELECT *
FROM TBL_SUBJECT_OPEN;
/*
1	1	SISTPRO01	1	1				19/10/18	19/11/01
3	1	SISTPRO01	1	1				19/10/18	19/11/01
4	2	SISTPRO06	2	3				19/02/18	19/02/25
2	2	SISTPRO06	2	3				19/02/18	19/02/25
5	3	SISTPRO05	4	5				19/04/18	19/05/15
*/
-----------------------------------------------------------------------
--[PRC_SET_POINT] 데이터 입력 및 확인----------------------------------
-- EXEC PRC_SET_POINT(과목개설번호,필기배점,실기배점,출결배점);

-- 등록된 과목 개설의 개설코드를 입력해야함!
EXEC PRC_SET_POINT(1,40,40,20);
EXEC PRC_SET_POINT(2,40,30,30);
EXEC PRC_SET_POINT(3,45,45,10);
EXEC PRC_SET_POINT(4,45,45,10);
EXEC PRC_SET_POINT(5,45,45,10);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다. *5
-- 과목 개설 테이블 확인
SELECT *
FROM TBL_SUBJECT_OPEN;
/*
1	1	SISTPRO01	1	1	40	40	20	19/10/18	19/11/01
3	1	SISTPRO01	1	1	45	45	10	19/10/18	19/11/01
4	2	SISTPRO06	2	3	45	45	10	19/02/18	19/02/25
2	2	SISTPRO06	2	3	40	30	30	19/02/18	19/02/25
5	3	SISTPRO05	4	5	45	45	10	19/04/18	19/05/15
*/
--------------------------------------------------------------------------

--[PRC_COURSE_REG_INSERT] 데이터 입력 및 확인-----------------------------
-- EXEC PRC_COURSE_REG_INSERT(학생 ID,개설과정코드 );

-- 등록된 학생 ID , 개설과정 코드 입력
EXEC PRC_COURSE_REG_INSERT('CAPTAIN',1 );
EXEC PRC_COURSE_REG_INSERT('TEST',2 );
EXEC PRC_COURSE_REG_INSERT('TEST2',3 );

--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
SELECT *
FROM TBL_COURSE_REGISTRATION;
/*
3	CAPTAIN	1	
4	TEST	2	
5	TEST2	3	
1	TEST2	3	
2	CAPTAIN	1	
*/
--------------------------------------------------------------------------
---------------------[교수정보 출력 뷰]-----------------------
CREATE OR REPLACE VIEW VIEW_PRO_PRINT
AS
SELECT P1.P_NAME"교수자명",S1.S_NAME"배정된 과목명",C1.S_O_START"과목시작기간"
,C1.S_O_END"과목끝기간",T1.T_NAME"교재명",CR1.CR_LOC"강의실위치"
,CASE WHEN C1.S_O_START < SYSDATE THEN '강의종료'
WHEN C1.S_O_START > SYSDATE THEN '강의중'
WHEN SYSDATE >= C1.S_O_START AND  C1.S_O_END >= SYSDATE THEN '강의진행중'
ELSE
    '강의없음'
END "강의여부"
FROM TBL_PROFESSOR P1 LEFT JOIN TBL_SUBJECT_OPEN C1
ON P1.P_ID = C1.P_ID 
LEFT JOIN TBL_SUBJECT S1
ON S1.S_CODE = C1.S_CODE
LEFT JOIN TBL_TEXTBOOK T1
ON T1.T_CODE = C1.T_CODE
LEFT JOIN TBL_COURSE_OPEN CO
ON CO.C_O_CODE = C1.C_O_CODE
LEFT JOIN TBL_CLASSROOM CR1
ON CR1.CR_CODE = CO.CR_CODE   

ORDER BY 2;
    
/*
박혜민   HTML5+CSS   19/04/18   19/05/15   HIHTML       308호   강의종료
이은채   JAVA       19/10/18   19/11/01   HAPPYJAVA   305호   강의중
이은채   JAVA       19/10/18   19/11/01   HAPPYJAVA   305호   강의중
김동현   ORACLE       19/02/18   19/02/25   BADORACLE   307호   강의종료
김동현   ORACLE       19/02/18   19/02/25   BADORACLE   307호   강의종료
오지은                                                      강의없음
김종범                                                      강의없음
HYEMIN                                                      강의없음
안준헌                                                      강의없음

-> 이은채가 2번 출력되는 경우는 같은 교수이지만 , 안에 S_O_CODE 즉 과목 코드가 다른경우입니다.
*/
-------------------------------------------------------------------------------------

------------------------과정 뷰 생성 ---------------
CREATE OR REPLACE VIEW VIEW_COURSE_PRINT
AS
SELECT B.C_NAME"과정명", C.CR_LOC"강의실위치",S1.S_NAME"과목명",C2.S_O_START"시작기간",S_O_END"끝나는기간",T_NAME"교재명",P_NAME"교수자명"
FROM TBL_COURSE_OPEN A LEFT JOIN TBL_COURSE B
                    ON A.C_CODE = B.C_CODE
                LEFT JOIN TBL_CLASSROOM C
                ON A.CR_CODE = C.CR_CODE
                LEFT JOIN TBL_SUBJECT_OPEN C2
                ON A.C_O_CODE = C2.C_O_CODE
                LEFT JOIN TBL_SUBJECT S1
                ON C2.S_CODE = S1.S_CODE
                LEFT JOIN TBL_TEXTBOOK T1
                ON T1.T_CODE = C2.T_CODE 
                LEFT JOIN TBL_PROFESSOR P1
                ON P1.P_ID = C2.P_ID;
 --==>> View VIEW_COURSE_PRINT이(가) 생성되었습니다.                   
-------------------------------------------
--과정 뷰 실행 --
SELECT *
FROM VIEW_COURSE_PRINT;
/*
JSP연계프로젝트	    307호	ORACLE	19/02/18	19/02/25	BADORACLE	김동현
JSP연계프로젝트	    307호	ORACLE	19/02/18	19/02/25	BADORACLE	김동현
ORACLE연계프로젝트	305호	JAVA	19/10/18	19/11/01	HAPPYJAVA	이은채
ORACLE연계프로젝트	305호	JAVA	19/10/18	19/11/01	HAPPYJAVA	이은채
HTML과CSS	        308호	HTML5+CSS	19/04/18	19/05/15	HIHTML	박혜민          
*/

------------------------과목 뷰 생성 -------------------
CREATE OR REPLACE VIEW VIEW_SUBJECT_PRINT
AS
SELECT C.C_NAME"과정명" , C2.CR_LOC"강의실" , S1.S_NAME"과목명",A.S_O_START"과목시작기간"
,A.S_O_END"과목끝나는기간",T1.T_NAME"교재명",P1.P_NAME"교수자명"
FROM TBL_SUBJECT_OPEN A LEFT JOIN TBL_COURSE_OPEN B
            ON A.C_O_CODE = B.C_O_CODE 
        LEFT JOIN TBL_COURSE C
        ON B.C_CODE = C.C_CODE 
        LEFT JOIN TBL_CLASSROOM C2
        ON C2.CR_CODE = B.CR_CODE 
        LEFT JOIN TBL_SUBJECT S1
        ON S1.S_CODE = A.S_CODE 
        LEFT JOIN TBL_TEXTBOOK T1
        ON T1.T_CODE = A.T_CODE
        LEFT JOIN TBL_PROFESSOR P1
        ON P1.P_ID = A.P_ID;
        --==>> View VIEW_SUBJECT_PRINT이(가) 생성되었습니다.

--과정명 강의실 과목며여 과목기간 교재명 교수자 명

------------------------
--과목 뷰 실행 --
COMMIT;

SELECT *
FROM VIEW_SUBJECT_PRINT;
/*
ORACLE연계프로젝트	305호	JAVA	19/10/18	19/11/01	HAPPYJAVA	이은채
ORACLE연계프로젝트	305호	JAVA	19/10/18	19/11/01	HAPPYJAVA	이은채
JSP연계프로젝트	    307호	ORACLE	19/02/18	19/02/25	BADORACLE	김동현
JSP연계프로젝트	    307호	ORACLE	19/02/18	19/02/25	BADORACLE	김동현
HTML과CSS	        308호	HTML5+CSS	19/04/18	19/05/15	HIHTML	박혜민
*/
---------------------------

-----------------------학생 뷰 생성 --------------------
CREATE OR REPLACE VIEW VIEW_STUDENT_PRIN
AS
SELECT ST.S_NAME"학생이름",CR.C_NAME"과정명",CO2.C_NAME"수강과목",SC.S_C_WRITE+SC.S_C_SKILL+SC.S_C_ATTENDENCE"총점"
FROM TBL_STUDENT ST LEFT JOIN TBL_COURSE_REGISTRATION R1
        ON ST.S_ID = R1.S_ID
        LEFT JOIN TBL_COURSE_OPEN CO
        ON R1.C_O_CODE = CO.C_O_CODE
        LEFT JOIN TBL_COURSE CR
        ON CR.C_CODE = CO.C_CODE
        LEFT JOIN TBL_COURSE CO2
        ON CO2.C_CODE = CO.C_CODE 
        LEFT JOIN TBL_SCORE_CONTROL SC
        ON R1.C_R_CODE = SC.C_R_CODE;
        
 --==>> View VIEW_STUDENT_PRIN이(가) 생성되었습니다.       
 --학생 뷰 실행 --
SELECT *
FROM VIEW_STUDENT_PRIN;
/*
안준헌	ORACLE연계프로젝트	ORACLE연계프로젝트	
이은채	HTML과CSS	HTML과CSS	
안준헌	ORACLE연계프로젝트	ORACLE연계프로젝트	
김동현	JSP연계프로젝트	JSP연계프로젝트	
김동현	JSP연계프로젝트	JSP연계프로젝트	
이은채	HTML과CSS	HTML과CSS	
안준헌	ORACLE연계프로젝트	ORACLE연계프로젝트	70
안준헌	ORACLE연계프로젝트	ORACLE연계프로젝트	
오지은			
박혜민			
김종범			
*/
------------------------
-----------------------------------------------------------
-- 성적처리 업무 뷰 생성-----------
CREATE OR REPLACE VIEW VIEW_SCORE_SET
AS
SELECT ST1.S_NAME"학생이름",SC1.S_C_WRITE"필기",SC1.S_C_SKILL"실기",SC1.S_C_ATTENDENCE"출결",SC1.S_C_WRITE+SC1.S_C_SKILL+SC1.S_C_ATTENDENCE"합" 
FROM TBL_STUDENT ST1 LEFT JOIN TBL_COURSE_REGISTRATION R1
        ON R1.S_ID = ST1.S_ID
        LEFT JOIN  TBL_SCORE_CONTROL SC1
        ON SC1.C_R_CODE = R1.C_R_CODE;
        --==>> View VIEW_SCORE_SET이(가) 생성되었습니다.

SELECT *
FROM VIEW_SCORE_SET;
/*
안준헌				
이은채				
안준헌				
김동현				
김동현				
이은채				
안준헌	20	30	20	70
안준헌				
오지은				
박혜민				
김종범				
*/
---------------------------------

--교수자측 요구분석 -- 
--성적출력 합 업무 뷰 생성------------
--이건 트리거로 처리하기 --
CREATE OR REPLACE VIEW VIEW_PR_SCORE
AS
SELECT SO.S_O_WPO + SO.S_O_SPO + SO.S_O_APO"총합"
FROM TBL_SUBJECT_OPEN SO LEFT JOIN TBL_PROFESSOR PR
        ON SO.P_ID = PR.P_ID;
        
        
SELECT *
FROM VIEW_PR_SCORE;
/*
100
100
100
100
100
*/
----------------------------------------------
--교수자가 강의한 과목에 대한 성적 출력--------------
CREATE OR REPLACE VIEW VIEW_PR_SCORE_ALL
AS
SELECT SU.S_NAME"과목명",A.S_O_START"과목기간",A.S_O_END"과목끝기간"
,TX.T_NAME"교재명", ST.S_NAME"학생명",S_C.S_C_WRITE"필기",S_C.S_C_SKILL"실기",S_C.S_C_ATTENDENCE"출결"
,RANK() OVER (ORDER BY S_C.S_C_WRITE+S_C.S_C_SKILL+S_C.S_C_ATTENDENCE DESC)"등수",S_C.S_C_WRITE+S_C.S_C_SKILL+S_C.S_C_ATTENDENCE "총점" 
FROM TBL_SUBJECT_OPEN A LEFT JOIN TBL_PROFESSOR B
        ON A.P_ID = B.P_ID
       LEFT JOIN TBL_SUBJECT SU
       ON SU.S_CODE = A.S_CODE
       LEFT JOIN TBL_TEXTBOOK TX
       ON TX.T_CODE = A.T_CODE
       LEFT JOIN TBL_COURSE_OPEN CO
       ON CO.C_O_CODE = A.C_O_CODE
       LEFT JOIN TBL_COURSE_REGISTRATION RE
       ON RE.C_O_CODE = CO.C_O_CODE
       LEFT JOIN TBL_STUDENT ST
       ON ST.S_ID = RE.S_ID
       LEFT JOIN TBL_SCORE_CONTROL S_C
       ON S_C.C_R_CODE = RE.C_R_CODE;
       
       -->과정을 중도탈락한 학생도 출력하게끔 수정
       
 SELECT *
FROM VIEW_PR_SCORE_ALL;  
/*
JAVA	19/10/18	19/11/01	HAPPYJAVA	안준헌				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	안준헌				1	
HTML5+CSS	19/04/18	19/05/15	HIHTML	이은채				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	안준헌				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	안준헌				1	
ORACLE	19/02/18	19/02/25	BADORACLE	김동현				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	안준헌				1	
ORACLE	19/02/18	19/02/25	BADORACLE	김동현				1	
ORACLE	19/02/18	19/02/25	BADORACLE	김동현				1	
HTML5+CSS	19/04/18	19/05/15	HIHTML	이은채				1	
ORACLE	19/02/18	19/02/25	BADORACLE	김동현				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	안준헌				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	안준헌	20	30	20	13	70
JAVA	19/10/18	19/11/01	HAPPYJAVA	안준헌	20	30	20	13	70
*/
-----------------------------------------------
--학생측 요구분석 --
--학생로그인 -> 수강을 이미 끝낸 과목만 출력
CREATE OR REPLACE VIEW VIEW_ALREADY_SUBJECT
AS
SELECT ST.S_NAME "학생이름", C.C_NAME "과정명", SU.S_NAME "과목명", CO.C_O_START "과정시작기간", CO.C_O_END "과정끝나는기간"
,TX.T_NAME "교재명", SC.S_C_WRITE"필기",SC.S_C_SKILL"실기",SC.S_C_ATTENDENCE"출결",SC.S_C_WRITE+SC.S_C_SKILL+SC.S_C_ATTENDENCE "총점" 
,RANK() OVER (ORDER BY SC.S_C_WRITE+SC.S_C_SKILL+SC.S_C_ATTENDENCE DESC)"등수"

FROM TBL_STUDENT ST LEFT JOIN TBL_COURSE_REGISTRATION B
     ON ST.S_ID = B.S_ID
     LEFT JOIN TBL_COURSE_OPEN CO
     ON CO.C_O_CODE = B.C_O_CODE
     LEFT JOIN TBL_COURSE C
     ON C.C_CODE = CO.C_CODE
     LEFT JOIN TBL_SUBJECT_OPEN SO
     ON SO.C_O_CODE = CO.C_O_CODE
     LEFT JOIN TBL_SUBJECT SU
     ON SU.S_CODE = SO.S_CODE
     LEFT JOIN TBL_TEXTBOOK TX
     ON TX.T_CODE = SO.T_CODE
     LEFT JOIN TBL_SCORE_CONTROL SC
     ON SC.C_R_CODE = B.C_R_CODE

WHERE CO.C_O_END < SYSDATE;
   --> 수강을 이미 끝낸 과목만 출력
 SELECT *
FROM VIEW_ALREADY_SUBJECT;    
/*
김동현	JSP연계프로젝트	ORACLE	19/02/18	19/03/18	BADORACLE					1
김동현	JSP연계프로젝트	ORACLE	19/02/18	19/03/18	BADORACLE					1
이은채	HTML과CSS	HTML5+CSS	19/04/18	19/05/16	HIHTML					1
김동현	JSP연계프로젝트	ORACLE	19/02/18	19/03/18	BADORACLE					1
이은채	HTML과CSS	HTML5+CSS	19/04/18	19/05/16	HIHTML					1
김동현	JSP연계프로젝트	ORACLE	19/02/18	19/03/18	BADORACLE					1
*/
-------------------------------------------------------
-- 중도탈락 뷰--
  CREATE OR REPLACE VIEW VIEW_FAIL_PRINT
  AS 
  SELECT C_R_CODE,F_DATE,F_REASON
  FROM TBL_FAIL;
  
  SELECT *
FROM VIEW_FAIL_PRINT; 
--===>> 결과 없음
  
