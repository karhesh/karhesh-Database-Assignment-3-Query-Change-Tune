-- Task 13
CREATE TABLE #WebsiteCatalog
(
    CourseId int PRIMARY KEY,
    Code varchar(30) NOT NULL,
    Title nvarchar(200) NOT NULL,
    CreditHours decimal(4, 2) NOT NULL,
    IsVisible bit NOT NULL
);

MERGE #WebsiteCatalog AS w
USING (
    SELECT Id, Code, Title, CreditHours
    FROM [academic].[Courses]
    WHERE IsActive = 1
) AS c
ON w.CourseId = c.Id

WHEN MATCHED AND (
    w.Code <> c.Code
    OR w.Title <> c.Title
    OR w.CreditHours <> c.CreditHours
    OR w.IsVisible = 0
) THEN
    UPDATE SET w.Code = c.Code,
               w.Title = c.Title,
               w.CreditHours = c.CreditHours,
               w.IsVisible = 1

WHEN NOT MATCHED BY TARGET THEN
    INSERT (CourseId, Code, Title, CreditHours, IsVisible)
    VALUES (c.Id, c.Code, c.Title, c.CreditHours, 1)

WHEN NOT MATCHED BY SOURCE AND w.IsVisible = 1 THEN
    UPDATE SET w.IsVisible = 0

OUTPUT $action AS ActionTaken, INSERTED.Code, INSERTED.Title, INSERTED.IsVisible;