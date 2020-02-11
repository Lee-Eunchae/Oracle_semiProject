
----------------------[PRC_PROFESSOR_INSERT] ���ν���----------------------
create or replace PROCEDURE PRC_PROFESSOR_INSERT    -- �����Է� ���ν���
(
V_P_ID IN TBL_PROFESSOR.P_ID%TYPE                   -- ������ ID
,V_P_NAME IN TBL_PROFESSOR.P_NAME%TYPE              -- ������ �̸�
,V_P_SSN IN TBL_PROFESSOR.P_SSN%TYPE                -- ������ �ֹι�ȣ
)
IS

V_P_PW  TBL_PROFESSOR.P_PW%TYPE;

BEGIN

    V_P_PW :=V_P_SSN;

    INSERT INTO TBL_PROFESSOR
    VALUES(V_P_ID,V_P_PW,V_P_NAME,V_P_SSN);

    COMMIT;
END;
--==>> Procedure PRC_PROFESSOR_INSERT��(��) �����ϵǾ����ϴ�.
-----------------------------------------------------------------------------
----------------------[PRC_BOOK] ���ν���--------------------------
CREATE OR REPLACE PROCEDURE PRC_BOOK        -- ������ BOOK ��� ���ν���
(
 V_NAME IN TBL_TEXTBOOK.T_NAME%TYPE         --�����
,V_PUB  IN TBL_TEXTBOOK.T_PUB%TYPE          --���ǻ�
)
IS

 V_CODE TBL_TEXTBOOK.T_CODE%TYPE;

BEGIN

    SELECT NVL(MAX(T_CODE) , 0 )            --�����ڵ��ȣ COUNT �ڵ� ���� 
    INTO V_CODE
    FROM TBL_TEXTBOOK;
    
    INSERT INTO TBL_TEXTBOOK(T_CODE,T_NAME,T_PUB)   
    VALUES (V_CODE+1  , V_NAME , V_PUB);

END;
--==>> Procedure PRC_BOOK��(��) �����ϵǾ����ϴ�.
-------------------------------------------------------------------
----------------------[PRC_ADMIN_COURSE_INSERT] ���ν���-----------------------

create or replace PROCEDURE PRC_ADMIN_COURSE_INSERT     -- ������� ���ν���
(
    V_A_C_NAME IN TBL_COURSE.C_NAME%TYPE    -- ���� �̸�
)
IS
    V_A_CODE TBL_COURSE.C_CODE%TYPE;        -- �����ڵ�

BEGIN
    -- ���������� �ο��� ���� �ڵ�
    SELECT NVL(MAX(C_CODE) , 0 ) INTO V_A_CODE  
    FROM TBL_COURSE;

    -- INSERT ����
    INSERT INTO TBL_COURSE(C_CODE,C_NAME)       
    VALUES(V_A_CODE +1 , V_A_C_NAME);

    COMMIT;

END;
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
--[PRC_ADMIN_COURSE_INSERT] ���ν��� Ȯ��

EXEC PRC_ADMIN_COURSE_INSERT('SARANGNI');
--==>> Procedure PRC_ADMIN_COURSE_INSERT��(��) �����ϵǾ����ϴ�.
SELECT *
FROM TBL_COURSE;
--==>> 7   SARANGNI
-------------------------------------------------------------------------------
----------------------[PRC_ADMIN_CLASSROOM_INSERT] ���ν��� ----------------------
create or replace PROCEDURE  PRC_ADMIN_CLASSROOM_INSERT     -- ���ǽ� ��� ���ν���
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
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
--[PRC_ADMIN_CLASSROOM_INSERT] ���ν��� Ȯ��

-- ���ο� ������ �̸�, ���� �Է�
EXEC PRC_ADMIN_CLASSROOM_INSERT('G',45);
--==>> Procedure PRC_ADMIN_CLASSROOM_INSERT��(��) �����ϵǾ����ϴ�.

SELECT *
FROM TBL_CLASSROOM;
--==>> 4   G   45
-------------------------------------------------------------------------------
----------------------[PRC_STUDENT_INSERT] ���ν��� ----------------------

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
--==>> Procedure PRC_STUDENT_INSERT��(��) �����ϵǾ����ϴ�.
--------------------------------------------------------------------------
----------------------[PRC_SUBJECT_INSERT] ���ν��� ----------------------
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
 --==>> Procedure PRC_SUBJECT_INSERT��(��) �����ϵǾ����ϴ�.
 --------------------------------------------------------------------------
 ----------------------[PRC_ADMIN_C_O_INSERT] ���ν���---------------------
create or replace PROCEDURE PRC_ADMIN_C_O_INSERT    -- ������� ���ν���
(V_C_NAME       TBL_COURSE.C_NAME%TYPE          -- ������
,V_C_O_START    TBL_COURSE_OPEN.C_O_START%TYPE  -- ���� ���۳�¥
,V_C_O_END      TBL_COURSE_OPEN.C_O_END%TYPE    -- ���� ������¥
,V_CR_LOC       TBL_CLASSROOM.CR_LOC%TYPE       -- ���ǽ� ��ġ
)
IS
    V_C_O_CODE  TBL_COURSE_OPEN.C_O_CODE%TYPE;  -- ���������ڵ�
    V_C_CODE    TBL_COURSE.C_CODE%TYPE;         -- �����ڵ�
    V_CR_CODE   TBL_CLASSROOM.CR_CODE%TYPE;     -- ���ǽ� �ڵ�

BEGIN
    -- �������� ���̺��� ���������ڵ带 1�������Ͽ� V_C_O_CODE �� INTO
    SELECT NVL(MAX(C_O_CODE),0) + 1 INTO V_C_O_CODE 
    FROM TBL_COURSE_OPEN;

    -- ���� ���̺��� �������� �Է� �Ķ���� ���� ������ V_C_CODE �� INTO
    SELECT C_CODE INTO V_C_CODE
    FROM TBL_COURSE
    WHERE C_NAME = V_C_NAME;

    -- ���ǽ� ���̺��� ���ǽ� ��ġ�� �Է� �Ķ���Ϳ� ���� �� INTO
    SELECT CR_CODE INTO V_CR_CODE
    FROM TBL_CLASSROOM
    WHERE CR_LOC = V_CR_LOC;

    -- INSERT INTO 
    INSERT INTO TBL_COURSE_OPEN(C_O_CODE, C_CODE, CR_CODE, C_O_START, C_O_END)
    VALUES (V_C_O_CODE, V_C_CODE, V_CR_CODE, V_C_O_START, V_C_O_END);

    COMMIT;

        EXCEPTION
        WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('����!����!');
                ROLLBACK;

END;
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
--------------------------------------------------------------------------------
 ----------------------[PRC_ADMIN_S_O_INSERT] ���ν���--------------------------
create or replace PROCEDURE PRC_ADMIN_S_O_INSERT    -- ���� ���� ���ν���
(V_C_O_CODE     IN TBL_COURSE_OPEN.C_O_CODE%TYPE    -- ���� ���� �ڵ�
,V_S_NAME      IN TBL_SUBJECT.S_NAME%TYPE           -- �����
,V_S_O_START  IN  TBL_SUBJECT_OPEN.S_O_START%TYPE   -- ���� ���� �Ⱓ
,V_S_O_END    IN  TBL_SUBJECT_OPEN.S_O_END%TYPE     -- ���� ���� �Ⱓ
,V_T_NAME     IN  TBL_TEXTBOOK.T_NAME%TYPE          -- �����
,V_P_NAME     IN  TBL_PROFESSOR.P_NAME%TYPE         -- ������
)
IS
    V_S_O_CODE          TBL_SUBJECT_OPEN.S_O_CODE%TYPE; 
    V_P_ID              TBL_PROFESSOR.P_ID%TYPE;        
    V_S_CODE            TBL_SUBJECT.S_CODE%TYPE;        --�����ȣ
    V_T_CODE            TBL_TEXTBOOK.T_CODE%TYPE;       --�����ڵ� ������ ����
    V_C_CODE            TBL_COURSE.C_CODE%TYPE;
    V_CR_CODE           TBL_CLASSROOM.CR_CODE%TYPE;     --���ǽ� �ڵ� ������ Ÿ��
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
--==>> Procedure PRC_ADMIN_S_O_INSERT��(��) �����ϵǾ����ϴ�.
-------------------------------------------------------------------------------------------------
----------------------[PRC_SET_POINT] ���ν���---------------------

create or replace PROCEDURE PRC_SET_POINT           -- ���� SET ���ν���
(V_S_O_CODE     TBL_SUBJECT_OPEN.S_O_CODE%TYPE      --���� ������ ������ȣ�� �Է¹޴´�.
,V_S_O_WPO      TBL_SUBJECT_OPEN.S_O_WPO%TYPE       --�ʱ� ������ �Է¹޴´�.
,V_S_O_SPO      TBL_SUBJECT_OPEN.S_O_SPO%TYPE       --�Ǳ� ������ �Է¹޴´�.
,V_S_O_APO      TBL_SUBJECT_OPEN.S_O_WPO%TYPE       --��� ������ �Է¹޴´�.
)
IS
BEGIN
    UPDATE TBL_SUBJECT_OPEN
    SET S_O_WPO = V_S_O_WPO, S_O_APO = V_S_O_APO, S_O_SPO = V_S_O_SPO
    WHERE S_O_CODE = V_S_O_CODE;
    -- ���񰳼��� ������ȣ�� ������ �������� SET�����ش�.
    
    EXCEPTION
    WHEN OTHERS
    THEN DBMS_OUTPUT.PUT_LINE('����!����!');
            ROLLBACK;

    COMMIT;
END;
--==>> Procedure PRC_PRO_PRINT��(��) �����ϵǾ����ϴ�.
-------------------------------------------------------------------
----------------------[PRC_COURSE_REG_INSERT] ���ν��� ----------------------
create or replace PROCEDURE PRC_COURSE_REG_INSERT       -- ������û ���ν���
( 
     V_S_ID     IN TBL_STUDENT.S_ID%TYPE                       --�л����̵�
    ,V_C_O_CODE IN TBL_COURSE_REGISTRATION.C_O_CODE%TYPE       --���������ڵ�
)
IS
    V_C_R_CODE  TBL_COURSE_REGISTRATION.C_R_CODE%TYPE;
BEGIN
    -- ������û �ڵ��� �ִ밪�� ������û�ڵ忡 INTO
    SELECT NVL(MAX(C_R_CODE), 0) + 1 INTO V_C_R_CODE
    FROM TBL_COURSE_REGISTRATION;

    INSERT INTO TBL_COURSE_REGISTRATION(C_R_CODE, S_ID, C_O_CODE)
    VALUES (V_C_R_CODE, V_S_ID, V_C_O_CODE);


END;
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.


-------------------------------------------------------------------
----------------------[PRC_ADMIN_UPDATE] ���ν���--------------------------------
CREATE OR REPLACE PROCEDURE PRC_ADMIN_UPDATE		-- ������ ������Ʈ ���ν���
( V_A_ID     IN TBL_ADMIN.A_ID%TYPE		-- ������ ID
, V_A_PW    IN TBL_ADMIN.A_PW%TYPE		-- ������ PASSWORD
)
IS
BEGIN
        UPDATE TBL_ADMIN
        SET       A_PW = V_A_PW
        WHERE A_ID = V_A_ID
            AND A_PW = V_A_PW;

        --Ŀ��!
        COMMIT;

       EXCEPTION 
       WHEN OTHERS
            THEN DBMS_OUTPUT.PUT_LINE('�Է��� �߸��Ǿ����!');        
                     ROLLBACK;   
END;

--==>> Procedure PRC_ADMIN_UPDATE��(��) �����ϵǾ����ϴ�.


--------------------[PRC_CLASSROOM_NO_UPDATE] ���ν���-----------------------------------------
CREATE OR REPLACE PROCEDURE PRC_CLASSROOM_NO_UPDATE
( V_CR_CODE    IN TBL_CLASSROOM.CR_CODE%TYPE	-- ���ǽ� �ڵ�
, V_CR_LOC     IN TBL_CLASSROOM.CR_LOC%TYPE	-- ���ǽ� ��ġ
, V2_CR_LOC    IN TBL_CLASSROOM.CR_LOC%TYPE     -- 2��Ȯ�ο� ���ǽǹ�ȣ
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

    --Ŀ��!
    COMMIT;

    EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20030, '���ǽ���ġ�� ���� ��ġ���� �ʾƿ�!');
END;

--==>> Procedure PRC_CLASSROOM_NO_UPDATE��(��) �����ϵǾ����ϴ�.


---------------------[PRC_COURSENAME_UPDATE] ���ν���------------------------------------
CREATE OR REPLACE PROCEDURE PRC_COURSENAME_UPDATE
(V_C_CODE      IN TBL_COURSE.C_CODE%TYPE	-- ������ȣ�� �޴� �Ķ����
,V_C_NAME      IN TBL_COURSE.C_NAME%TYPE	-- �ٲ� �������� �޴� �Ķ����
)
IS
BEGIN

    UPDATE TBL_COURSE
    SET C_NAME = V_C_NAME			-- �������� �Է°����� �ٲ��ֱ�!
    WHERE C_CODE =V_C_CODE;			-- ��ġ�ϴ� ������ȣ�� ������..

    --Ŀ��!
    COMMIT;

    EXCEPTION 
       WHEN OTHERS
            THEN RAISE_APPLICATION_ERROR(-20011, '�Է��� �߸��Ǿ����!');        
                 ROLLBACK;     

END;

--==>> Procedure PRC_COURSENAME_UPDATE��(��) �����ϵǾ����ϴ�.


------------------------[PRC_COURSETIME_UPDATE]---------------------------------------------------

create or replace PROCEDURE PRC_COURSETIME_UPDATE
( V_C_O_CODE    IN TBL_COURSE_OPEN.C_O_CODE%TYPE	-- ������ȣ�� �޴� �Ķ����
, V_C_O_START   IN TBL_COURSE_OPEN.C_O_START%TYPE	-- �ٲ� ���� ���۱Ⱓ�� �޴� �Ķ����
, V_C_O_END     IN TBL_COURSE_OPEN.C_O_END%TYPE		-- �ٲ� ���� ���Ⱓ�� �޴� �Ķ����
)
IS
BEGIN
    UPDATE TBL_COURSE_OPEN
    SET C_O_START = V_C_O_START , C_O_END = V_C_O_END	-- �������۱Ⱓ�� ���Ⱓ�� �Է°����� �ٲ��ֱ�!
    WHERE C_O_CODE = V_C_O_CODE;			-- ������ȣ�� ���� ��
END;

--==>> Procedure PRC_COURSETIME_UPDATE��(��) �����ϵǾ����ϴ�.




-------------------------[PRC_PROFESSOR_UPDATE]-------------------------------------------------------

create or replace PROCEDURE PRC_PROFESSOR_UPDATE
( V_P_ID    IN TBL_PROFESSOR.P_ID%TYPE      -- �ٲٰ� ���� ID
, V_P_PW    IN TBL_PROFESSOR.P_PW%TYPE      -- �ٲٰ� ���� ��й�ȣ
, V2_P_PW   IN TBL_PROFESSOR.P_PW%TYPE      -- �ٲٰ� ���� ��й�ȣ 2�� Ȯ��
, V_P_NAME  IN TBL_PROFESSOR.P_NAME%TYPE
, V_P_SSN   IN TBL_PROFESSOR.P_SSN%TYPE
)
IS
    USER_DEFINE_ERROR   EXCEPTION;      -- ����ó���� ���� ����
BEGIN

    IF V_P_PW != V2_P_PW      -- �ٲٰ� ���� ��й�ȣ�� ��Ȯ�ο� ��й�ȣ�� Ʋ���ٸ�...
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    UPDATE TBL_PROFESSOR
    SET P_ID = V_P_ID , P_PW = V_P_PW , P_NAME = V_P_NAME
    WHERE P_SSN = V_P_SSN;

    --Ŀ��
    COMMIT;

    EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20010,'��й�ȣ�� ���� ��ġ���� �ʾƿ�!');
END;

--==>> Procedure PRC_PROFESSOR_UPDATE��(��) �����ϵǾ����ϴ�.



------------------------------------------[PRC_SCORE_UPDATE] ���ν���----------------------------------------------
create or replace PROCEDURE PRC_SCORE_UPDATE
( V_S_O_CODE          IN TBL_SUBJECT_OPEN.S_O_CODE%TYPE			-- �����ȣ�� ���� �Ķ����
, V_S_ID              IN TBL_STUDENT.S_ID%TYPE				-- �л�ID�� ���� �Ķ����
, V_S_C_WRITE         IN TBL_SCORE_CONTROL.S_C_WRITE%TYPE		-- �ʱ������ ���� �Ķ����
, V_S_C_SKILL         IN TBL_SCORE_CONTROL.S_C_SKILL%TYPE		-- �Ǳ������ ���� �Ķ����
, V_S_C_ATTENDENCE    IN TBL_SCORE_CONTROL.S_C_ATTENDENCE%TYPE		-- �������� ���� �Ķ����
)
IS
    V_C_R_CODE          TBL_COURSE_REGISTRATION.C_R_CODE%TYPE;		-- ������û�� ������ȣ�� ���� ����
    V_C_O_CODE          TBL_COURSE_OPEN.C_O_CODE%TYPE;			-- ���������� ���������ڵ带 ���� ����
    V_S_O_WPO           TBL_SUBJECT_OPEN.S_O_WPO%TYPE;			-- ���񰳼��� �ʱ������ ���� ����
    V_S_O_SPO           TBL_SUBJECT_OPEN.S_O_SPO%TYPE;			-- ���񰳼��� �Ǳ������ ���� ����
    V_S_O_APO           TBL_SUBJECT_OPEN.S_O_APO%TYPE;			-- ���񰳼��� �������� ���� ����
    USER_DEFINE_ERROR   EXCEPTION;					-- ����ó�� ����
BEGIN

    SELECT S_O_WPO , S_O_SPO, S_O_APO INTO V_S_O_WPO , V_S_O_SPO, V_S_O_APO
    FROM TBL_SUBJECT_OPEN
    WHERE S_O_CODE = V_S_O_CODE;

    IF (V_S_C_WRITE > V_S_O_WPO OR V_S_C_SKILL > V_S_O_SPO OR V_S_C_ATTENDENCE > V_S_O_APO)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    SELECT C_O_CODE INTO V_C_O_CODE			
    FROM TBL_SUBJECT_OPEN			
    WHERE S_O_CODE = V_S_O_CODE;			-- ���񰳼���ȣ�� �Ķ���Ϳ� ���ٸ�..
    
    SELECT C_R_CODE INTO V_C_R_CODE
    FROM TBL_COURSE_REGISTRATION
    WHERE C_O_CODE = V_C_O_CODE				-- ���������ڵ尡 �Ķ���Ϳ� ���ٸ�..
    AND S_ID = V_S_ID;					-- �׸��� �л�ID�� �Ķ���Ϳ� ���ٸ�..
    
    UPDATE TBL_SCORE_CONTROL
    SET S_C_WRITE = V_S_C_WRITE, S_C_SKILL = V_S_C_SKILL, S_C_ATTENDENCE = V_S_C_ATTENDENCE
    WHERE C_R_CODE = V_C_R_CODE
    AND S_O_CODE = V_S_O_CODE;


    --Ŀ��!
    COMMIT;

    EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20078, '������ ������ �ѽ��ϴ�!');


END;

--==>> Procedure PRC_SCORE_UPDATE��(��) �����ϵǾ����ϴ�.

------------------------------------------[PRC_STUDENT_UPDATE] ���ν���---------------------------------------------------------
create or replace PROCEDURE PRC_STUDENT_UPDATE
( V_S_SSN    IN TBL_STUDENT.S_SSN%TYPE				-- �л��� �ֹι�ȣ�� �޴� �Ķ����
, V_S_NAME   IN TBL_STUDENT.S_NAME%TYPE				-- �ٲ��̸��� �޴� �Ķ����
, V2_S_NAME  IN TBL_STUDENT.S_NAME%TYPE				-- �ٲ��̸� Ȯ�ο� �Ķ����
)
IS
    
    USER_DEFINE_ERROR   EXCEPTION; -- �̸� Ȯ�ο� ��������


BEGIN  

    IF V_S_NAME != V2_S_NAME					-- �ٲ��̸��� 2�� Ȯ�ο� �Ķ���Ͱ� �ȸ�����!
        THEN RAISE USER_DEFINE_ERROR;				-- ������ ����ó��!
    END IF;


    UPDATE TBL_STUDENT
    SET  S_NAME = V_S_NAME
    WHERE S_SSN = V_S_SSN; 

    --Ŀ��!
    COMMIT;

    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20042, '�̸��� ���� �ȸ¾ƿ�!');
END;

--==>> Procedure PRC_STUDENT_UPDATE��(��) �����ϵǾ����ϴ�.


---------------------------------[PRC_SUPID_UPDATE] ���ν���--------------------------------------
create or replace PROCEDURE PRC_SUPID_UPDATE        
( V_S_O_CODE    IN TBL_SUBJECT_OPEN.S_O_CODE % TYPE	-- ����������ȣ�� ���� �Ķ����
, V_P_ID             IN TBL_SUBJECT_OPEN.P_ID%TYPE	-- �ٲ� ����ID�� ���� �Ķ����
)
IS
BEGIN
    UPDATE TBL_SUBJECT_OPEN
    SET P_ID = V_P_ID					-- �Էµ� ������ ����ID�� �ٲٱ�
    WHERE V_S_O_CODE = S_O_CODE;			-- ����������ȣ�� ������

    -- Ŀ��
    COMMIT;
END;

--==>> Procedure PRC_SUPID_UPDATE��(��) �����ϵǾ����ϴ�.

--------------------------------[PRC_SUSTAEND_UPDATE] ���ν���---------------------------------------
create or replace PROCEDURE PRC_SUSTAEND_UPDATE
( V_S_O_CODE    IN TBL_SUBJECT_OPEN.S_O_CODE%TYPE		-- ���񰳼���ȣ�� ���� �Ķ����
, V_S_O_START   IN TBL_SUBJECT_OPEN.S_O_START%TYPE		-- ������۱Ⱓ�� ���� �Ķ����
, V_S_O_END      IN TBL_SUBJECT_OPEN.S_O_END%TYPE		-- ���񳡱Ⱓ�� ���� �Ķ����
)
IS
BEGIN

    UPDATE TBL_SUBJECT_OPEN
    SET S_O_START = V_S_O_START , S_O_END = V_S_O_END		-- �Էµ� ������ ������۱Ⱓ, ���Ⱓ�� �ٲ��ֱ�!
    WHERE V_S_O_CODE = S_O_CODE;				-- ���񰳼���ȣ�� �Ķ���Ϳ� ���� ��

END;

--==>> Procedure PRC_SUSTAEND_UPDATE��(��) �����ϵǾ����ϴ�.

--------------------------------------[PRC_SUWSAPO_UPDATE] ���ν���-------------------------------------
create or replace PROCEDURE PRC_SUWSAPO_UPDATE
( V_S_O_CODE    IN TBL_SUBJECT_OPEN.S_O_CODE%TYPE		-- ���񰳼���ȣ�� ���� �Ķ����
, V_S_O_WPO     IN TBL_SUBJECT_OPEN.S_O_WPO%TYPE		-- �ٲ� �ʱ������ ���� �Ķ����
, V_S_O_SPO       IN TBL_SUBJECT_OPEN.S_O_SPO%TYPE		-- �ٲ� �Ǳ������ ���� �Ķ����
, V_S_O_APO       IN TBL_SUBJECT_OPEN.S_O_APO%TYPE		-- �ٲ� �������� ���� �Ķ����
)
IS
BEGIN
    UPDATE TBL_SUBJECT_OPEN
    SET S_O_WPO = V_S_O_WPO , S_O_SPO = V_S_O_SPO , S_O_APO = V_S_O_APO		-- �Էµ� ������ �ʱ�, �Ǳ�, ��� ������ �ٲ��ֱ�!
    WHERE V_S_O_CODE = S_O_CODE;						-- ���񰳼���ȣ�� �Ķ���Ϳ� ���� ��
END;

--==>> Procedure PRC_SUWSAPO_UPDATE��(��) �����ϵǾ����ϴ�.
-------------------------------------------------------------------------------------------------------------
----------------------[PRC_COURSE_DELETE] ���ν��� -------------------------

CREATE OR REPLACE  PROCEDURE PRC_COURSE_DELETE    --�������� ���ν���
(
    V_C_CODE      TBL_COURSE.C_CODE%TYPE     -- ���� �ڵ�
  , V_C_NAME      TBL_COURSE.C_NAME%TYPE     -- ���� �̸�
)
IS
BEGIN
        DELETE				  -- ������ ����ڴ�
        FROM TBL_COURSE
        WHERE  C_CODE = V_C_CODE	  -- ���� �ڵ�� ���� �Է��� ���� �ڵ尡 ����
            AND C_NAME = V_C_NAME;	  -- ���� �̸��� ���� �Է��� ���� �̸��� ���ٸ�
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20100,'������ �ʿ��� �׸��� �ٽ� �Է����ּ���');
                     ROLLBACK;
END;
--==>> Procedure PRC_COURSE_DELETE��(��) �����ϵǾ����ϴ�.
----------------------------------------------------------------------------

----------------------[PRC_COURSE_OPEN_DELETE] ���ν��� -------------------------

CREATE OR REPLACE PROCEDURE PRC_COURSE_OPEN_DELETE     -- �������� ���� ���ν���
(
    V_C_O_CODE      TBL_COURSE_OPEN.C_O_CODE%TYPE	-- ���������ڵ�
  , V_C_CODE        TBL_COURSE_OPEN.C_CODE%TYPE	        -- �����ڵ�
  , V_CR_CODE       TBL_COURSE_OPEN.CR_CODE%TYPE	-- ���ǽ��ڵ�
  , V_C_O_START     TBL_COURSE_OPEN.C_O_START%TYPE 	-- �������۱Ⱓ
  , V_C_O_END       TBL_COURSE_OPEN.C_O_END%TYPE	-- �������Ⱓ
)
IS
BEGIN
        DELETE			          -- ���������� ����ڴ�
        FROM TBL_COURSE_OPEN
        WHERE C_O_CODE = V_C_O_CODE	  -- ���������ڵ�� �����Է��� �������� �ڵ尡 ����
            AND C_CODE = V_C_CODE         -- �����ڵ�� ���� �Է��� �����ڵ尡 ����
                AND CR_CODE = V_CR_CODE       --���ǽ��ڵ尡 ���� �Է��� ���ǽ� �ڵ尡 ����
                    AND C_O_START = V_C_O_START     --�������۱Ⱓ�� ����
                        AND C_O_END = V_C_O_END;    --���� �� �Ⱓ�� ���ٸ�
        COMMIT;



	EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20101,'������ �ʿ��� �׸��� �ٽ� �Է����ּ���');
                     ROLLBACK;
END;
--==>> Procedure PRC_COURSE_OPEN_DELETE��(��) �����ϵǾ����ϴ�.
----------------------------------------------------------------------------


----------------------[PRC_PROFESSOR_DELETE] ���ν��� -------------------------


CREATE OR REPLACE PROCEDURE PRC_PROFESSOR_DELETE   -- �������� ���ν���
(
    V_P_ID      TBL_PROFESSOR.P_ID%TYPE		-- �������̵�
  , V_P_NAME    TBL_PROFESSOR.P_NAME%TYPE	-- �����̸�
  , V_P_SSN     TBL_PROFESSOR.P_SSN%TYPE	-- ���� �ֹι�ȣ ���ڸ�
)
IS
BEGIN
        DELETE					-- ������ ����ڴ�
        FROM TBL_PROFESSOR	
        WHERE P_ID = V_P_ID			-- �������̵�� ���� �Է��� ���̵� ����
            AND P_NAME = V_P_NAME		-- �����̸��� ���� �Է��� �̸��� ����
                AND P_SSN = V_P_SSN;		-- ���� �ֹι�ȣ ���ڸ��� ���� �Է��� ���� ���ٸ�
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20102,'������ �ʿ��� �׸��� �ٽ� �Է����ּ���');

                     ROLLBACK;
END;
--==>> Procedure PRC_PROFESSOR_DELETE��(��) �����ϵǾ����ϴ�.
----------------------------------------------------------------------------

----------------------[PRC_SCORE_CONTROL_DELETE] ���ν��� -------------------------


CREATE OR REPLACE PROCEDURE PRC_SCORE_CONTROL_DELETE	-- �������� ���ν���
(
    V_C_R_CODE          TBL_SCORE_CONTROL.C_R_CODE%TYPE		-- ������û�ڵ�
  , V_S_O_CODE          TBL_SCORE_CONTROL.S_O_CODE%TYPE		-- ������ȣ	
  , V_S_C_WRITE         TBL_SCORE_CONTROL.S_C_WRITE%TYPE	-- �ʱ�
  , V_S_C_SKILL         TBL_SCORE_CONTROL.S_C_SKILL%TYPE	-- �Ǳ�
  , V_S_C_ATTENDENCE    TBL_SCORE_CONTROL.S_C_ATTENDENCE%TYPE	-- ���
)
IS
BEGIN
        DELETE					-- ������ ����ڴ�
        FROM TBL_SCORE_CONTROL
        WHERE C_R_CODE = V_C_R_CODE		-- ������û �ڵ尡 ����
            AND S_O_CODE = V_S_O_CODE    	-- ������ȣ�� ����
                AND S_C_WRITE = V_S_C_WRITE  	-- �ʱ������� ����
                    AND S_C_SKILL = V_S_C_SKILL -- �Ǳ������� ����
                        AND S_C_ATTENDENCE = V_S_C_ATTENDENCE;  -- ��������� ���ٸ�
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20103,'������ �ʿ��� �׸��� �ٽ� �Է����ּ���');
                     ROLLBACK;
END;
--==>> Procedure PRC_SCORE_CONTROL_DELETE��(��) �����ϵǾ����ϴ�.
----------------------------------------------------------------------------


----------------------[PRC_STUDENT_DELETE] ���ν��� -------------------------

CREATE OR REPLACE PROCEDURE PRC_STUDENT_DELETE   -- �л����� ���� ���ν���
(
    V_S_ID      TBL_STUDENT.S_ID%TYPE		-- �л� ���̵�
  , V_S_PW      TBL_STUDENT.S_PW%TYPE		-- �л� ��й�ȣ
  , V_S_NAME    TBL_STUDENT.S_NAME%TYPE		-- �л��̸�
  , V_S_SSN     TBL_STUDENT.S_SSN%TYPE		-- �л� �ֹι�ȣ ���ڸ�
)
IS
BEGIN
        DELETE				-- �л������� ����ڴ�
        FROM TBL_STUDENT		
        WHERE S_ID = V_S_ID			-- �л� ���̵� ����
            AND S_PW = V_S_PW    		-- �л� ��й�ȣ�� ����
                AND S_NAME = V_S_NAME  		-- �л� �̸��� ����
                    AND S_SSN = V_S_SSN;  	-- �л� �ֹι�ȣ ���ڸ��� ���ٸ�
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20104,'������ �ʿ��� �׸��� �ٽ� �Է����ּ���');
                     ROLLBACK; 
END;
--==>> Procedure PRC_STUDENT_DELETE��(��) �����ϵǾ����ϴ�.
----------------------------------------------------------------------------


----------------------[PRC_SUBJECT_DELETE] ���ν��� -------------------------
CREATE OR REPLACE PROCEDURE PRC_SUBJECT_DELETE   -- ������� ���ν���
(
    V_S_CODE      TBL_SUBJECT.S_CODE%TYPE      -- �����ڵ�
  , V_S_NAME      TBL_SUBJECT.S_NAME%TYPE      -- �����
)
IS
BEGIN
        DELETE					-- ������ ����ڴ�
        FROM TBL_SUBJECT
        WHERE  S_CODE = V_S_CODE		-- �����ڵ尡 ����
            AND S_NAME = V_S_NAME;		-- ������� ���ٸ�

        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20105,'������ �ʿ��� �׸��� �ٽ� �Է����ּ���');
                     ROLLBACK;
END;
--==>> Procedure PRC_SUBJECT_DELETE��(��) �����ϵǾ����ϴ�.

----------------------------------------------------------------------------


----------------------[PRC_SUBJECT_OPEN_DELETE] ���ν��� -------------------------

CREATE OR REPLACE PROCEDURE PRC_SUBJECT_OPEN_DELETE  -- ���񰳼� ���ν���
( V_S_O_CODE    IN TBL_SUBJECT_OPEN.S_O_CODE%TYPE    -- ������ȣ
, V_C_O_CODE    IN TBL_SUBJECT_OPEN.C_O_CODE%TYPE    -- ���������ڵ�
, V_P_ID        IN TBL_SUBJECT_OPEN.P_ID%TYPE	     -- �������̵�
, V_S_CODE      IN TBL_SUBJECT_OPEN.S_CODE%TYPE	     -- �����ȣ
, V_T_CODE      IN TBL_SUBJECT_OPEN.T_CODE%TYPE	     -- �����ڵ�
, V_S_O_WPO     IN TBL_SUBJECT_OPEN.S_O_WPO%TYPE     -- �ʱ����
, V_S_O_SPO     IN TBL_SUBJECT_OPEN.S_O_SPO%TYPE     -- �Ǳ����
, V_S_O_APO     IN TBL_SUBJECT_OPEN.S_O_APO%TYPE     -- ������
, V_S_O_START   IN TBL_SUBJECT_OPEN.S_O_START%TYPE   -- ������۱Ⱓ
, V_S_O_END     IN TBL_SUBJECT_OPEN.S_O_END%TYPE     -- ���񳡳��±Ⱓ
)
IS
BEGIN

    DELETE					-- ���񰳼��� ����ڴ�
    FROM TBL_SUBJECT_OPEN
    WHERE S_O_CODE = V_S_O_CODE					-- ������ȣ�� ����
        AND C_O_CODE = V_C_O_CODE   				-- ���������ڵ尡 ����
            AND P_ID = V_P_ID       				-- ���� ���̵� ����
                AND S_CODE = V_S_CODE  				-- �����ȣ�� ����
                    AND T_CODE = V_T_CODE       		-- �����ڵ尡 ����
                        AND S_O_WPO = V_S_O_WPO   		-- �ʱ������ ����
                            AND S_O_SPO = V_S_O_SPO		-- �Ǳ������� ����
                                AND S_O_APO = V_S_O_APO  	-- �������� ����
                                    AND S_O_START = V_S_O_START -- ������۱Ⱓ�� ����
                                        AND S_O_END = V_S_O_END;-- ���񳡳��±Ⱓ�� ������

    COMMIT;

    EXCEPTION
        WHEN OTHERS
            THEN RAISE_APPLICATION_ERROR(-20106,'������ �ʿ��� �׸��� �ٽ� �Է����ּ���');
                 ROLLBACK;
END;
--==>> Procedure PRC_SUBJECT_OPEN_DELETE��(��) �����ϵǾ����ϴ�.
----------------------------------------------------------------------------


-- ���ǽ� ���� ������Ʈ Ʈ����
create or replace TRIGGER TRG_CLASSROOM_CR_CODE_UPDATE
AFTER UPDATE OF CR_CODE ON TBL_COURSE_OPEN FOR EACH ROW
BEGIN
    UPDATE TBL_CLASSROOM
    SET CR_CODE = :NEW.CR_CODE
    WHERE CR_CODE = :OLD.CR_CODE;
END;
-----------------------------------------------------------
-- �ι�° ���� ���������ڵ� ������Ʈ Ʈ����
create or replace TRIGGER TRG_COUROPEN_C_O_CODE_UPDATE -- ���������� ���������ڵ带 �ٲܽ� ������û�� ���������ڵ嵵 �ڵ����� �ٲ�� TRIGGER!
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
-- ������û �� �ڵ� ����ó�����̺� ��� Ʈ����
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
-- ������û ������ �ߵ�Ż�� ���̺� �ڵ���� Ʈ����
create or replace TRIGGER TRG_FAIL_INSERT
        AFTER
        DELETE ON TBL_COURSE_REGISTRATION
        FOR EACH ROW
        
DECLARE
    V_C_R_CODE      TBL_COURSE_REGISTRATION.C_R_CODE%TYPE;
BEGIN
                SELECT C_R_CODE         INTO V_C_R_CODE
                FROM TBL_COURSE_REGISTRATION
                WHERE C_R_CODE = :OLD.C_R_CODE;            --����C_R_CODE�� ������ûTABLE�� C_R_CODE�� V_C_R_CODE�� ����
    IF(DELETING)                                           --���� �߻��� �ߵ�Ż�� TABLE�� �־��� ������ �࿡ ����
        THEN INSERT INTO TBL_FAIL(C_R_CODE, F_DATE, F_REASON)
             VALUES (V_C_R_CODE, SYSDATE, NULL);
    END IF;
END;
----------------------------------------------------------------------
-- ���� ���̵� ���� ������Ʈ Ʈ����
create or replace TRIGGER TRG_PROFESSOR_P_ID_UPDATE
AFTER UPDATE OF P_ID ON TBL_SUBJECT_OPEN FOR EACH ROW
BEGIN
    UPDATE TBL_PROFESSOR
    SET P_ID = :NEW.P_ID
    WHERE P_ID = :OLD.P_ID;
END;
----------------------------------------------------------------------
-- ������û �ڵ� ���� ������Ʈ Ʈ����
create or replace TRIGGER TRG_REGIST_C_R_CODE_UPDATE
AFTER UPDATE OF C_R_CODE ON TBL_FAIL FOR EACH ROW
BEGIN
    UPDATE TBL_COURSE_REGISTRATION
    SET C_R_CODE = :NEW.C_R_CODE
    WHERE C_R_CODE = :OLD.C_R_CODE;
END;

----------------------------------------------------------------------
-- ������ ���� �Ⱓ ���� Ʈ����
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
        WHERE C_O_CODE = :NEW.C_O_CODE;                         --C_O_CODE�� ������ C_O_CODE�� ���� �� 
        IF (:NEW.S_O_START < V_C_O_START OR :NEW.S_O_END > V_C_O_END) --���� �� ���� ���۳�¥ < ���� ���۳�¥ OR ���� �� ���� ���񰳼� ���� ��¥ > �������ᳯ¥ 
                                                                      --�϶� �����߻�
            THEN RAISE_APPLICATION_ERROR(-20009, '�Ⱓ ���ÿ���!');
        END IF;
    END;
-------------------------------------------------------------------
-- ���� �Ⱓ ���� Ʈ����
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
            THEN RAISE_APPLICATION_ERROR(-20009, '�Ⱓ ���ÿ���!');
        END IF;
        END LOOP;
    END;
-------------------------------------------------------------------
-- �л� ID ���� ������Ʈ Ʈ����
create or replace TRIGGER TRG_STUDENT_S_ID_UPDATE
AFTER UPDATE OF S_ID ON TBL_COURSE_REGISTRATION FOR EACH ROW
BEGIN
    UPDATE TBL_STUDENT
    SET S_ID = :NEW.S_ID
    WHERE S_ID = :OLD.S_ID;
END;
------------------------------------------------------------------------
-- ���� �ڵ� ���� ������Ʈ Ʈ����
create or replace TRIGGER TRG_SUBJECT_S_NAME_UPDATE
AFTER UPDATE OF S_CODE ON TBL_SUBJECT_OPEN FOR EACH ROW
BEGIN
    UPDATE TBL_SUBJECT
    SET S_CODE = :NEW.S_CODE
    WHERE S_CODE = :OLD.S_CODE;
END;
------------------------------------------------------------------------
-- ������ �ڵ� ���� ������Ʈ Ʈ����
create or replace TRIGGER TRG_TEXTBOOK_T_CODE_UPDATE
AFTER UPDATE OF T_CODE ON TBL_SUBJECT_OPEN FOR EACH ROW
BEGIN

    UPDATE TBL_TEXTBOOK
    SET T_CODE = :NEW.T_CODE
    WHERE T_CODE = :OLD.T_CODE;
END;
------------------------------------------------------------------