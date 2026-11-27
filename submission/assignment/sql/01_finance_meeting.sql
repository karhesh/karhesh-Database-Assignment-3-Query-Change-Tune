-- 1.1
select [StudentId],
	[TotalAmount],
	[PaidAmount],
	(TotalAmount - PaidAmount) as AmountLeft,
	DATEDIFF(Day, DueAtUtc, GETUTCDATE()) as DateDifference,
	DueAtUtc,
	-- 1.2
	case
	when GETUTCDATE() > dateadd(MONTH, 2, DueAtUtc) or (TotalAmount - PaidAmount) > 10000 then N'Urgent'
	when GETUTCDATE() > dateadd(MONTH, 1, DueAtUtc) then N'Medium'
	else N'Low'
	end as UrgencyLevel
into #LateInvoices
from [finance].[Invoices]
where (TotalAmount - PaidAmount) > 0
and DueAtUtc < CAST(GETUTCDATE() as Date)



-- 1.3
Select *
From #LateInvoices
	order by 
	Case UrgencyLevel
	when 'Urgent' then 1
	when 'Medium' then 2
	else 3
	End ASC,
	AmountLeft DESC

