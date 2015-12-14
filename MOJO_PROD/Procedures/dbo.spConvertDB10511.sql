USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10511]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10511]

AS

Update tActivity Set DateCompleted = NULL Where Completed = 0 and DateCompleted is not null


--Eastern
UPDATE	tTask
SET		EventStart = DATEADD(hh, -5, EventStart),
		EventEnd = DATEADD(hh, -5, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) < 3 AND MONTH(EventStart) > 10
AND		TimeZoneIndex = 35
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

UPDATE	tTask
SET		EventStart = DATEADD(hh, -4, EventStart),
		EventEnd = DATEADD(hh, -4, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) BETWEEN 3 AND 10
AND		TimeZoneIndex = 35
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

--Central
UPDATE	tTask
SET		EventStart = DATEADD(hh, -6, EventStart),
		EventEnd = DATEADD(hh, -6, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) < 3 AND MONTH(EventStart) > 10
AND		TimeZoneIndex = 20
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

UPDATE	tTask
SET		EventStart = DATEADD(hh, -5, EventStart),
		EventEnd = DATEADD(hh, -5, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) BETWEEN 3 AND 10
AND		TimeZoneIndex = 20
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

--Mountain
UPDATE	tTask
SET		EventStart = DATEADD(hh, -7, EventStart),
		EventEnd = DATEADD(hh, -7, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) < 3 AND MONTH(EventStart) > 10
AND		TimeZoneIndex = 10
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

UPDATE	tTask
SET		EventStart = DATEADD(hh, -6, EventStart),
		EventEnd = DATEADD(hh, -6, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) BETWEEN 3 AND 10
AND		TimeZoneIndex = 10
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

--Pacific
UPDATE	tTask
SET		EventStart = DATEADD(hh, -8, EventStart),
		EventEnd = DATEADD(hh, -8, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) < 3 AND MONTH(EventStart) > 10
AND		TimeZoneIndex = 4
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

UPDATE	tTask
SET		EventStart = DATEADD(hh, -7, EventStart),
		EventEnd = DATEADD(hh, -7, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) BETWEEN 3 AND 10
AND		TimeZoneIndex = 4
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

--Alaska
UPDATE	tTask
SET		EventStart = DATEADD(hh, -9, EventStart),
		EventEnd = DATEADD(hh, -9, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) < 3 AND MONTH(EventStart) > 10
AND		TimeZoneIndex = 3
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

UPDATE	tTask
SET		EventStart = DATEADD(hh, -8, EventStart),
		EventEnd = DATEADD(hh, -8, EventEnd),
		TimeZoneConverted = 1
WHERE	MONTH(EventStart) BETWEEN 3 AND 10
AND		TimeZoneIndex = 3
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

--Hawaii
UPDATE	tTask
SET		EventStart = DATEADD(hh, -10, EventStart),
		EventEnd = DATEADD(hh, -10, EventEnd),
		TimeZoneConverted = 1
WHERE	TimeZoneIndex = 2
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

--Indiana
UPDATE	tTask
SET		EventStart = DATEADD(hh, -5, EventStart),
		EventEnd = DATEADD(hh, -5, EventEnd),
		TimeZoneConverted = 1
WHERE	TimeZoneIndex = 40
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0

--Arizona
UPDATE	tTask
SET		EventStart = DATEADD(hh, -7, EventStart),
		EventEnd = DATEADD(hh, -7, EventEnd),
		TimeZoneConverted = 1
WHERE	TimeZoneIndex = 15
AND		EventStart >= '1/1/2009'
AND		ISNULL(TimeZoneConverted, 0) = 0


update tMarketingListList
set DateAdded = CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101))


-- Taxes on Vouchers
declare @VoucherKey int
select @VoucherKey = -1
while (1=1)
begin
	select @VoucherKey = min(VoucherKey)
    from tVoucher (nolock)
    where VoucherKey > @VoucherKey

	if @VoucherKey is null
		break

	exec sptVoucherRecalcAmountsConversion @VoucherKey
 
end

update tVoucherDetail set SalesTaxAmount = isnull(SalesTax1Amount, 0) + isnull(SalesTax2Amount, 0) 
update tVoucher set SalesTaxAmount = isnull(SalesTax1Amount, 0) + isnull(SalesTax2Amount, 0) 



-- Taxes on Invoices
insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
select i.InvoiceKey, il.InvoiceLineKey, i.SalesTaxKey, 1, isnull(il.SalesTax1Amount, 0)
from   tInvoice i (nolock)
inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
where isnull(i.ParentInvoiceKey, 0) = 0 -- not a child
and   isnull(i.ParentInvoice, 0) = 0 -- not a parent
and   isnull(i.SalesTaxKey, 0) >0
and   il.Taxable = 1
--and   il.SalesTax1Amount <> 0

insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
select i.InvoiceKey, il.InvoiceLineKey, i.SalesTax2Key, 2, isnull(il.SalesTax2Amount, 0)
from   tInvoice i (nolock)
inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
where isnull(i.ParentInvoiceKey, 0) = 0 -- not a child
and   isnull(i.ParentInvoice, 0) = 0 -- not a parent
and   isnull(i.SalesTax2Key, 0) >0
and   il.Taxable2 = 1
--and   il.SalesTax2Amount <> 0

insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
select i.InvoiceKey, ilt.InvoiceLineKey, ilt.SalesTaxKey, 3, isnull(ilt.SalesTaxAmount, 0)
from   tInvoice i (nolock)
inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
inner join tInvoiceLineTax ilt (nolock) on il.InvoiceLineKey = ilt.InvoiceLineKey
where isnull(i.ParentInvoiceKey, 0) = 0 -- not a child
and   isnull(i.ParentInvoice, 0) = 0 -- not a parent
--and   ilt.SalesTaxAmount <> 0



declare @InvoiceKey int
select @InvoiceKey = -1
while (1=1)
begin
	select @InvoiceKey = min(InvoiceKey)
    from tInvoice (nolock)
    where InvoiceKey > @InvoiceKey
	and  isnull(ParentInvoiceKey, 0) > 0 -- must be a child
	and   isnull(ParentInvoice, 0) = 0 -- not a parent

	if @InvoiceKey is null
		break

	exec sptInvoiceRecalcAmountsConversion @InvoiceKey
 
end


-- Fix ownership data. Bug with exchange
SELECT	ca.CalendarAttendeeKey, ca.CalendarKey, ca.EntityKey, c.UserKey, cul.[Subject]
INTO	#Fix
FROM	tCalendarAttendee ca (NOLOCK) INNER JOIN tCMFolder c (NOLOCK) ON ca.CMFolderKey = c.CMFolderKey
					INNER JOIN tCalendarUpdateLog cul (NOLOCK) ON ca.CalendarKey = cul.CalendarKey
WHERE	ca.Entity = 'Organizer'
		AND ca.EntityKey <> c.UserKey
		AND cul.[Application] = 'Exchange'
		AND cul.[Action] = 'I'

UPDATE	ca
SET		ca.EntityKey = f.UserKey
FROM	tCalendarAttendee ca, #Fix f 
WHERE	ca.CalendarAttendeeKey = f.CalendarAttendeeKey
GO
