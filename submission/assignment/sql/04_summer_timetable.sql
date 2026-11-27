-- 4
DECLARE @SummerTermId int = (
    SELECT Id
    FROM [delivery].[AcademicTerms]
    WHERE AcademicYear = 2027 AND TermCode = 'SUMMER'
);

DECLARE @SourceTermId int = (
    SELECT TOP (1) Id
    FROM [delivery].[AcademicTerms]
    WHERE StartDate <= CAST(GETDATE() AS date)
      AND Id <> @SummerTermId
    ORDER BY StartDate DESC, Id DESC
);

INSERT INTO [delivery].[Sections]
    (CourseId, TermId, SectionCode, Capacity, Location, DeliveryMode, Status)
SELECT CourseId, @SummerTermId, SectionCode, Capacity, Location, DeliveryMode, Status
FROM [delivery].[Sections]
WHERE TermId = @SourceTermId;

select * 
FROM [delivery].[Sections]
WHERE TermId = @SummerTermId
ORDER BY CourseId, SectionCode;

