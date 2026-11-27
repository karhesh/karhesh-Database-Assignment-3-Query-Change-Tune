-- 3.1

CREATE SEQUENCE [finance].[InvoiceSequenceDemo]
    AS bigint
    START WITH 1
    INCREMENT BY 1
    NO CYCLE;

select
    concat('LAB-INV-',year(SYSUTCDATETIME()), '-', format(next value for [finance].[InvoiceSequenceDemo], '000000'))
    as InvoiceNumber

--3.2
insert into [finance].[Invoices] (InvoiceNumber, StudentId, TermId, TotalAmount, DueAtUtc)
values (concat('LAB-INV-',year(SYSUTCDATETIME()), '-', format(next value for [finance].[InvoiceSequenceDemo], '000000')),
        1,
        1,
        4500,
        dateadd(day, 30, SYSUTCDATETIME()))

-- 3.3
begin transaction;
select next value for [finance].[InvoiceSequenceDemo] as beforeRoll;
rollback transaction;
select next value for [finance].[InvoiceSequenceDemo] as afterRoll;


 

