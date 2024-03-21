DROP TABLE NOTICE;
DROP SEQUENCE NOTICESQ;

CREATE SEQUENCE NOTICESQ NOCACHE; --게시글 번호를 위한 [공지사항] 시퀀스 생성

--[공지사항]테이블 생성
CREATE TABLE NOTICE(
	NOTICE_NO NUMBER PRIMARY KEY,
	NOTICE_TITLE VARCHAR2(1000) NOT NULL,
	NOTICE_NAME VARCHAR2(500) NOT NULL,
	NOTICE_CONTENT VARCHAR2(4000) NOT NULL,
	NOTICE_REGDATE DATE NOT NULL,
	NOTICE_HIT NUMBER NOT NULL,
	NOTICE_DELETEYN VARCHAR2(2) NOT NULL, 
	NOTICE_MYID VARCHAR2(50) NOT NULL
);

SELECT * FROM NOTICE;

ALTER TABLE NOTICE ADD CONSTRAINT N_DELETEYN_CHK CHECK(NOTICE_DELETEYN IN('Y', 'N'));  -- 테이블  삭제


--====================================
DROP TABLE COMPLAIN;
DROP SEQUENCE COMPLAIN_BOARDSQ;
DROP SEQUENCE COMPLAIN_GROUPSQ;


CREATE SEQUENCE COMPLAIN_BOARDSQ NOCACHE; --게시글 번호
CREATE SEQUENCE COMPLAIN_GROUPSQ NOCACHE; --게시글 그룹 번호

--[불만접수]테이블 생성
CREATE TABLE COMPLAIN(
	COMPLAIN_BOARDNO NUMBER PRIMARY KEY,
	COMPLAIN_GROUPNO NUMBER NOT NULL, --그룹번호 (그룹 구분)
	COMPLAIN_GROUPSQ NUMBER NOT NULL, -- 그룹내의 게시글 번호
	COMPLAIN_TITLETAB NUMBER NOT NULL, --답글 앞에 공백을 주기 위한 것 (1: 여백한개/ 2: 여백두개/ N: 여백N개)
	COMPLAIN_TITLE VARCHAR2(500) NOT NULL,
	COMPLAIN_CONTENT VARCHAR2(2000) NOT NULL,
	COMPLAIN_NAME VARCHAR2(100) NOT NULL,
	COMPLAIN_REGDATE DATE NOT NULL,
	COMPLAIN_HIT NUMBER NOT NULL,
	COMPLAIN_DELETEYN VARCHAR2(2) NOT NULL, 
	COMPLAIN_MYID VARCHAR2(50) NOT NULL

);

ALTER TABLE COMPLAIN ADD CONSTRAINT C_DELETEYN_CHK CHECK(COMPLAIN_DELETEYN IN('Y', 'N'));  -- 테이블  삭제



SELECT * FROM COMPLAIN;


INSERT INTO COMPLAIN
VALUES( COMPLAIN_BOARDSQ.NEXTVAL, COMPLAIN_GROUPSQ.NEXTVAL, 1, 0, '첫번째 글','1번 글입니다.','홍길동', SYSDATE, 0, 'N', 'gildong12');

INSERT INTO COMPLAIN
VALUES( COMPLAIN_BOARDSQ.NEXTVAL,
	(SELECT COMPLAIN_GROUPNO FROM COMPLAIN WHERE COMPLAIN_BOARDNO=1),
	(SELECT COMPLAIN_GROUPSQ FROM COMPLAIN  WHERE COMPLAIN_BOARDNO=1)+1,
	(SELECT COMPLAIN_TITLETAB FROM COMPLAIN  WHERE COMPLAIN_BOARDNO=1)+1,
	'↳RE: 첫번째 글', '1번글의 답글입니다.', '관리자', SYSDATE, 0, 'N', 'ADMIN');
	
	
UPDATE COMPLAIN  SET COMPLAIN_GROUPSQ = COMPLAIN_GROUPSQ+1
WHERE COMPLAIN_GROUPNO = (SELECT COMPLAIN_GROUPNO FROM COMPLAIN WHERE COMPLAIN_BOARDNO =1)
	AND COMPLAIN_GROUPSQ > (SELECT COMPLAIN_GROUPSQ FROM COMPLAIN WHERE COMPLAIN_BOARDNO=1);	
	
INSERT INTO COMPLAIN
VALUES( COMPLAIN_BOARDSQ.NEXTVAL,
	(SELECT COMPLAIN_GROUPNO FROM COMPLAIN WHERE COMPLAIN_BOARDNO=2),
	(SELECT COMPLAIN_GROUPSQ FROM COMPLAIN  WHERE COMPLAIN_BOARDNO=2)+1,
	(SELECT COMPLAIN_TITLETAB FROM COMPLAIN  WHERE COMPLAIN_BOARDNO=2)+1,
	'↳RE:RE: 첫번째 글', '1번글의 답글입니다.(2)', '홍길동', SYSDATE, 0, 'N', 'gildong');	
--====================================
DROP TABLE QUESTION;
DROP SEQUENCE QUESTION_BOARDSQ;
DROP SEQUENCE QUESTION_GROUPSQ;


CREATE SEQUENCE QUESTION_BOARDSQ NOCACHE; 
CREATE SEQUENCE QUESTION_GROUPSQ NOCACHE;

CREATE TABLE QUESTION(
	QUESTION_BOARDNO NUMBER PRIMARY KEY,
	QUESTION_GROUPNO NUMBER NOT NULL, --그룹번호 (그룹 구분)
	QUESTION_GROUPSQ NUMBER NOT NULL, -- 그룹내의 게시글 번호
	QUESTION_TITLETAB NUMBER NOT NULL, --답글 앞에 공백을 주기 위한 것 (1: 여백한개/ 2: 여백두개/ N: 여백N개)
	QUESTION_TITLE VARCHAR2(500) NOT NULL,
	QUESTION_CONTENT VARCHAR2(2000) NOT NULL,
	QUESTION_NAME VARCHAR2(100) NOT NULL,
	QUESTION_REGDATE DATE NOT NULL,
	QUESTION_HIT NUMBER NOT NULL,
	QUESTION_DELETEYN VARCHAR2(2) NOT NULL, 
	QUESTION_MYID VARCHAR2(50) NOT NULL

);



ALTER TABLE QUESTION ADD CONSTRAINT Q_DELETEYN_CHK CHECK(QUESTION_DELETEYN IN('Y', 'N'));  -- 테이블  삭제


INSERT INTO QUESTION
VALUES( QUESTION_BOARDSQ.NEXTVAL, QUESTION_GROUPSQ.NEXTVAL, 1, 0, '첫번째 글','1번 글입니다.','홍길동', SYSDATE, 0, 'N', 'gildong');

SELECT * FROM QUESTION
ORDER BY QUESTION_GROUPNO DESC, QUESTION_GROUPSQ;

INSERT INTO QUESTION
VALUES( QUESTION_BOARDSQ.NEXTVAL,
	(SELECT QUESTION_GROUPNO FROM QUESTION WHERE QUESTION_BOARDNO=1),
	(SELECT QUESTION_GROUPSQ FROM QUESTION  WHERE QUESTION_BOARDNO=1)+1,
	(SELECT QUESTION_TITLETAB FROM QUESTION  WHERE QUESTION_BOARDNO=1)+1,
	'↳RE: 첫번째 글', '1번글의 답글입니다.', '매니저', SYSDATE, 0, 'N', 'ADMIN' );
	
	
	
UPDATE QUESTION  SET QUESTION_GROUPSQ = QUESTION_GROUPSQ+1
WHERE QUESTION_GROUPNO = (SELECT QUESTION_GROUPNO FROM QUESTION WHERE QUESTION_BOARDNO =1)
	AND QUESTION_GROUPSQ > (SELECT QUESTION_GROUPSQ FROM QUESTION WHERE QUESTION_BOARDNO=1);	
	
INSERT INTO QUESTION
VALUES( QUESTION_BOARDSQ.NEXTVAL,
	(SELECT QUESTION_GROUPNO FROM QUESTION WHERE QUESTION_BOARDNO=2),
	(SELECT QUESTION_GROUPSQ FROM QUESTION  WHERE QUESTION_BOARDNO=2)+1,
	(SELECT QUESTION_TITLETAB FROM QUESTION  WHERE QUESTION_BOARDNO=2)+1,
	'↳RE:RE: 첫번째 글', '1번글의 답글입니다.(2)', '홍길동', SYSDATE, 0, 'N', 'gildong');
	
	

--====================================
--위도/경도 얻기위한 테이블 
DROP TABLE MAP_PLACE_CLICK;
DROP SEQUENCE MAPSQ;

CREATE SEQUENCE MAPSQ NOCACHE;

CREATE TABLE MAP_PLACE_CLICK(
	
	MAP_NO NUMBER, --글의 번호
	LATITUDE NUMBER, --위도
	LONGTITUDE NUMBER, --경도
	LAND_NUMBER_ADDRESS VARCHAR2(2000), --지번주소
	ROAD_NAME_ADDRESS VARCHAR2(2000), --도로명주소
	MAP_WRITER VARCHAR2(30), --작성자
	MAP_PHONE VARCHAR2(30), --작성자 번호 
	MAP_CONTENT VARCHAR2(1000) --글
	 

);

SELECT * FROM MAP_PLACE_CLICK;


--=======================================


SELECT * FROM MAP_SHELTER_GUIDE; -- 보호소 DB 
SELECT * FROM MAP_SHELTER_GUIDE WHERE SHELTER_NAME LIKE '선정릉역%'; -- 보호소 DB 


	