CREATE INDEX IX_Users_Email        ON [identity].Users (Email)        INCLUDE (FirstName, LastName);
CREATE INDEX IX_Users_LastName     ON [identity].Users (LastName)     INCLUDE (FirstName, Email);
CREATE INDEX IX_Users_CreatedAtUtc ON [identity].Users (CreatedAtUtc) INCLUDE (Email);
CREATE INDEX IX_Payments_PaidAtUtc ON finance.Payments (PaidAtUtc) INCLUDE (InvoiceId, Amount);
CREATE INDEX IX_Invoices_Number    ON finance.Invoices (InvoiceNumber);

-- 7.1 Before
SET STATISTICS IO ON
SELECT Id, Email
FROM [identity].Users
WHERE YEAR(CreatedAtUtc) = 2026
AND MONTH(CreatedAtUtc) = 3;
SET STATISTICS IO OFF

-- 7.1 After
SET STATISTICS IO ON
SELECT Id, Email
FROM [identity].Users
WHERE CreatedAtUtc >= '2026-03-01'
AND CreatedAtUtc <= '2026-04-01'
SET STATISTICS IO OFF


-- 7.2 Before
SET STATISTICS IO ON
SELECT Id, InvoiceId, Amount
FROM [finance].[Payments]
WHERE DATEDIFF(DAY, PaidAtUtc, SYSUTCDATETIME()) <= 30;
SET STATISTICS IO OFF

-- 7.2 After
SET STATISTICS IO ON
SELECT Id, InvoiceId, Amount
FROM [finance].[Payments]
WHERE PaidAtUtc >= DATEADD(DAY, -30, CONVERT(date, SYSUTCDATETIME()));
SET STATISTICS IO OFF

-- 7.3 Before
SET STATISTICS IO ON
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LEFT(LastName, 3) = N'Abd';
SET STATISTICS IO OFF

-- 7.3 After
SET STATISTICS IO ON
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LastName LIKE 'Abd%';
SET STATISTICS IO OFF

-- 7.4 Before
SET STATISTICS IO ON
SELECT *
FROM operations.AuditLogs
WHERE Id + 1 = 50001;
SET STATISTICS IO OFF

-- 7.4 After
SET STATISTICS IO ON
SELECT *
FROM operations.AuditLogs
WHERE Id = 50000;
SET STATISTICS IO OFF

-- 7.5 Before
SET STATISTICS IO ON
SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber
      = N'LAB-INV-2026-000001'
SET STATISTICS IO OFF

-- 7.5 After
SET STATISTICS IO ON
SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber
      = 'LAB-INV-2026-000001'
SET STATISTICS IO OFF

-- 7.6 Before
SET STATISTICS IO ON
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE UPPER(Email) = UPPER(@Email);
SET STATISTICS IO OFF

-- 7.6 After
SET STATISTICS IO ON
DECLARE @Email NVARCHAR(320) = N'...';
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE Email = @Email;
SET STATISTICS IO OFF

-- 7.7 Before
SET STATISTICS IO ON
DECLARE @LastName NVARCHAR(100) = N'Hassan';
SELECT Id, FirstName, Email
FROM [identity].Users
WHERE (@LastName IS NULL
OR LastName = @LastName)
SET STATISTICS IO OFF

-- 7.7 After
SET STATISTICS IO ON
DECLARE @LastName NVARCHAR(100) = N'Hassan';
SELECT Id, FirstName, Email
FROM [identity].Users
WHERE (@LastName IS NULL
OR LastName = @LastName)
OPTION (RECOMPILE)
SET STATISTICS IO OFF

-- 7.8 Before
SET STATISTICS IO ON
SELECT Id, FirstName, LastName, Email
FROM [identity].Users
WHERE CONCAT(FirstName, N' ', LastName) = N'Ahmed Hassan';
SET STATISTICS IO OFF

-- 7.8 After
SET STATISTICS IO ON
SELECT Id, FirstName, LastName, Email
FROM [identity].Users
WHERE LastName = N'Hassan'
  AND FirstName = N'Ahmed';
SET STATISTICS IO OFF