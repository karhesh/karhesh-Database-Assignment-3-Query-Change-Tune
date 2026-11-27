-- 8. Before
DECLARE @UserList TABLE
(
    Id bigint NOT NULL PRIMARY KEY,
    LastName nvarchar(100) NOT NULL,
    IsDeleted bit NOT NULL
);

INSERT INTO @UserList (Id, LastName, IsDeleted)
SELECT Id, LastName, IsDeleted
FROM [identity].[Users];

SELECT Id, LastName
FROM @UserList
WHERE IsDeleted = 0
ORDER BY LastName, Id

-- 8 After
DROP TABLE IF EXISTS #Users8;

SELECT Id, LastName, IsDeleted
INTO #Users8
FROM [identity].[Users];

ALTER TABLE #Users8 ADD PRIMARY KEY (Id);

SELECT Id, LastName
FROM #Users8
WHERE IsDeleted = 0
ORDER BY LastName, Id

