-- 5.1
select Code as [Course Code], Title, CreditHours as [Credit Hours]
from [academic].[Courses]
order by CreditHours DESC, Title ASC

-- 5.2
select top 5 StudentNumber
from [identity].[StudentProfiles]
order by NEWID()

-- 5.3
select Email
from [identity].[Users]
where Email Like '% ' or Email like ' %'

-- 5.4
select Email
from [identity].[Users]
where Email <> lower(Email)

-- 5.5
select Email
from [identity].[Users]
where Email not like '%@%'
	or Email like '@%'
	or Email not like '%@%.%'

-- 5.6
select distinct SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) as EmailProvider
from [identity].[Users]
where Email like '%@%.%'
  and Email not like '@%'
order by EmailProvider ASC

-- 5.7
select *
from [identity].[Users]
order by LastLoginAtUtc DESC

-- 5.8
select *
from [finance].[Payments]
where PaidAtUtc >= '2026-10-01'
AND PaidAtUtc < '2026-11-01'

-- 5.9
select *,
	PaidAtUtc at time zone 'UTC' at time zone 'Egypt Standard Time' as PaidAtCairo
from [finance].[Payments] 
where cast(PaidAtUtc at time zone 'UTC' at time zone 'Egypt Standard Time' as time) >= '00:00:00'
AND cast(PaidAtUtc at time zone 'UTC' at time zone 'Egypt Standard Time' as time) < '05:00:00'

-- 5.10
set datefirst 7
select * 
from [attendance].[AttendanceSessions]
where DATEPART(weekday, SessionDate) = 6

-- 5.11
select * 
from [identity].[Users]
where PhoneNumber like N'+201[0125]' + replicate(N'[0-9]', 8)

-- 5.12
select LEFT(PhoneNumber, 2) + REPLICATE('*', LEN(PhoneNumber) - 6) + RIGHT(PhoneNumber, 3)
from [identity].[Users]

-- 5.13
select InvoiceNumber, 
	TRY_CAST(right(InvoiceNumber, charindex('-', reverse(InvoiceNumber)) - 1) as int) as RunningNumber 
from [finance].[Invoices]

-- 5.14
select CAST(EstimatedMinutes/60 as varchar(10)) + 'h' + CAST(EstimatedMinutes % 60 as varchar(10)) + 'min'
from [content].[Lessons]

-- 5.15
select title
from [communication].[Announcements]
where title like '%[0-9][%]%'

-- 5.16
select top (5) with ties InvoiceNumber, TotalAmount
from [finance].[Invoices]
order by TotalAmount DESC

-- 5.17
select top (10) percent Id, Amount
from [finance].[Payments]
order by Amount DESC

-- 5.18
select Id, Location
from [delivery].[Sections]
where Location <> N'Hall A'
or Location is null

-- 5.19
select InvoiceNumber, TotalAmount, PaidAmount,
		case
		when PaidAmount = 0 then N'Not Paid'
		when PaidAmount > 0 then N'Partially Paid'
		end as PaymentStatus,
		case
		when GETUTCDATE() > DueAtUtc then N'Payment Overdue'
		when GETUTCDATE() < DueAtUtc then N'Payment Window Open'
		end as PaymentDeadline,
		cast(round((PaidAmount / nullif(TotalAmount, 0) * 100), 1) as decimal (5,1)) as PaymentPercentage,
		(TotalAmount - PaidAmount) as AmountLeft
from [finance].[Invoices]
where TotalAmount > PaidAmount
order by AmountLeft DESC

-- 5.20
select Id, FirstName, LastName
from [identity].[Users]
order by CreatedAtUtc DESC, Id DESC
offset 40 rows
fetch next 20 rows only

-- 5.21
select Top (50) Id
From [operations].[AuditLogs]
where Id > 200
Order by Id

-- 5.22
select top (10) Id, Amount 
from [finance].[Payments]
order by PaidAtUtc DESC, Id DESC

-- 5.23
select top (10) UPPER(TRIM(Title)) as LessonTitle,
LEN(UPPER(TRIM(Title))) as TitleLength,
CASE 
WHEN max(EstimatedMinutes) is Null then N'Not Set'
WHEN max(EstimatedMinutes) <= 15 then N'Quick'
WHEN max(EstimatedMinutes) <= 45 then N'Standard'
ELSE N'Long'
END AS CategoryDuration
from [content].[Lessons]
where IsPublished = 1 
and len(trim(Title)) > 40
group by UPPER(TRIM(Title))
order by TitleLength DESC, LessonTitle ASC

-- 5.24
select distinct top (12)
		InvoiceNumber, DueAtUtc, TotalAmount, PaidAmount, CurrencyCode,
		case
		when PaidAmount = 0 then N'Not Paid'
		else N'Partially Paid'
		end as PaymentStatus,
		Concat(YEAR(DueAtUtc),'-', MONTH(DueAtUtc)) as DueMonth
from [finance].[Invoices]
where TotalAmount > PaidAmount
and GETUTCDATE() > DueAtUtc
order by DueMonth DESC, CurrencyCode ASC, PaymentStatus ASC
