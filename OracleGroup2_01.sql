SELECT USER
FROM DUAL;
-- �� TABLESPACE ����
CREATE TABLESPACE PROJECT
DATAFILE 'c:\PROJECT\TBS_SIST01.dbf'   
SIZE 100m                                
EXTENT MANAGEMENT LOCAL                 
SEGMENT SPACE MANAGEMENT AUTO;          
--==>> Tablespace PROJECT��(��) �����Ǿ����ϴ�.

-- �� SIST01 ������ ���Ѻο�
create user SIST01 identified by java006$
default tablespace PROJECT;

GRANT CREATE TABLE TO sist01;

ALTER USER SIST01 DEFAULT TABLESPACE USERS;

GRANT CREATE SESSION TO SIST01;

--���� ���̺� ���� ����--
--�� ������ ���̺� ����
CREATE TABLE TBL_ADMIN
( A_ID VARCHAR2(40)    CONSTRAINT ADMINE_A_ID_NN NOT NULL -- ������ ID
, A_PW VARCHAR2(16)    CONSTRAINT ADMINE_A_PW_NN NOT NULL -- ������ PW
, CONSTRAINT TBL_ADMIN_A_ID_UK UNIQUE (A_ID)              
);

--�� ���� ���̺� ����
CREATE TABLE TBL_COURSE
( C_CODE NUMBER                                              -- ���� �ڵ�
, C_NAME VARCHAR2(10)    CONSTRAINT COURSE_C_NAME_NN NOT NULL -- ���� �̸�
, CONSTRAINT TBL_COURSE_C_CODE_PK PRIMARY KEY (C_CODE)
);

--�� ������ ���̺� ����
CREATE TABLE TBL_PROFESSOR
( P_ID      VARCHAR2(20)                                           -- ������ ID
, P_PW      VARCHAR2(16)                                           -- ������ PW
, P_NAME    VARCHAR2(10)    CONSTRAINT PROFESSOR_T_NAME_NN NOT NULL -- ������ �̸�
, P_SSN     CHAR(7)         CONSTRAINT PROFESSOR_T_SSN_NN NOT NULL  -- �ֹε�Ϲ�ȣ���ڸ�
, CONSTRAINT PROFESSORL_P_ID_PK PRIMARY KEY (P_ID)
);

--�� ���ǽ� ���̺� ����
CREATE TABLE TBL_CLASSROOM 
( CR_CODE   NUMBER                                                 -- ���ǽ� �ڵ� 
, CR_LOC    VARCHAR2(10) CONSTRAINT CLASSROOM_CR_LOC_NN NOT NULL    -- ���ǽ� ��ġ
, CR_CAPA   NUMBER       CONSTRAINT CLASSROOM_CR_CAPA_NN NOT NULL   -- �ִ�����
, CONSTRAINT CLASSROOM_CR_CODE_PK PRIMARY KEY (CR_CODE)
);

--�� �л� ���̺� ����  
CREATE TABLE TBL_STUDENT
( S_ID      VARCHAR2(20)    -- �л� ID
, S_PW      VARCHAR2(16) CONSTRAINT STUDENT_S_PW_NN NOT NULL    -- �л� PW
, S_NAME    VARCHAR2(10) CONSTRAINT STUDENT_S_NAME_NN NOT NULL  -- �л� �̸�
, S_SSN     CHAR(7)      CONSTRAINT STUDENT_S_SSN_NN NOT NULL   -- �ֹε�Ϲ�ȣ
, CONSTRAINT STUDENT_S_ID_PK PRIMARY KEY (S_ID)
);

--�� ���� ���̺� ����
CREATE TABLE TBL_TEXTBOOK
( T_CODE      NUMBER                                              -- ���� �ڵ�
, T_NAME      VARCHAR2(10)  CONSTRAINT TEXTBOOK_T_NAME_NN NOT NULL -- ���� �̸�
, T_PUB       VARCHAR2(10)  CONSTRAINT TEXTBOOK_T_PUB_NN NOT NULL  -- ���ǻ�
, CONSTRAINT TEXTBOOK_T_CODE_PK PRIMARY KEY (T_CODE)
);

--�� ���� ���̺� ����
CREATE TABLE TBL_SUBJECT
( S_CODE    NUMBER                                              -- ���� �ڵ�
, S_NAME    VARCHAR2(16)   CONSTRAINT SUBJECT_S_NAME_NN NOT NULL -- ���� �̸�
, CONSTRAINT SUBJECT_S_CODE_PK PRIMARY KEY (S_CODE)
);

--�� �������� ���̺� ����
CREATE TABLE TBL_COURSE_OPEN
( C_O_CODE  NUMBER                                              -- �������� �ڵ�
, C_CODE    NUMBER  CONSTRAINT COURSE_OPEN_C_CODE_NN NOT NULL    -- ���� �ڵ�
, CR_CODE   NUMBER  CONSTRAINT COURSE_OPEN_CR_CODE_NN NOT NULL   -- ���ǽ� �ڵ�
, CONSTRAINT COURSE_OPEN_CODE_PK PRIMARY KEY (C_O_CODE)
);

--�� ���񰳼� ���̺� ����
CREATE TABLE TBL_SUBJECT_OPEN
( S_O_CODE  NUMBER                                                      -- ���񰳼� �ڵ�
, C_O_CODE  NUMBER         CONSTRAINT SUBJECT_OPEN_C_O_CODE_NN NOT NULL  -- �������� �ڵ�
, P_ID      VARCHAR2(20)   CONSTRAINT SUBJECT_OPEN_P_ID_NN NOT NULL      -- ������ ���̵�  
, S_CODE    NUMBER         CONSTRAINT SUBJECT_OPEN_S_CODE_NN NOT NULL    -- ���� �ڵ�
, T_CODE    NUMBER         CONSTRAINT SUBJECT_OPEN_T_CODE_NN NOT NULL    -- ���� �ڵ�
, S_O_WPO   NUMBER                                                      -- �ʱ� ����
, S_O_SPO   NUMBER                                                      -- �Ǳ� ����
, S_O_APO   NUMBER                                                      -- ��� ����
, S_O_START DATE           CONSTRAINT SUBJECT_OPEN_S_O_START_NN NOT NULL -- ���� ����
, S_O_END   DATE           CONSTRAINT SUBJECT_OPEN_S_O_END_NN NOT NULL   -- ���� ��
, CONSTRAINT TBL_SUBJECT_OPEN_S_O_CODE_PK PRIMARY KEY (S_O_CODE)
, CONSTRAINT TBL_SUBJECT_OPEN_CK CHECK (S_O_WPO + S_O_SPO + S_O_APO = 100)
, CONSTRAINT SUBJECT_OPEN_S_O_END_CK CHECK (S_O_END > S_O_START)
, CONSTRAINT SUBJECT_OPEN_S_O_START_CK CHECK (S_O_START < S_O_END)
);

--�� ������û ���̺� ����
CREATE TABLE TBL_COURSE_REGISTRATION
( C_R_CODE NUMBER                                                 -- ������û �ڵ�
, S_ID     VARCHAR2(20) CONSTRAINT COURSE_REG_S_ID_NN NOT NULL     -- �л� ID
, C_O_CODE NUMBER       CONSTRAINT COURSE_REG_C_O_CODE_NN NOT NULL -- �������� �ڵ�
, C_R_DATE DATE                                                   -- ������û ����
, CONSTRAINT COURSE_REG_C_R_CODE_PK PRIMARY KEY (C_R_CODE)
);

--�� ����ó������ ���̺� ����
CREATE TABLE TBL_SCORE_CONTROL
( C_R_CODE          NUMBER  -- ������û �ڵ�
, S_O_CODE          NUMBER  -- �������� �ڵ�
, S_C_WRITE         NUMBER  -- �ʱ� ����
, S_C_SKILL         NUMBER  -- �Ǳ� ����
, S_C_ATTENDENCE    NUMBER  -- �⼮ ����
, CONSTRAINT SCORE_CONTROL_C_R_CODE_UK UNIQUE (C_R_CODE)
, CONSTRAINT SCORE_CONTROL_S_O_CODE_UK UNIQUE (S_O_CODE)
);

--�� �ߵ�Ż�� ���̺� ����
CREATE TABLE TBL_FAIL
( C_R_CODE NUMBER   CONSTRAINT FAIL_C_R_CODE_NN NOT NULL -- ������û �ڵ�
, F_DATE   DATE     CONSTRAINT FAIL_F_DATE_NN NOT NULL   -- Ż�� ��¥
);


--���� ���̺� ���� �߰� ����--
--�� �������� ���̺� ���۳�, ���� �÷� �߰�
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

--�� ���񰳼� ����
ALTER TABLE TBL_SUBJECT_OPEN
ADD( CONSTRAINT SUBJECT_OPEN_S_CODE_FK FOREIGN KEY (S_CODE)
       REFERENCES TBL_SUBJECT (S_CODE) ON DELETE CASCADE
   , CONSTRAINT SUBJECT_OPEN_T_CODE_FK FOREIGN KEY (T_CODE)
       REFERENCES TBL_TEXTBOOK (T_CODE) ON DELETE CASCADE
   , CONSTRAINT SUBJECT_OPEN_C_O_CODE_FK FOREIGN KEY (C_O_CODE)
       REFERENCES TBL_COURSE_OPEN (C_O_CODE) ON DELETE CASCADE
   , CONSTRAINT SUBJECT_OPEN_P_ID_FK FOREIGN KEY (P_ID)
       REFERENCES TBL_PROFESSOR (P_ID) ON DELETE CASCADE);

--�� ������û ����
ALTER TABLE TBL_COURSE_REGISTRATION
ADD( CONSTRAINT REGISTRATION_C_O_CODE_FK FOREIGN KEY (C_O_CODE)
        REFERENCES TBL_COURSE_OPEN (C_O_CODE) ON DELETE CASCADE
   , CONSTRAINT REGISTRATION_S_ID_FK FOREIGN KEY (S_ID)
        REFERENCES TBL_STUDENT (S_ID) ON DELETE CASCADE);

--�� ����ó�� ����
ALTER TABLE TBL_SCORE_CONTROL
ADD( CONSTRAINT SCORE_CONTROL_S_O_CODE_FK FOREIGN KEY (S_O_CODE)
        REFERENCES TBL_SUBJECT_OPEN (S_O_CODE) ON DELETE CASCADE
   , CONSTRAINT SCORE_CONTROL_C_R_CODE_FK FOREIGN KEY (C_R_CODE)
        REFERENCES TBL_COURSE_REGISTRATION (C_R_CODE) ON DELETE CASCADE);

--�� �ߵ�Ż�� ����
ALTER TABLE TBL_FAIL
ADD (F_REASON VARCHAR2(100 BYTE));

ALTER TABLE TBL_FAIL
ADD( CONSTRAINT FAIL_C_R_CODE_FK FOREIGN KEY (C_R_CODE)
        REFERENCES TBL_COURSE_REGISTRATION (C_R_CODE) ON DELETE CASCADE);
--==>> SIST01
--[������ ���� INSERT]--------------------------------------
INSERT INTO TBL_ADMIN(A_ID,A_PW) VALUES('HOJINI','JAVA006$');
/*
HOJINI   JAVA006$
*/
------------------------------------------------------------
--[PRC_PROFESSOR_INSERT] ������ �Է� �� Ȯ��----------------
-- EXEC PRC_PROFESSOR_INSERT (������ID,'�������̸�','������ SSN');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO01','����ä','1234567');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO02','������','2345678');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO03','������','3456789');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO04','������','4567890');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO05','������','5647890');
EXEC PRC_PROFESSOR_INSERT ('SISTPRO06','�赿��','6789123');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�. *6

SELECT *
FROM TBL_PROFESSOR;
/*
SISTPRO01	1234567	����ä	1234567
SISTPRO02	2345678	������	2345678
SISTPRO03	3456789	������	3456789
SISTPRO04	4567890	������	4567890
SISTPRO05	5647890	������	5647890
SISTPRO06	6789123	�赿��	6789123
*/
------------------------------------------------------------------
--[PRC_BOOK] ������ �Է� �� Ȯ��----------------------------------
-- EXEC PRC_BOOK('å�̸�','���ǻ�');
EXEC PRC_BOOK('HAPPYJAVA','������');
EXEC PRC_BOOK('GOODJAVA','���ƺ�');
EXEC PRC_BOOK('BADORACLE','�����');
EXEC PRC_BOOK('EASYORACLE','���ƺ�');
EXEC PRC_BOOK('HIHTML','���غ�');

SELECT *
FROM TBL_TEXTBOOK;
/*
1   HAPPYJAVA   ������
2   GOODJAVA   ���ƺ�
3   BADORACLE   �����
4   EASYORACLE   ���ƺ�
5   HIHTML       ���غ�
*/
---------------------------------------------------------------------------------
--[PRC_ADMIN_COURSE_INSERT] ������ �Է� �� Ȯ��----------------------------------
-- EXEC PRC_ADMIN_COURSE_INSERT('������');
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
--[PRC_ADMIN_CLASSROOM_INSERT] ������ �Է� �� Ȯ��----------------

--���ǽ� INSERT--
-- EXEC PRC_ADMIN_CLASSROOM_INSERT('���ǽ���ġ',������);
EXEC PRC_ADMIN_CLASSROOM_INSERT('305ȣ',20);
EXEC PRC_ADMIN_CLASSROOM_INSERT('306ȣ',30);
EXEC PRC_ADMIN_CLASSROOM_INSERT('307ȣ',35);
EXEC PRC_ADMIN_CLASSROOM_INSERT('308ȣ',30);
EXEC PRC_ADMIN_CLASSROOM_INSERT('309ȣ',20);

SELECT *
FROM TBL_CLASSROOM

/*
1   305ȣ   20
2   306ȣ   30
3   307ȣ   35
4   308ȣ   30
5   309ȣ   20
*/
------------------------------------------------------------------
--[PRC_STUDENT_INSERT] ������ �Է� �� Ȯ��------------------------
-- EXEC PRC_STUDENT_INSERT('�л� ID', '�л���', '�л�SSN');
EXEC PRC_STUDENT_INSERT('CAPTAIN', '������', '1234567');
EXEC PRC_STUDENT_INSERT('TEST', '�赿��', '2345678');
EXEC PRC_STUDENT_INSERT('TEST2', '����ä', '2345678');
EXEC PRC_STUDENT_INSERT('TEST3', '������', '3456789');
EXEC PRC_STUDENT_INSERT('TEST4', '������', '4567891');
EXEC PRC_STUDENT_INSERT('TEST5', '������', '5678910');

SELECT *
FROM TBL_STUDENT;
/*
CAPTAIN   1234567   ������   1234567
TEST   2345678   �赿��   2345678
TEST5   5678910   ������   5678910
TEST4   4567891   ������   4567891
TEST3   3456789   ������   3456789
TEST2   2345678   ����ä   2345678
*/
------------------------------------------------------------------
--[PRC_SUBJECT_INSERT] ������ �Է� �� Ȯ��------------------------
-- EXEC PRC_SUBJECT_INSERT('�����̸�');
EXEC PRC_SUBJECT_INSERT('JAVA');
EXEC PRC_SUBJECT_INSERT('ORACLE');
EXEC PRC_SUBJECT_INSERT('C++');
EXEC PRC_SUBJECT_INSERT('HTML5+CSS');
EXEC PRC_SUBJECT_INSERT('ANDROID');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�. *5

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
--[PRC_ADMIN_C_O_INSERT] ������ �Է� �� Ȯ��------------------------
-- EXEC PRC_ADMIN_C_O_INSERT ('������',�������۳�¥,����������¥,���ǽ���ġ);

-- PRC_ADMIN_C_O_INSERT ���ν��� Ȯ��
-- ���� ���̺�� ���ǽ� ���̺� �ִ� �����ͷ� �Է��ؾ���!!

EXEC PRC_ADMIN_C_O_INSERT ('ORACLE',TO_DATE('191018','YYMMDD'),TO_DATE('191118','YYMMDD'),'305ȣ');
EXEC PRC_ADMIN_C_O_INSERT ('JAVA',TO_DATE('191218','YYMMDD'),TO_DATE('190118','YYMMDD'),'306ȣ');
EXEC PRC_ADMIN_C_O_INSERT ('JSP',TO_DATE('190218','YYMMDD'),TO_DATE('190318','YYMMDD'),'307ȣ');
EXEC PRC_ADMIN_C_O_INSERT ('HTML5',TO_DATE('190418','YYMMDD'),TO_DATE('190518','YYMMDD'),'308ȣ');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�. *4
-- ���� ���� ���̺� Ȯ��
SELECT *
FROM TBL_COURSE_OPEN;
/*
3	5	4	19/04/18	19/05/18
1	2	1	19/10/18	19/11/18
2	3	3	19/02/18	19/03/18
*/
--------------------------------------------------------------------
--[PRC_ADMIN_S_O_INSERT] ������ �Է� �� Ȯ��------------------------
-- EXEC PRC_ADMIN_S_O_INSERT(���������ڵ�,�����,������۳���,���񳡳�����,�����,������);

-- ��ϵ� �������� �ڵ� �Է�
-- ����Ⱓ�� ��ϵ� �����Ⱓ�����Ϻ��� �۰ų� �����±Ⱓ���� ũ�� �ȵ�!
-- �������̺��� ��ϵ� ������ ��ϵ� ���������� �����͸� �Է��ؾ��� !!

EXEC PRC_ADMIN_S_O_INSERT(1,'JAVA',TO_DATE('191018','YYMMDD'),TO_DATE('191101','YYMMDD'),'HAPPYJAVA','����ä' );
EXEC PRC_ADMIN_S_O_INSERT(2,'ORACLE',TO_DATE('190218','YYMMDD'),TO_DATE('190225','YYMMDD'),'BADORACLE','�赿��' );
EXEC PRC_ADMIN_S_O_INSERT(3,'HTML5+CSS',TO_DATE('190418','YYMMDD'),TO_DATE('190515','YYMMDD'),'HIHTML','������' );


--==>> Procedure PRC_PRO_PRINT��(��) �����ϵǾ����ϴ�.

-- ���� ���� ���̺� Ȯ��
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
--[PRC_SET_POINT] ������ �Է� �� Ȯ��----------------------------------
-- EXEC PRC_SET_POINT(���񰳼���ȣ,�ʱ����,�Ǳ����,������);

-- ��ϵ� ���� ������ �����ڵ带 �Է��ؾ���!
EXEC PRC_SET_POINT(1,40,40,20);
EXEC PRC_SET_POINT(2,40,30,30);
EXEC PRC_SET_POINT(3,45,45,10);
EXEC PRC_SET_POINT(4,45,45,10);
EXEC PRC_SET_POINT(5,45,45,10);
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�. *5
-- ���� ���� ���̺� Ȯ��
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

--[PRC_COURSE_REG_INSERT] ������ �Է� �� Ȯ��-----------------------------
-- EXEC PRC_COURSE_REG_INSERT(�л� ID,���������ڵ� );

-- ��ϵ� �л� ID , �������� �ڵ� �Է�
EXEC PRC_COURSE_REG_INSERT('CAPTAIN',1 );
EXEC PRC_COURSE_REG_INSERT('TEST',2 );
EXEC PRC_COURSE_REG_INSERT('TEST2',3 );

--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
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
---------------------[�������� ��� ��]-----------------------
CREATE OR REPLACE VIEW VIEW_PRO_PRINT
AS
SELECT P1.P_NAME"�����ڸ�",S1.S_NAME"������ �����",C1.S_O_START"������۱Ⱓ"
,C1.S_O_END"���񳡱Ⱓ",T1.T_NAME"�����",CR1.CR_LOC"���ǽ���ġ"
,CASE WHEN C1.S_O_START < SYSDATE THEN '��������'
WHEN C1.S_O_START > SYSDATE THEN '������'
WHEN SYSDATE >= C1.S_O_START AND  C1.S_O_END >= SYSDATE THEN '����������'
ELSE
    '���Ǿ���'
END "���ǿ���"
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
������   HTML5+CSS   19/04/18   19/05/15   HIHTML       308ȣ   ��������
����ä   JAVA       19/10/18   19/11/01   HAPPYJAVA   305ȣ   ������
����ä   JAVA       19/10/18   19/11/01   HAPPYJAVA   305ȣ   ������
�赿��   ORACLE       19/02/18   19/02/25   BADORACLE   307ȣ   ��������
�赿��   ORACLE       19/02/18   19/02/25   BADORACLE   307ȣ   ��������
������                                                      ���Ǿ���
������                                                      ���Ǿ���
HYEMIN                                                      ���Ǿ���
������                                                      ���Ǿ���

-> ����ä�� 2�� ��µǴ� ���� ���� ���������� , �ȿ� S_O_CODE �� ���� �ڵ尡 �ٸ�����Դϴ�.
*/
-------------------------------------------------------------------------------------

------------------------���� �� ���� ---------------
CREATE OR REPLACE VIEW VIEW_COURSE_PRINT
AS
SELECT B.C_NAME"������", C.CR_LOC"���ǽ���ġ",S1.S_NAME"�����",C2.S_O_START"���۱Ⱓ",S_O_END"�����±Ⱓ",T_NAME"�����",P_NAME"�����ڸ�"
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
 --==>> View VIEW_COURSE_PRINT��(��) �����Ǿ����ϴ�.                   
-------------------------------------------
--���� �� ���� --
SELECT *
FROM VIEW_COURSE_PRINT;
/*
JSP����������Ʈ	    307ȣ	ORACLE	19/02/18	19/02/25	BADORACLE	�赿��
JSP����������Ʈ	    307ȣ	ORACLE	19/02/18	19/02/25	BADORACLE	�赿��
ORACLE����������Ʈ	305ȣ	JAVA	19/10/18	19/11/01	HAPPYJAVA	����ä
ORACLE����������Ʈ	305ȣ	JAVA	19/10/18	19/11/01	HAPPYJAVA	����ä
HTML��CSS	        308ȣ	HTML5+CSS	19/04/18	19/05/15	HIHTML	������          
*/

------------------------���� �� ���� -------------------
CREATE OR REPLACE VIEW VIEW_SUBJECT_PRINT
AS
SELECT C.C_NAME"������" , C2.CR_LOC"���ǽ�" , S1.S_NAME"�����",A.S_O_START"������۱Ⱓ"
,A.S_O_END"���񳡳��±Ⱓ",T1.T_NAME"�����",P1.P_NAME"�����ڸ�"
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
        --==>> View VIEW_SUBJECT_PRINT��(��) �����Ǿ����ϴ�.

--������ ���ǽ� ����翩 ����Ⱓ ����� ������ ��

------------------------
--���� �� ���� --
COMMIT;

SELECT *
FROM VIEW_SUBJECT_PRINT;
/*
ORACLE����������Ʈ	305ȣ	JAVA	19/10/18	19/11/01	HAPPYJAVA	����ä
ORACLE����������Ʈ	305ȣ	JAVA	19/10/18	19/11/01	HAPPYJAVA	����ä
JSP����������Ʈ	    307ȣ	ORACLE	19/02/18	19/02/25	BADORACLE	�赿��
JSP����������Ʈ	    307ȣ	ORACLE	19/02/18	19/02/25	BADORACLE	�赿��
HTML��CSS	        308ȣ	HTML5+CSS	19/04/18	19/05/15	HIHTML	������
*/
---------------------------

-----------------------�л� �� ���� --------------------
CREATE OR REPLACE VIEW VIEW_STUDENT_PRIN
AS
SELECT ST.S_NAME"�л��̸�",CR.C_NAME"������",CO2.C_NAME"��������",SC.S_C_WRITE+SC.S_C_SKILL+SC.S_C_ATTENDENCE"����"
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
        
 --==>> View VIEW_STUDENT_PRIN��(��) �����Ǿ����ϴ�.       
 --�л� �� ���� --
SELECT *
FROM VIEW_STUDENT_PRIN;
/*
������	ORACLE����������Ʈ	ORACLE����������Ʈ	
����ä	HTML��CSS	HTML��CSS	
������	ORACLE����������Ʈ	ORACLE����������Ʈ	
�赿��	JSP����������Ʈ	JSP����������Ʈ	
�赿��	JSP����������Ʈ	JSP����������Ʈ	
����ä	HTML��CSS	HTML��CSS	
������	ORACLE����������Ʈ	ORACLE����������Ʈ	70
������	ORACLE����������Ʈ	ORACLE����������Ʈ	
������			
������			
������			
*/
------------------------
-----------------------------------------------------------
-- ����ó�� ���� �� ����-----------
CREATE OR REPLACE VIEW VIEW_SCORE_SET
AS
SELECT ST1.S_NAME"�л��̸�",SC1.S_C_WRITE"�ʱ�",SC1.S_C_SKILL"�Ǳ�",SC1.S_C_ATTENDENCE"���",SC1.S_C_WRITE+SC1.S_C_SKILL+SC1.S_C_ATTENDENCE"��" 
FROM TBL_STUDENT ST1 LEFT JOIN TBL_COURSE_REGISTRATION R1
        ON R1.S_ID = ST1.S_ID
        LEFT JOIN  TBL_SCORE_CONTROL SC1
        ON SC1.C_R_CODE = R1.C_R_CODE;
        --==>> View VIEW_SCORE_SET��(��) �����Ǿ����ϴ�.

SELECT *
FROM VIEW_SCORE_SET;
/*
������				
����ä				
������				
�赿��				
�赿��				
����ä				
������	20	30	20	70
������				
������				
������				
������				
*/
---------------------------------

--�������� �䱸�м� -- 
--������� �� ���� �� ����------------
--�̰� Ʈ���ŷ� ó���ϱ� --
CREATE OR REPLACE VIEW VIEW_PR_SCORE
AS
SELECT SO.S_O_WPO + SO.S_O_SPO + SO.S_O_APO"����"
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
--�����ڰ� ������ ���� ���� ���� ���--------------
CREATE OR REPLACE VIEW VIEW_PR_SCORE_ALL
AS
SELECT SU.S_NAME"�����",A.S_O_START"����Ⱓ",A.S_O_END"���񳡱Ⱓ"
,TX.T_NAME"�����", ST.S_NAME"�л���",S_C.S_C_WRITE"�ʱ�",S_C.S_C_SKILL"�Ǳ�",S_C.S_C_ATTENDENCE"���"
,RANK() OVER (ORDER BY S_C.S_C_WRITE+S_C.S_C_SKILL+S_C.S_C_ATTENDENCE DESC)"���",S_C.S_C_WRITE+S_C.S_C_SKILL+S_C.S_C_ATTENDENCE "����" 
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
       
       -->������ �ߵ�Ż���� �л��� ����ϰԲ� ����
       
 SELECT *
FROM VIEW_PR_SCORE_ALL;  
/*
JAVA	19/10/18	19/11/01	HAPPYJAVA	������				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	������				1	
HTML5+CSS	19/04/18	19/05/15	HIHTML	����ä				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	������				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	������				1	
ORACLE	19/02/18	19/02/25	BADORACLE	�赿��				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	������				1	
ORACLE	19/02/18	19/02/25	BADORACLE	�赿��				1	
ORACLE	19/02/18	19/02/25	BADORACLE	�赿��				1	
HTML5+CSS	19/04/18	19/05/15	HIHTML	����ä				1	
ORACLE	19/02/18	19/02/25	BADORACLE	�赿��				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	������				1	
JAVA	19/10/18	19/11/01	HAPPYJAVA	������	20	30	20	13	70
JAVA	19/10/18	19/11/01	HAPPYJAVA	������	20	30	20	13	70
*/
-----------------------------------------------
--�л��� �䱸�м� --
--�л��α��� -> ������ �̹� ���� ���� ���
CREATE OR REPLACE VIEW VIEW_ALREADY_SUBJECT
AS
SELECT ST.S_NAME "�л��̸�", C.C_NAME "������", SU.S_NAME "�����", CO.C_O_START "�������۱Ⱓ", CO.C_O_END "���������±Ⱓ"
,TX.T_NAME "�����", SC.S_C_WRITE"�ʱ�",SC.S_C_SKILL"�Ǳ�",SC.S_C_ATTENDENCE"���",SC.S_C_WRITE+SC.S_C_SKILL+SC.S_C_ATTENDENCE "����" 
,RANK() OVER (ORDER BY SC.S_C_WRITE+SC.S_C_SKILL+SC.S_C_ATTENDENCE DESC)"���"

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
   --> ������ �̹� ���� ���� ���
 SELECT *
FROM VIEW_ALREADY_SUBJECT;    
/*
�赿��	JSP����������Ʈ	ORACLE	19/02/18	19/03/18	BADORACLE					1
�赿��	JSP����������Ʈ	ORACLE	19/02/18	19/03/18	BADORACLE					1
����ä	HTML��CSS	HTML5+CSS	19/04/18	19/05/16	HIHTML					1
�赿��	JSP����������Ʈ	ORACLE	19/02/18	19/03/18	BADORACLE					1
����ä	HTML��CSS	HTML5+CSS	19/04/18	19/05/16	HIHTML					1
�赿��	JSP����������Ʈ	ORACLE	19/02/18	19/03/18	BADORACLE					1
*/
-------------------------------------------------------
-- �ߵ�Ż�� ��--
  CREATE OR REPLACE VIEW VIEW_FAIL_PRINT
  AS 
  SELECT C_R_CODE,F_DATE,F_REASON
  FROM TBL_FAIL;
  
  SELECT *
FROM VIEW_FAIL_PRINT; 
--===>> ��� ����
  
