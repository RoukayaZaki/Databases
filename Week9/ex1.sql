CREATE TABLE  accounts
(
    id       INTEGER primary key,
    name     VARCHAR(50) not null,
    credit   INTEGER     not null,
    currency VARCHAR(50) not null
);

INSERT INTO accounts (id, name, credit, currency)
VALUES (1, 'account1', 1000, 'rub'),
       (2, 'account2', 1000, 'rub'),
       (3, 'account3', 1000, 'rub'),
       (4, 'account4', 0, 'rub');

ALTER TABLE accounts ADD COLUMN bankname VARCHAR(50);

UPDATE accounts SET bankname = 'sberbank' WHERE name='account1';
UPDATE accounts SET bankname = 'tinkoff' WHERE name='account2';
UPDATE accounts SET bankname = 'sberbank' WHERE name='account3';
UPDATE accounts SET bankname = 'both' WHERE name='account4';

create table Ledger(
    id INTEGER primary key,
    fromId INTEGER,
    toId INTEGER,
    fee INTEGER,
    amount INTEGER,
    transactionDateTime date
);


CREATE FUNCTION transfer(sender INTEGER, receiver INTEGER, money float8)
RETURNS INTEGER LANGUAGE plpgsql AS
$$BEGIN
    UPDATE accounts SET credit = credit - money WHERE id = sender;
    UPDATE accounts SET credit = credit + money WHERE id = receiver;
    INSERT INTO Ledger (fromId, toId, fee, amount, transactionDateTime) values( sender, receiver, money, 0, LOCALTIME);
    IF (SELECT accounts.BankName from accounts where id = sender) != (SELECT accounts.BankName from accounts where id = receiver) THEN
        UPDATE accounts set credit = credit - 30 where id = sender;
        UPDATE accounts set credit = credit + 30 where id = 4;
        UPDATE Ledger SET fee = fee + 30 WHERE fromId = sender and toId = receiver;
    END IF;
    RETURN 1;
END;
$$;


BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SAVEPOINT T1;
select transfer(1,3,500);
--ROLLBACK TO T1;
COMMIT;
END;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SAVEPOINT T2;
select transfer(2,1,700);
--ROLLBACK TO T2;
COMMIT;
END;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SAVEPOINT T3;
select transfer(2,3,100);
--ROLLBACK TO T3;
COMMIT;
END;