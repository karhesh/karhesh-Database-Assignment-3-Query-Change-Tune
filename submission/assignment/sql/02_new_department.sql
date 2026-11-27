-- 2.1
insert into [academic].[Departments] (Code, Name)
values
	  ('DSAI', N'Data Science & Artificial Intelligence')

-- 2.2
insert into [academic].[Courses] (Title, DepartmentId, Code, CreditHours, PassingScore)
values
(N'Introduction to Data Analysis',
(select Id
    from [academic].[Departments] where Code = 'DSAI')
, N'DSAI-101', 3.00, 60.00)

--2.3
select * from [delivery].[AcademicTerms]
insert into [delivery].[AcademicTerms]
values
(2027, 'SUMMER', 'Summer 2027', '2027-06-15', '2027-08-31', '2027-05-01', '2027-06-10', 1)

--2.4
INSERT INTO [communication].[Announcements]
    (SectionId, Title, Body, PublishedAtUtc, CreatedByUserId, Status)
VALUES
    (NULL,
     N'Summer 2027 Registration',
     N'Summer 2027 registration opens on May 1, 2027.',
     SYSUTCDATETIME(),
     1,
     2);

--2.5
insert into [identity].[Roles] (Code, Name)
values ('TEACHING_ASSIS', N'Teaching Assistant')

select * from [identity].[Roles]