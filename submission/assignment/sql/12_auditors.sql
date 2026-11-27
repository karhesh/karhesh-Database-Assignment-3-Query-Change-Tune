-- 12.1
    CREATE TABLE [operations].[CoursePassMarkHistory]
    (
        HistoryId bigint IDENTITY(1, 1) PRIMARY KEY,
        CourseId int NOT NULL,
        OldPassMark decimal(5, 2) NOT NULL,
        NewPassMark decimal(5, 2) NOT NULL,
        ChangedAtUtc datetime2(7) NOT NULL,
        ChangedBy sysname NOT NULL
    );

DECLARE @NewPassMark decimal(5, 2) = 70;
DECLARE @ChangedAtUtc datetime2(7) = SYSUTCDATETIME();
DECLARE @ChangedBy sysname = ORIGINAL_LOGIN();

UPDATE [academic].[Courses]
SET PassingScore = @NewPassMark
OUTPUT
    INSERTED.Id,
    DELETED.PassingScore,
    INSERTED.PassingScore,
    @ChangedAtUtc,
    @ChangedBy
INTO [operations].[CoursePassMarkHistory]
    (CourseId, OldPassMark, NewPassMark, ChangedAtUtc, ChangedBy)
WHERE DepartmentId = (
    SELECT Id
    FROM [academic].[Departments]
    WHERE Code = 'DSAI'
)
AND PassingScore <> @NewPassMark;

-- 12.2
IF OBJECT_ID(N'communication.AnnouncementArchive', N'U') IS NULL

    CREATE TABLE [communication].[AnnouncementArchive]
    (
        Id bigint PRIMARY KEY,
        SectionId bigint NULL,
        Title nvarchar(200) NOT NULL,
        Body nvarchar(max) NOT NULL,
        PublishedAtUtc datetime2(0) NULL,
        ExpiresAtUtc datetime2(0) NULL,
        CreatedByUserId bigint NOT NULL,
        CreatedAtUtc datetime2(0) NOT NULL,
        UpdatedAtUtc datetime2(0) NOT NULL,
        Status tinyint NOT NULL,
        ArchivedAtUtc datetime2(7) NOT NULL
    );
DECLARE @ArchivedAtUtc datetime2(7) = SYSUTCDATETIME();

DELETE FROM [communication].[Announcements]
OUTPUT
    DELETED.Id, DELETED.SectionId, DELETED.Title, DELETED.Body,
    DELETED.PublishedAtUtc, DELETED.ExpiresAtUtc, DELETED.CreatedByUserId,
    DELETED.CreatedAtUtc, DELETED.UpdatedAtUtc, DELETED.Status, @ArchivedAtUtc
INTO [communication].[AnnouncementArchive]
    (Id, SectionId, Title, Body, PublishedAtUtc, ExpiresAtUtc,
     CreatedByUserId, CreatedAtUtc, UpdatedAtUtc, Status, ArchivedAtUtc)
WHERE ExpiresAtUtc < DATEADD(MONTH, -6, @ArchivedAtUtc);