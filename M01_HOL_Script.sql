/*---------------------------------------------------------------------------------------------------

	SCRIPT:		M01_HOL_Script
	PURPOSE:	Execute script for creating database structures required to complete 
				M01 Hands-On Lab and subsequent Hands On Labs 2-8.

---------------------------------------------------------------------------------------------------*/


-- --------------------------------------------------------------------------------------------------
--	DROP DATABASE OBJECTS AND ASSOCIATED CONSTRAINTS
--	Uncomment and use as needed
-- --------------------------------------------------------------------------------------------------

--DROP TABLE REGIONS CASCADE CONSTRAINTS;
--DROP TABLE COUNTRIES CASCADE CONSTRAINTS;
--DROP TABLE LOCATIONS CASCADE CONSTRAINTS;
--DROP TABLE DEPARTMENTS CASCADE CONSTRAINTS;
--DROP TABLE EMPLOYEES CASCADE CONSTRAINTS;
--DROP TABLE JOB_HISTORY CASCADE CONSTRAINTS;
--DROP TABLE JOBS CASCADE CONSTRAINTS;
--DROP VIEW EMP_DETAILS_VIEW;
--DROP SEQUENCE DEPARTMENTS_SEQ;
--DROP SEQUENCE EMPLOYEES_SEQ;
--DROP SEQUENCE LOCATIONS_SEQ;


-- --------------------------------------------------------------------------------------------------
-- CREATE TABLES
-- --------------------------------------------------------------------------------------------------

-- CREATE REGIONS TABLE
CREATE TABLE  REGIONS(
   REGION_ID		NUMBER	CONSTRAINT NN_REGION_ID NOT NULL ENABLE,
   REGION_NAME		VARCHAR2(25),
   CONSTRAINT PK_REG_ID PRIMARY KEY (REGION_ID) 
   USING INDEX  ENABLE
);

-- CREATE COUNTRIES TABLE
CREATE TABLE  COUNTRIES(
   COUNTRY_ID		CHAR(2)			CONSTRAINT NN_COUNTRY_ID			NOT NULL ENABLE,
   COUNTRY_NAME		VARCHAR2(40),
   REGION_ID		NUMBER,
   CONSTRAINT PK_COUNTRY_C_ID PRIMARY KEY (COUNTRY_ID) ENABLE
);

--	ADD CONSTRAINTS TO COUNTRIES TABLE
ALTER TABLE COUNTRIES ADD CONSTRAINT FK_COUNTR_REG FOREIGN KEY (REGION_ID)
	REFERENCES  REGIONS (REGION_ID) ENABLE;

--	CREATE LOCATIONS TABLE
CREATE TABLE  LOCATIONS(
    LOCATION_ID		NUMBER(4,0),
    STREET_ADDRESS	VARCHAR2(40),
    POSTAL_CODE		VARCHAR2(12),
    CITY			VARCHAR2(30)	CONSTRAINT NN_LOC_CITY				NOT NULL ENABLE,
    STATE_PROVINCE	VARCHAR2(25),
    COUNTRY_ID		CHAR(2),
    CONSTRAINT PK_LOC_ID PRIMARY KEY (LOCATION_ID)
		USING INDEX  ENABLE
);

--	ADD CONSTRAINTS TO LOCATIONS TABLE
ALTER TABLE LOCATIONS ADD CONSTRAINT FK_LOC_C_ID FOREIGN KEY (COUNTRY_ID)
	REFERENCES COUNTRIES (COUNTRY_ID) ENABLE;
CREATE INDEX IX_LOC_CITY ON  LOCATIONS (CITY);
CREATE INDEX IX_LOC_COUNTRY ON  LOCATIONS (COUNTRY_ID);
CREATE INDEX IX_LOC_STATE_PROVINCE ON LOCATIONS (STATE_PROVINCE);

--	CREATE DEPARTMENTS TABLE
CREATE TABLE  DEPARTMENTS(
	DEPARTMENT_ID	NUMBER(4,0),
    DEPARTMENT_NAME	VARCHAR2(30)	CONSTRAINT NN_DEPT_NAME				NOT NULL ENABLE,
    MANAGER_ID		NUMBER(6,0),
	LOCATION_ID		NUMBER(4,0),
    CONSTRAINT PK_DEPT PRIMARY KEY (DEPARTMENT_ID)
		USING INDEX  ENABLE
);

--	ADD CONSTRAINTS TO DEPARTMENTS TABLE
ALTER TABLE DEPARTMENTS ADD CONSTRAINT FK_DEPT_LOC FOREIGN KEY (LOCATION_ID)
	REFERENCES LOCATIONS (LOCATION_ID) ENABLE;
CREATE INDEX IX_DEPT_LOCATION ON  DEPARTMENTS (LOCATION_ID);

--	CREATE JOBS TABLE
CREATE TABLE  JOBS(
	JOB_ID			VARCHAR2(10),
    JOB_TITLE		VARCHAR2(35)	CONSTRAINT NN_JOB_TITLE				NOT NULL ENABLE,
    MIN_SALARY		NUMBER(6,0),
    MAX_SALARY		NUMBER(6,0),
    CONSTRAINT PK_JOBS PRIMARY KEY (JOB_ID)
	USING INDEX  ENABLE
);

--	CREATE EMPLOYEES TABLE
CREATE TABLE  EMPLOYEES(
	EMPLOYEE_ID		NUMBER(6,0),
    FIRST_NAME		VARCHAR2(20),
    LAST_NAME		VARCHAR2(25)	CONSTRAINT NN_EMP_LAST_NAME			NOT NULL ENABLE,
    EMAIL			VARCHAR2(25)	CONSTRAINT NN_EMP_EMAIL				NOT NULL ENABLE,
    PHONE_NUMBER	VARCHAR2(20),
    HIRE_DATE		DATE			CONSTRAINT NN_EMP_HIRE_DATE			NOT NULL ENABLE,
    JOB_ID			VARCHAR2(10)	CONSTRAINT NN_EMP_JOB				NOT NULL ENABLE,
    SALARY			NUMBER(8,2),
    COMMISSION_PCT	NUMBER(2,2),
    MANAGER_ID		NUMBER(6,0),
    DEPARTMENT_ID	NUMBER(4,0),
	BONUS			VARCHAR2(5),
    CONSTRAINT CK_EMP_SALARY_MIN CHECK (SALARY > 0) ENABLE,
    CONSTRAINT PK_EMPLOYEES PRIMARY KEY (EMPLOYEE_ID)
		USING INDEX  ENABLE,
    CONSTRAINT UK_EMP_EMAIL UNIQUE (EMAIL)
		USING INDEX  ENABLE
);
  
--	ADD CONSTRAINTS TO EMPLOYEES TABLE
ALTER TABLE  EMPLOYEES ADD CONSTRAINT FK_EMP_DEPT FOREIGN KEY (DEPARTMENT_ID)
	REFERENCES  DEPARTMENTS (DEPARTMENT_ID) ENABLE;
ALTER TABLE  EMPLOYEES ADD CONSTRAINT FK_EMP_JOB FOREIGN KEY (JOB_ID)
	REFERENCES  JOBS (JOB_ID) ENABLE;
ALTER TABLE  EMPLOYEES ADD CONSTRAINT FK_EMP_MGR FOREIGN KEY (MANAGER_ID)
	REFERENCES  EMPLOYEES (EMPLOYEE_ID) ENABLE;
ALTER TABLE  DEPARTMENTS ADD CONSTRAINT FK_DEPT_MGR FOREIGN KEY (MANAGER_ID)
	REFERENCES  EMPLOYEES (EMPLOYEE_ID) DISABLE;
CREATE INDEX IX_EMP_DEPT ON EMPLOYEES (DEPARTMENT_ID);
CREATE INDEX IX_EMP_JOB ON EMPLOYEES (JOB_ID);
CREATE INDEX IX_EMP_MGR ON EMPLOYEES (MANAGER_ID);
CREATE INDEX IX_EMP_NAM ON EMPLOYEES (LAST_NAME, FIRST_NAME);

--	CREATE JOB_HISTORY TABLE
CREATE TABLE  JOB_HISTORY(
	EMPLOYEE_ID		NUMBER(6,0)		CONSTRAINT NN_JOB_HIST_EMP			NOT NULL ENABLE,
    START_DATE		DATE			CONSTRAINT NN_JOB_HIST_START_DATE	NOT NULL ENABLE,
    END_DATE		DATE			CONSTRAINT NN_JOB_HIST_END_DATE		NOT NULL ENABLE,
    JOB_ID			VARCHAR2(10)	CONSTRAINT NN_JOB_HIST_JOB			NOT NULL ENABLE,
    DEPARTMENT_ID	NUMBER(4,0),
    CONSTRAINT CK_JOB_HIST_DATE_INTERVAL CHECK (end_date > start_date) ENABLE,
    CONSTRAINT PK_JOB_HISTORY PRIMARY KEY (EMPLOYEE_ID, START_DATE)
		USING INDEX  ENABLE
);

--	ADD FOREIGN KEY CONSTRAINTS TO EMPLOYEES TABLE
ALTER TABLE  JOB_HISTORY ADD CONSTRAINT FK_JOB_HIST_DEPT FOREIGN KEY (DEPARTMENT_ID)
	REFERENCES  DEPARTMENTS (DEPARTMENT_ID) ENABLE;
-- the folLowing FK constraint is disabled as table contains historical data for employees that are not in the current employees table
--ALTER TABLE  JOB_HISTORY ADD CONSTRAINT FK_JOB_HIST_EMP FOREIGN KEY (EMPLOYEE_ID)
--	REFERENCES  EMPLOYEES (EMPLOYEE_ID) DISABLE;
ALTER TABLE  JOB_HISTORY ADD CONSTRAINT FK_JOB_HIST_JOB FOREIGN KEY (JOB_ID)
	REFERENCES  JOBS (JOB_ID) ENABLE;
CREATE INDEX  IX_JOB_HIST_DEPT ON  JOB_HISTORY (DEPARTMENT_ID);
CREATE INDEX  IX_JOB_HIST_EMP ON  JOB_HISTORY (EMPLOYEE_ID);
CREATE INDEX  IX_JOB_HIST_JOB ON  JOB_HISTORY (JOB_ID);


-- --------------------------------------------------------------------------------------------------
--	INSERT DATA INTO TABLES
-- --------------------------------------------------------------------------------------------------

--	POPULATE REGIONS TABLE
INSERT INTO regions (region_id, region_name)
	Values(1,'Europe');
INSERT INTO regions (region_id, region_name)
	Values(2,'Americas');
INSERT INTO regions (region_id, region_name)
	Values(3,'Asia');
INSERT INTO regions (region_id, region_name)
	Values(4,'Middle East and Africa');

--	POPULATE COUNTRIES TABLE
INSERT INTO countries (country_id, country_name, region_id)
	Values('CA','Canada',2);
INSERT INTO countries (country_id, country_name, region_id)
	Values('DE','Germany',1);
INSERT INTO countries (country_id, country_name, region_id)
	Values('UK','United Kingdom',1);
INSERT INTO countries (country_id, country_name, region_id)
	Values('US','United States of America',2);

--	POPULATE LOCATIONS TABLE
INSERT INTO locations (location_id, street_address, postal_code, city, state_province, country_id)
	Values(1800,'460 Bloor St. W.','ON M5S 1X8','Toronto','Ontario','CA');
INSERT INTO locations (location_id, street_address, postal_code, city, state_province, country_id)
	Values(2500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK');
INSERT INTO locations (location_id, street_address, postal_code, city, state_province, country_id)
	Values(1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US');
INSERT INTO locations (location_id, street_address, postal_code, city, state_province, country_id)
	Values(1500,'2011 Interiors Blvd','99236','South San Francisco','California','US');
INSERT INTO locations (location_id, street_address, postal_code, city, state_province, country_id)
	Values(1700,'2004 Charade Rd','98199','Seattle','Washington','US');

--	POPULATE DEPARTMENTS TABLE
INSERT INTO departments (department_id, department_name, manager_id, location_id)
	Values(10,'Administration',200,1700);
INSERT INTO departments (department_id, department_name, manager_id, location_id)
	Values(20,'Marketing',201,1800);
INSERT INTO departments (department_id, department_name, manager_id, location_id)
	Values(50,'Shipping',124,1500);
INSERT INTO departments (department_id, department_name, manager_id, location_id)
	Values(60,'IT',103,1400);
INSERT INTO departments (department_id, department_name, manager_id, location_id)
	Values(80,'Sales',149,2500);
INSERT INTO departments (department_id, department_name, manager_id, location_id)
	Values(90,'Executive',100,1700);
INSERT INTO departments (department_id, department_name, manager_id, location_id)
	Values(110,'Accounting',205,1700);
INSERT INTO departments (department_id, department_name, manager_id, location_id)
	Values(190,'Contracting',null,1700);

--	POPULATE JOBS TABLE
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('AD_PRES','President',20000,40000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('AD_VP','Administration Vice President',15000,30000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('AD_ASST','Administration Assistant',3000,6000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('AC_MGR','Accounting Manager',8200,16000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('AC_ACCOUNT','Public Accountant',4200,9000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('SA_MAN','Sales Manager',10000,20000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('SA_REP','Sales Representative',6000,12000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('ST_MAN','Stock Manager',5500,8500);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('ST_CLERK','Stock Clerk',2000,5000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('IT_PROG','Programmer',4000,10000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('MK_MAN','Marketing Manager',9000,15000);
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
	VALUES('MK_REP','Marketing Representative',4000,9000);

--	POPULATE EMPLOYEES TABLE
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(100,'Steven','King','SKING@smallcompany.com','515.123.4567',TO_DATE('1987-06-17','yyyy-mm-dd'),'AD_PRES',24000,null,null,90);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(101,'Neena','Kochhar','NKOCHHAR@smallcompany.com','515.123.4568',TO_DATE('1989-09-21','yyyy-mm-dd'),'AD_VP',17000,null,100,90 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(102,'Lex','De Haan','LDEHAAN@smallcompany.com','515.123.4569',TO_DATE('1993-01-13','yyyy-mm-dd'),'AD_VP',17000,null,100,90 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(200,'Jennifer','Whalen','JWHALEN@smallcompany.com','515.123.4444',TO_DATE('1987-09-17','yyyy-mm-dd'),'AD_ASST',4400,null,101,10 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(205,'Shelley','Higgins','SHIGGINS@smallcompany.com','515.123.8080',TO_DATE('1994-06-07','yyyy-mm-dd'),'AC_MGR',12000,null,101,110 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(206,'William','Gietz','WGIETZ@smallcompany.com','515.123.8181',TO_DATE('1994-06-07','yyyy-mm-dd'),'AC_ACCOUNT',8300,null,205,110 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID, BONUS)
	VALUES(149,'Eleni','Zlotkey','EZLOTKEY@smallcompany.com','011.44.1344.429018',TO_DATE('2000-01-29','yyyy-mm-dd'),'SA_MAN',10500,.2,100,80, '1500' );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID, BONUS)
	VALUES(174,'Ellen','Abel','EABEL@smallcompany.com','011.44.1644.429267',TO_DATE('1996-05-11','yyyy-mm-dd'),'SA_REP',11000,.3,149,80,'1700' );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID, BONUS)
	VALUES(176,'Jonathon','Taylor','JTAYLOR@smallcompany.com','011.44.1644.429265',TO_DATE('1998-03-24','yyyy-mm-dd'),'SA_REP',8600,.2,149,80,'1250' );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(178,'Kimberely','Grant','KGRANT@smallcompany.com','011.44.1644.429263',TO_DATE('1999-05-24','yyyy-mm-dd'),'SA_REP',7000,.15,149,null );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(124,'Kevin','Mourgos','KMOURGOS@smallcompany.com','650.123.5234',TO_DATE('1999-11-16','yyyy-mm-dd'),'ST_MAN',5800,null,100,50);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(141,'Trenna','Rajs','TRAJS@smallcompany.com','650.121.8009',TO_DATE('1995-10-17','yyyy-mm-dd'),'ST_CLERK',3500,null,124,50 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(142,'Curtis','Davies','CDAVIES@smallcompany.com','650.121.2994',TO_DATE('1997-01-29','yyyy-mm-dd'),'ST_CLERK',3100,null,124,50 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(143,'Randall','Matos','RMATOS@smallcompany.com','650.121.2874',TO_DATE('1998-03-15','yyyy-mm-dd'),'ST_CLERK',2600,null,124,50 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(144,'Peter','Vargas','PVARGAS@smallcompany.com','650.121.2004',TO_DATE('1998-07-09','yyyy-mm-dd'),'ST_CLERK',2500,null,124,50 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(103,'Alexander','Hunold','AHUNOLD@smallcompany.com','590.423.4567',TO_DATE('1990-01-03','yyyy-mm-dd'),'IT_PROG',9000,null,102,60 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(104,'Bruce','Ernst','BERNST@smallcompany.com','590.423.4568',TO_DATE('1991-05-21','yyyy-mm-dd'),'IT_PROG',6000,null,103,60 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(107,'Diana','Lorentz','DLORENTZ@smallcompany.com','590.423.5567',TO_DATE('1999-02-07','yyyy-mm-dd'),'IT_PROG',4200,null,103,60 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(201,'Michael','Hartstein','MHARTSTE@smallcompany.com','515.123.5555',TO_DATE('1996-02-17','yyyy-mm-dd'),'MK_MAN',13000,null,100,20 );
INSERT INTO EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
	VALUES(202,'Pat','Fay','PFAY@smallcompany.com','603.123.6666',TO_DATE('1997-08-17','yyyy-mm-dd'),'MK_REP',6000,null,201,20 );

--	POPULATE JOB_HISTORY TABLE
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(200,TO_DATE('09-17-1987','mm-dd-yyyy'),TO_DATE('06-17-1993','mm-dd-yyyy'),'AD_ASST',90 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(101,TO_DATE('10-28-1993','mm-dd-yyyy'),TO_DATE('03-15-1997','mm-dd-yyyy'),'AC_MGR',110 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(200,TO_DATE('07-01-1994','mm-dd-yyyy'),TO_DATE('12-31-1998','mm-dd-yyyy'),'AC_ACCOUNT',90 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(101,TO_DATE('09-21-1989','mm-dd-yyyy'),TO_DATE('10-27-1993','mm-dd-yyyy'),'AC_ACCOUNT',110 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(176,TO_DATE('01-01-1999','mm-dd-yyyy'),TO_DATE('12-31-1999','mm-dd-yyyy'),'SA_MAN',80 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(176,TO_DATE('03-24-1998','mm-dd-yyyy'),TO_DATE('12-31-1998','mm-dd-yyyy'),'SA_REP',80 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(122,TO_DATE('01-01-1999','mm-dd-yyyy'),TO_DATE('12-31-1999','mm-dd-yyyy'),'ST_CLERK',50 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(114,TO_DATE('03-24-1998','mm-dd-yyyy'),TO_DATE('12-31-1999','mm-dd-yyyy'),'ST_CLERK',50 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(102,TO_DATE('01-13-1993','mm-dd-yyyy'),TO_DATE('07-24-1998','mm-dd-yyyy'),'IT_PROG',60 );
INSERT INTO JOB_HISTORY(EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID)
	VALUES(201,TO_DATE('02-17-1996','mm-dd-yyyy'),TO_DATE('12-19-1999','mm-dd-yyyy'),'MK_REP',20 );


-- --------------------------------------------------------------------------------------------------
--	ENABLE CONSTRAINTS
-- --------------------------------------------------------------------------------------------------

--	ENABLE FK_DPT_MGR CONSTRAINT
ALTER TABLE  DEPARTMENTS ENABLE CONSTRAINT FK_DEPT_MGR;


-- --------------------------------------------------------------------------------------------------
--	CREATE VIEW
-- --------------------------------------------------------------------------------------------------

--	CREATE EMP_DETAILS_VIEW VIEW
CREATE OR REPLACE FORCE VIEW  
	EMP_DETAILS_VIEW (EMPLOYEE_ID, JOB_TITLE, MANAGER_ID, DEPARTMENT_NAME, FIRST_NAME, LAST_NAME, SALARY, COMMISSION_PCT) 
	AS SELECT
		E.EMPLOYEE_ID, J.JOB_TITLE, E.MANAGER_ID, D.DEPARTMENT_NAME,
		E.FIRST_NAME, E.LAST_NAME, E.SALARY, E.COMMISSION_PCT
    FROM
        EMPLOYEES E,
        DEPARTMENTS D,
        JOBS J
    WHERE
        E.DEPARTMENT_ID = D.DEPARTMENT_ID
        AND J.JOB_ID = E.JOB_ID
    WITH READ ONLY;

	
-- --------------------------------------------------------------------------------------------------
--	CREATE SEQUENCES
-- --------------------------------------------------------------------------------------------------

--	Create sequence for DEPARTMENTS PK				
CREATE SEQUENCE DEPARTMENTS_SEQ  
	MINVALUE 1 
	MAXVALUE 9990 
	INCREMENT BY 10 
	START WITH 280 
	NOCACHE  NOORDER  NOCYCLE;

--	Create sequence for EMPLOYEES PK	
CREATE SEQUENCE EMPLOYEES_SEQ  
	MINVALUE 1 
	MAXVALUE 9999999999999999999999999999 
	INCREMENT BY 1 
	START WITH 207 
	NOCACHE  NOORDER  NOCYCLE;

--Create sequence for locations PK	
CREATE SEQUENCE "LOCATIONS_SEQ"  
	MINVALUE 1 
	MAXVALUE 9900 
	INCREMENT BY 100 
	START WITH 3300 
	NOCACHE  NOORDER  NOCYCLE;