-- 11.1
update [academic].[Courses]
set PassingScore = 65
where DepartmentId = (
						Select Id
						from [academic].[Departments]
						where Code = 'DSAI'
					)

-- 11.2
UPDATE [delivery].[Enrollments]
SET FinalGrade = CASE
    WHEN FinalScore >= 90 THEN 'A'
    WHEN FinalScore >= 80 THEN 'B'
    WHEN FinalScore >= 70 THEN 'C'
    WHEN FinalScore >= 60 THEN 'D'
    ELSE 'F'
END
WHERE FinalScore IS NOT NULL
  AND EnrollmentStatusId IN (
      SELECT Id
      FROM [ref].[EnrollmentStatuses]
      WHERE IsFinal = 1
  );

-- 11.3
DELETE FROM [identity].[Roles]
WHERE Code = 'TEACHING_ASSIS'
  AND IsSystem = 0;
  
-- 11.4
CREATE TABLE #TempPayment
(
    InvoiceId bigint NOT NULL,
    PaymentMethodId tinyint NOT NULL,
    Amount decimal(12, 2) NOT NULL,
    CurrencyCode char(3) NOT NULL
);

INSERT INTO #TempPayment
    (InvoiceId, PaymentMethodId, Amount, CurrencyCode)
VALUES
    (1, 1, 500.00, 'EGP'),
    (2, 2, 750.00, 'EGP'),
    (3, 3, 1000.00, 'EGP');


TRUNCATE TABLE #TempPayment;

-- 11.5
DROP TABLE IF EXISTS #TempPayment;
DROP TABLE IF EXISTS #LateInvoices;
DROP TABLE IF EXISTS #Users8;