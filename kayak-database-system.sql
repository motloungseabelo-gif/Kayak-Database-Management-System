-- QUESTION 2
-- Create tables

CREATE TABLE kayaks (
    kayak_id        NUMBER(5)      PRIMARY KEY,
    kayak_type      VARCHAR2(50)   NOT NULL,
    kayak_model     VARCHAR2(20)   NOT NULL,
    manufacturer    VARCHAR2(50)   NOT NULL
);

CREATE TABLE customer (
    cust_id         VARCHAR2(4)    PRIMARY KEY,
    cust_fname      VARCHAR2(30)   NOT NULL,
    cust_sname      VARCHAR2(30)   NOT NULL,
    cust_address    VARCHAR2(100)  NOT NULL,
    cust_contact    VARCHAR2(10)   NOT NULL
);

CREATE TABLE upgrades (
    upgrade_id      NUMBER(2)      PRIMARY KEY,
    upgrade_work    VARCHAR2(50)   NOT NULL,
    upgrade_date    DATE           NOT NULL,
    upgrade_hrs     NUMBER(5)      NOT NULL
);

CREATE TABLE kayak_upgrades (
    kayak_upgrade_num   NUMBER(3)      PRIMARY KEY,
    kayak_upgrade_date  DATE           NOT NULL,
    kayak_upgrade_amt   NUMBER(10,2)   NOT NULL,
    kayak_id            NUMBER(5)      NOT NULL,
    cust_id             VARCHAR2(4)    NOT NULL,
    upgrade_id          NUMBER(2)      NOT NULL,

    CONSTRAINT fk_kayak
        FOREIGN KEY (kayak_id) REFERENCES kayaks(kayak_id),

    CONSTRAINT fk_customer
        FOREIGN KEY (cust_id) REFERENCES customer(cust_id),

    CONSTRAINT fk_upgrade
        FOREIGN KEY (upgrade_id) REFERENCES upgrades(upgrade_id)
);

-- Insert into KAYAKS
INSERT INTO kayaks VALUES (12345, 'Single Seater',  'K100',  'FeelFree');
INSERT INTO kayaks VALUES (54321, 'Tandem Seater',  'J55',   'Roamer');
INSERT INTO kayaks VALUES (78945, 'Fishing Kayak',  'H9000', 'Wavesport');
INSERT INTO kayaks VALUES (98754, 'Hobie Kayak',    'A450',  'Gemini');
INSERT INTO kayaks VALUES (55311, 'Canadian Style', 'L920',  'Surge');

-- Insert into CUSTOMER
INSERT INTO customer VALUES ('C115', 'Jeff',   'Willis',     '3 Main Road',     '0821253659');
INSERT INTO customer VALUES ('C116', 'Andre',  'Watson',     '13 Cape Road',    '0769658547');
INSERT INTO customer VALUES ('C117', 'Wallis', 'Smith',      '3 Mountain Road', '0863256574');
INSERT INTO customer VALUES ('C118', 'Alex',   'Hanson',     '8 Circle Road',   '0762356587');
INSERT INTO customer VALUES ('C119', 'Bob',    'Bitterhout', '15 Main Road',    '0821235258');
INSERT INTO customer VALUES ('C120', 'Thando', 'Zolani',     '88 Summer Road',  '0847541254');
INSERT INTO customer VALUES ('C121', 'Philip', 'Jackson',    '3 Long Road',     '0745556658');
INSERT INTO customer VALUES ('C122', 'Sarah',  'Jones',      '7 Sea Road',      '0814745745');

-- Insert into UPGRADES
INSERT INTO upgrades VALUES (1, 'Sonar Device',        TO_DATE('15-JUL-22','DD-MON-RR'), 5);
INSERT INTO upgrades VALUES (2, 'Padded Seats',        TO_DATE('18-JUL-22','DD-MON-RR'), 3);
INSERT INTO upgrades VALUES (3, 'GoPro Camera Mount',  TO_DATE('19-JUL-22','DD-MON-RR'), 10);

-- Insert into KAYAK_UPGRADES
INSERT INTO kayak_upgrades VALUES (101, TO_DATE('27-JUL-19','DD-MON-RR'), 75, 98754, 'C121', 3);
INSERT INTO kayak_upgrades VALUES (102, TO_DATE('20-JUL-19','DD-MON-RR'), 30, 12345, 'C120', 2);
INSERT INTO kayak_upgrades VALUES (103, TO_DATE('23-JUL-19','DD-MON-RR'), 75, 55311, 'C119', 1);
INSERT INTO kayak_upgrades VALUES (104, TO_DATE('17-JUL-19','DD-MON-RR'), 50, 54321, 'C117', 1);
INSERT INTO kayak_upgrades VALUES (105, TO_DATE('19-JUL-19','DD-MON-RR'), 30, 12345, 'C122', 2);

COMMIT;

CREATE USER Tshepo IDENTIFIED BY tmphoabc2023;
GRANT CREATE SESSION TO Tshepo;
GRANT SELECT ANY TABLE TO Tshepo;

CREATE USER Mya IDENTIFIED BY mrobertabc2023;
GRANT CREATE SESSION TO Mya;
GRANT INSERT ANY TABLE TO Mya;

SELECT username
FROM dba_users
WHERE username IN ('TSHEPO', 'MYA', 'C##TSHEPO', 'C##MYA');

SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee IN ('TSHEPO', 'MYA', 'C##TSHEPO', 'C##MYA');

/*
Separation of duties is important because it improves security and reduces the risk
of fraud or accidental damage to the database. Tshepo only has permission to read
data, while Mya only has permission to insert data. This means no single user has
full control over the data, which improves accountability and protects the system.
*/

SELECT
    ku.kayak_id,
    ku.cust_id,
    u.upgrade_hrs,
    ku.kayak_upgrade_amt,
    (u.upgrade_hrs * ku.kayak_upgrade_amt) AS total
FROM kayak_upgrades ku
JOIN upgrades u
    ON ku.upgrade_id = u.upgrade_id;
    
    

SELECT
    c.cust_fname || ' ' || c.cust_sname AS customer,
    k.kayak_type,
    u.upgrade_hrs,
    u.upgrade_work,
    ku.kayak_upgrade_amt
FROM customer c
JOIN kayak_upgrades ku
    ON c.cust_id = ku.cust_id
JOIN kayaks k
    ON ku.kayak_id = k.kayak_id
JOIN upgrades u
    ON ku.upgrade_id = u.upgrade_id;
    
    
SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_upgrades IS
        SELECT
            ku.cust_id,
            u.upgrade_work,
            ku.kayak_upgrade_amt
        FROM kayak_upgrades ku
        JOIN upgrades u
            ON ku.upgrade_id = u.upgrade_id
        WHERE ku.kayak_upgrade_amt > 50;

    v_cust_id           kayak_upgrades.cust_id%TYPE;
    v_upgrade_work      upgrades.upgrade_work%TYPE;
    v_upgrade_amt       kayak_upgrades.kayak_upgrade_amt%TYPE;

BEGIN
    OPEN c_upgrades;

    LOOP
        FETCH c_upgrades INTO v_cust_id, v_upgrade_work, v_upgrade_amt;
        EXIT WHEN c_upgrades%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('CUSTOMER ID:      ' || v_cust_id);
        DBMS_OUTPUT.PUT_LINE('UPGRADE WORK:     ' || v_upgrade_work);
        DBMS_OUTPUT.PUT_LINE('UPGRADE AMOUNT: R ' || v_upgrade_amt);
    END LOOP;

    CLOSE c_upgrades;
END;
/

/*
Cursor type used: Explicit cursor.

Reason 1:
An explicit cursor is suitable because the query returns multiple rows and each row
must be processed one at a time.

Reason 2:
It gives the programmer full control over OPEN, FETCH and CLOSE, making it easier
to format the output using DBMS_OUTPUT.
*/

SELECT
    c.cust_fname || ' ' || c.cust_sname AS customer,
    k.kayak_type,
    u.upgrade_work,
    ku.kayak_upgrade_date,
    ku.kayak_upgrade_amt AS upgrade_amt,
    ku.kayak_upgrade_amt * 0.10 AS discount_amt
FROM customer c
JOIN kayak_upgrades ku
    ON c.cust_id = ku.cust_id
JOIN kayaks k
    ON ku.kayak_id = k.kayak_id
JOIN upgrades u
    ON ku.upgrade_id = u.upgrade_id
WHERE c.cust_id = 'C121';


CREATE OR REPLACE VIEW vwCustUpgrades AS
SELECT
    c.cust_fname || ', ' || c.cust_sname AS customer,
    k.kayak_type,
    u.upgrade_work,
    c.cust_contact AS contact
FROM customer c
JOIN kayak_upgrades ku
    ON c.cust_id = ku.cust_id
JOIN kayaks k
    ON ku.kayak_id = k.kayak_id
JOIN upgrades u
    ON ku.upgrade_id = u.upgrade_id
WHERE c.cust_address LIKE '%Summer%';

SELECT * FROM vwCustUpgrades;