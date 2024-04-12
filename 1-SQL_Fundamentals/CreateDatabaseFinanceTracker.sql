CREATE DATABASE FinanceTracker;

USE FinanceTracker;

CREATE TABLE [User](
    UserId INTEGER PRIMARY KEY IDENTITY (1,1),
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL
);

CREATE TABLE [Credentials](
    CredentialsId INTEGER PRIMARY KEY,
    UserId INT UNIQUE, 
    Email VARCHAR(50) NOT NULL UNIQUE, 
    Password VARCHAR(50) NOT NULL,
    FOREIGN KEY (UserId) REFERENCES [User](UserId) 
);

CREATE TABLE Account(
    AccountId INTEGER PRIMARY KEY,
    CredentialsId INT UNIQUE, 
    Balance MONEY NOT NULL DEFAULT 0,
    FOREIGN KEY (CredentialsId) REFERENCES [Credentials](CredentialsId) 
);

CREATE TABLE TransactionType(
    TransactionTypeId INTEGER PRIMARY KEY,
    [Type] VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO TransactionType(TransactionTypeId, [Type])
VALUES (1, 'Income'),
       (2, 'Expense');

CREATE TABLE Category(
    CategoryId INTEGER PRIMARY KEY IDENTITY (1,1),
    Title VARCHAR(20) NOT NULL,
    TransactionTypeId INT FOREIGN KEY REFERENCES TransactionType(TransactionTypeId) NOT NULL,
    Icon VARCHAR(50) NOT NULL 
);

CREATE TABLE [Transaction](
    TransactionId INTEGER PRIMARY KEY IDENTITY (1,1),
    AccountId INT FOREIGN KEY REFERENCES Account(AccountId) NOT NULL,
    Amount MONEY NOT NULL,
    [Date] DATETIME NOT NULL,
    [Description] VARCHAR(100),
    CategoryId INT FOREIGN KEY REFERENCES Category(CategoryId) NOT NULL,
);
