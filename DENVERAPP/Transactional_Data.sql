USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'Transactional_Data'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[Transactional_Data]
GO

CREATE PROCEDURE [dbo].[Transactional_Data]     
     @iYear int = 2015
     
AS
/*******************************************************************************************************
*   DENVERAPP.dbo.Transactional_Data 
* 
*   Dev Contact:	Michelle Morales    
*
*   Notes:         
*                  
*
*   Usage:
        execute DENVERAPP.dbo.Transactional_Data 
        execute DENVERAPP.dbo.Transactional_Data @iyear = 2014
        
        set statistics io on 
        set statistics io off
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.#td') > 0 drop table #td
create table #td
(
	RptType varchar(40),
	[count] int,
	dMonth varchar(20),
	primary key clustered (RptType, dMonth)
)
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------

--*****************************  NUMBER 1 VENDORS *********************************
---- Get the Vendor Information
-- gets number of new vendors each month

insert #td
(
	RptType,
	[count],
	dMonth
)
select RptType = 'Vendors',
	[count] = COUNT(VendID),
	dMonth = CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
				WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
				WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
				WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
				WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
				WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
				WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
				WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
				WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
				WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
				WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
				WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
			END
from denverapp.dbo.Vendor 
where year(Crtd_DateTime) = @iYear
group by CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
				WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
				WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
				WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
				WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
				WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
				WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
				WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
				WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
				WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
				WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
				WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
			END

-- gets total active vendors at the end of 2012
--select COUNT (*) as 'Tot Active Vendors' from Vendor where Crtd_DateTime < '12/31/2012' and Status = 'A'

--*****************************  NUMBER 2 VENDOR INVOICES *********************************
---- for vendor invoices I used the View for the "AP Invoice Count Report" this allowed me to pull just what I wanted

insert #td
(
	RptType,
	[count],
	dMonth
)
select distinct 'Vendor Invoices' RptType,
	[count] = count(InvcNbr),
	dMonth = CASE WHEN RIGHT(PerPost,2) = 01 THEN '1 - Jan'
				WHEN RIGHT(PerPost,2) = 02 THEN '2 - Feb'
				WHEN RIGHT(PerPost,2) = 03 THEN '3 - March'
				WHEN RIGHT(PerPost,2) = 04 THEN '4 - April'
				WHEN RIGHT(PerPost,2) = 05 THEN '5 - May'
				WHEN RIGHT(PerPost,2) = 06 THEN '6 - June'
				WHEN RIGHT(PerPost,2) = 07 THEN '7 - July'
				WHEN RIGHT(PerPost,2) = 08 THEN '8 - Aug'
				WHEN RIGHT(PerPost,2) = 09 THEN '9 - Sept'
				WHEN RIGHT(PerPost,2) = 10 THEN '10 - Oct'
				WHEN RIGHT(PerPost,2) = 11 THEN '11 - Nov'
				WHEN RIGHT(PerPost,2) = 12 THEN '12 - Dec'
			END
 from denverapp.dbo.xvr_AP200_Main
 where left(PerPost,4) = @iYear
 group by CASE WHEN RIGHT(PerPost,2) = 01 THEN '1 - Jan'
		WHEN RIGHT(PerPost,2) = 02 THEN '2 - Feb'
		WHEN RIGHT(PerPost,2) = 03 THEN '3 - March'
		WHEN RIGHT(PerPost,2) = 04 THEN '4 - April'
		WHEN RIGHT(PerPost,2) = 05 THEN '5 - May'
		WHEN RIGHT(PerPost,2) = 06 THEN '6 - June'
		WHEN RIGHT(PerPost,2) = 07 THEN '7 - July'
		WHEN RIGHT(PerPost,2) = 08 THEN '8 - Aug'
		WHEN RIGHT(PerPost,2) = 09 THEN '9 - Sept'
		WHEN RIGHT(PerPost,2) = 10 THEN '10 - Oct'
		WHEN RIGHT(PerPost,2) = 11 THEN '11 - Nov'
		WHEN RIGHT(PerPost,2) = 12 THEN '12 - Dec'
		END
 --order by a.dMonth
 
insert #td
(
	RptType,
	[count],
	dMonth
)
select distinct 'Vendor Media Invoices' RptType,
	[count] = count(InvcNbr),
	dMonth = CASE WHEN RIGHT(PerPost,2) = 01 THEN '1 - Jan'
					WHEN RIGHT(PerPost,2) = 02 THEN '2 - Feb'
					WHEN RIGHT(PerPost,2) = 03 THEN '3 - March'
					WHEN RIGHT(PerPost,2) = 04 THEN '4 - April'
					WHEN RIGHT(PerPost,2) = 05 THEN '5 - May'
					WHEN RIGHT(PerPost,2) = 06 THEN '6 - June'
					WHEN RIGHT(PerPost,2) = 07 THEN '7 - July'
					WHEN RIGHT(PerPost,2) = 08 THEN '8 - Aug'
					WHEN RIGHT(PerPost,2) = 09 THEN '9 - Sept'
					WHEN RIGHT(PerPost,2) = 10 THEN '10 - Oct'
					WHEN RIGHT(PerPost,2) = 11 THEN '11 - Nov'
					WHEN RIGHT(PerPost,2) = 12 THEN '12 - Dec'
				END
 from denverapp.dbo.xvr_AP200_Main 
 where LEFT(PerPost,4) = @iYear
	and PayGroup IN ('D-PRINT','D-SPOT')
 group by CASE WHEN RIGHT(PerPost,2) = 01 THEN '1 - Jan'
					WHEN RIGHT(PerPost,2) = 02 THEN '2 - Feb'
					WHEN RIGHT(PerPost,2) = 03 THEN '3 - March'
					WHEN RIGHT(PerPost,2) = 04 THEN '4 - April'
					WHEN RIGHT(PerPost,2) = 05 THEN '5 - May'
					WHEN RIGHT(PerPost,2) = 06 THEN '6 - June'
					WHEN RIGHT(PerPost,2) = 07 THEN '7 - July'
					WHEN RIGHT(PerPost,2) = 08 THEN '8 - Aug'
					WHEN RIGHT(PerPost,2) = 09 THEN '9 - Sept'
					WHEN RIGHT(PerPost,2) = 10 THEN '10 - Oct'
					WHEN RIGHT(PerPost,2) = 11 THEN '11 - Nov'
					WHEN RIGHT(PerPost,2) = 12 THEN '12 - Dec'
				END
 --order by a.dMonth


 
/*
---- GET INVOICE COUNT BY PERSON
select COUNT(DISTINCT a.InvcNbr) AS 'NUM', b.Crtd_User, e.emp_name from xvr_AP200_Main a inner join 
APDoc b on a.InvcNbr = b.InvcNbr and a.DocType = b.DocType left outer join 
PJEMPLOY e on b.Crtd_User = e.employee
where a.PerPost = '201201'
GROUP BY b.Crtd_User, e.emp_name
*/

--***********************************************************************************************
--*****************************  NUMBER 3 INVOICES PROCESSED FOR PAYMENTS *********************************
--***********************************************************************************************
insert #td
(
	RptType,
	[count],
	dMonth
)
-- All Invoices
select distinct 'Invoices' rptType,
	[count] = count(InvcNbr),
	dMonth = CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
 from denverapp.dbo.APDoc
 where YEAR(Crtd_DateTime) = @iYear
 group by CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END

insert #td
(
	RptType,
	[count],
	dMonth
) 
 -- Production Invoices
select distinct 'Production Invoices' rptType,
	[count] = count(InvcNbr),
	dMonth = CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
from denverapp.dbo.APDoc
where Acct in ('2045','2046','2047')
	and YEAR(Crtd_DateTime)  = @iYear
group by CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
 
insert #td
(
	RptType,
	[count],
	dMonth
) 
 -- Media Invoices
select distinct 'Media Invoices' rptType,
	[count] = count(InvcNbr),
	dMonth = CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
 from denverapp.dbo.APDoc
 where Acct in ('2005','2010')
	and YEAR(Crtd_DateTime) = @iYear
 group by CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END

 
insert #td
(
	RptType,
	[count],
	dMonth
) 
 -- Expense Reports
select distinct 'Expense Reports' rptType,
	[count] = count(RefNbr),
	dMonth = CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
from denverapp.dbo.APDoc
where InvcNbr like 'ER%'
	and YEAR(Crtd_DateTime) = @iYear
group by CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
 
--*****************************  NUMBER 4 AP CHECKS *********************************
insert #td
(
	RptType,
	[count],
	dMonth
) 
 -- All AP Checks
select distinct 'AP Checks' rptType,
	[count] = count(adj.AdjgRefNbr),
	dMonth = CASE WHEN MONTH(adj.AdjgDocDate) = 1 THEN '1 - Jan'
					WHEN MONTH(adj.AdjgDocDate) = 2 THEN '2 - Feb'
					WHEN MONTH(adj.AdjgDocDate) = 3 THEN '3 - March'
					WHEN MONTH(adj.AdjgDocDate) = 4 THEN '4 - April'
					WHEN MONTH(adj.AdjgDocDate) = 5 THEN '5 - May'
					WHEN MONTH(adj.AdjgDocDate) = 6 THEN '6 - June'
					WHEN MONTH(adj.AdjgDocDate) = 7 THEN '7 - July'
					WHEN MONTH(adj.AdjgDocDate) = 8 THEN '8 - Aug'
					WHEN MONTH(adj.AdjgDocDate) = 9 THEN '9 - Sept'
					WHEN MONTH(adj.AdjgDocDate) = 10 THEN '10 - Oct'
					WHEN MONTH(adj.AdjgDocDate) = 11 THEN '11 - Nov'
					WHEN MONTH(adj.AdjgDocDate) = 12 THEN '12 - Dec'
				END
from denverapp.dbo.APDoc ap
inner join denverapp.dbo.APAdjust adj 
	on ap.RefNbr = adj.AdjdRefNbr 
left join (select adj.AdjgRefNbr
			from denverapp.dbo.apdoc ap
			inner join denverapp.dbo.apAdjust adj
				on ap.RefNbr = adj.AdjdRefNbr 
			where ap.doctype in ('VO','VT')
				and adj.AdjgDocType = 'VC') exc
	on adj.AdjgRefNbr = exc.AdjgRefNbr	
where YEAR(ap.Crtd_DateTime) = @iYear
	and ap.doctype IN ('VO','VT')
	and adj.AdjgDocType = 'CK'
	and exc.AdjgRefNbr is null
 group by CASE WHEN MONTH(adj.AdjgDocDate) = 1 THEN '1 - Jan'
					WHEN MONTH(adj.AdjgDocDate) = 2 THEN '2 - Feb'
					WHEN MONTH(adj.AdjgDocDate) = 3 THEN '3 - March'
					WHEN MONTH(adj.AdjgDocDate) = 4 THEN '4 - April'
					WHEN MONTH(adj.AdjgDocDate) = 5 THEN '5 - May'
					WHEN MONTH(adj.AdjgDocDate) = 6 THEN '6 - June'
					WHEN MONTH(adj.AdjgDocDate) = 7 THEN '7 - July'
					WHEN MONTH(adj.AdjgDocDate) = 8 THEN '8 - Aug'
					WHEN MONTH(adj.AdjgDocDate) = 9 THEN '9 - Sept'
					WHEN MONTH(adj.AdjgDocDate) = 10 THEN '10 - Oct'
					WHEN MONTH(adj.AdjgDocDate) = 11 THEN '11 - Nov'
					WHEN MONTH(adj.AdjgDocDate) = 12 THEN '12 - Dec'
				END

 insert #td
(
	RptType,
	[count],
	dMonth
) 
 -- AP Media Checks
select distinct 'AP Media Checks' rptType,
	[count] = count(adj.AdjgRefNbr),
 	dMonth = CASE WHEN MONTH(adj.AdjgDocDate) = 1 THEN '1 - Jan'
					WHEN MONTH(adj.AdjgDocDate) = 2 THEN '2 - Feb'
					WHEN MONTH(adj.AdjgDocDate) = 3 THEN '3 - March'
					WHEN MONTH(adj.AdjgDocDate) = 4 THEN '4 - April'
					WHEN MONTH(adj.AdjgDocDate) = 5 THEN '5 - May'
					WHEN MONTH(adj.AdjgDocDate) = 6 THEN '6 - June'
					WHEN MONTH(adj.AdjgDocDate) = 7 THEN '7 - July'
					WHEN MONTH(adj.AdjgDocDate) = 8 THEN '8 - Aug'
					WHEN MONTH(adj.AdjgDocDate) = 9 THEN '9 - Sept'
					WHEN MONTH(adj.AdjgDocDate) = 10 THEN '10 - Oct'
					WHEN MONTH(adj.AdjgDocDate) = 11 THEN '11 - Nov'
					WHEN MONTH(adj.AdjgDocDate) = 12 THEN '12 - Dec'
				END				
from denverapp.dbo.APDoc ap
inner join denverapp.dbo.APAdjust adj 
	on ap.RefNbr = adj.AdjdRefNbr
left join (select adj.AdjgRefNbr
			from denverapp.dbo.APDoc ap
			left join denverapp.dbo.APAdjust adj 
				on ap.RefNbr = adj.AdjdRefNbr
			where ap.doctype IN ('VO','VT')
				and adj.AdjgDocType = 'VC') exc
	on adj.AdjgRefNbr = exc.AdjgRefNbr
where YEAR(ap.Crtd_DateTime) = @iYear
	and ap.doctype IN ('VO','VT') 
	and ap.Acct in ('2005','2010')  
	and adj.AdjgDocType = 'CK'
	and exc.AdjgRefNbr is null
 group by CASE WHEN MONTH(adj.AdjgDocDate) = 1 THEN '1 - Jan'
					WHEN MONTH(adj.AdjgDocDate) = 2 THEN '2 - Feb'
					WHEN MONTH(adj.AdjgDocDate) = 3 THEN '3 - March'
					WHEN MONTH(adj.AdjgDocDate) = 4 THEN '4 - April'
					WHEN MONTH(adj.AdjgDocDate) = 5 THEN '5 - May'
					WHEN MONTH(adj.AdjgDocDate) = 6 THEN '6 - June'
					WHEN MONTH(adj.AdjgDocDate) = 7 THEN '7 - July'
					WHEN MONTH(adj.AdjgDocDate) = 8 THEN '8 - Aug'
					WHEN MONTH(adj.AdjgDocDate) = 9 THEN '9 - Sept'
					WHEN MONTH(adj.AdjgDocDate) = 10 THEN '10 - Oct'
					WHEN MONTH(adj.AdjgDocDate) = 11 THEN '11 - Nov'
					WHEN MONTH(adj.AdjgDocDate) = 12 THEN '12 - Dec'
				END	
  --order by a.dMonth



--*****************************  NUMBER 5 POSITIVE PAY *********************************

-- I could not get this information because i do not have access to e-cash.

--*****************************  NUMBER 6 CLIENTS *********************************
 insert #td
(
	RptType,
	[count],
	dMonth
) 
-- Clients
select distinct 'Clients' RptType,
	[count] = count(CustId),
	dMonth = CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
 from denverapp.dbo.Customer
 where YEAR(Crtd_DateTime) = @iYear
 group by CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END

--*****************************  NUMBER 7 PRODUCTION JOBS *********************************
 insert #td
(
	RptType,
	[count],
	dMonth
) 
-- New Jobs
select distinct 'New Jobs' RptType,
	[count] = count(project),
	dMonth = CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
 from denverapp.dbo.PJPROJ
 where YEAR(Crtd_DateTime) = @iYear
 group by CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END

 insert #td
(
	RptType,
	[count],
	dMonth
) 
-- Closed Jobs
select distinct 'Closed Jobs' RptType,
	[count] = count(project),
	dMonth = CASE WHEN MONTH(lupd_datetime) = 1 THEN '1 - Jan'
					WHEN MONTH(lupd_datetime) = 2 THEN '2 - Feb'
					WHEN MONTH(lupd_datetime) = 3 THEN '3 - March'
					WHEN MONTH(lupd_datetime) = 4 THEN '4 - April'
					WHEN MONTH(lupd_datetime) = 5 THEN '5 - May'
					WHEN MONTH(lupd_datetime) = 6 THEN '6 - June'
					WHEN MONTH(lupd_datetime) = 7 THEN '7 - July'
					WHEN MONTH(lupd_datetime) = 8 THEN '8 - Aug'
					WHEN MONTH(lupd_datetime) = 9 THEN '9 - Sept'
					WHEN MONTH(lupd_datetime) = 10 THEN '10 - Oct'
					WHEN MONTH(lupd_datetime) = 11 THEN '11 - Nov'
					WHEN MONTH(lupd_datetime) = 12 THEN '12 - Dec'
				END
 from denverapp.dbo.PJPROJ
 where YEAR(lupd_datetime) = @iYear
	and coalesce(status_pa,'') = 'I' 
	and coalesce(lupd_datetime,'') <> '' 
 group by CASE WHEN MONTH(lupd_datetime) = 1 THEN '1 - Jan'
					WHEN MONTH(lupd_datetime) = 2 THEN '2 - Feb'
					WHEN MONTH(lupd_datetime) = 3 THEN '3 - March'
					WHEN MONTH(lupd_datetime) = 4 THEN '4 - April'
					WHEN MONTH(lupd_datetime) = 5 THEN '5 - May'
					WHEN MONTH(lupd_datetime) = 6 THEN '6 - June'
					WHEN MONTH(lupd_datetime) = 7 THEN '7 - July'
					WHEN MONTH(lupd_datetime) = 8 THEN '8 - Aug'
					WHEN MONTH(lupd_datetime) = 9 THEN '9 - Sept'
					WHEN MONTH(lupd_datetime) = 10 THEN '10 - Oct'
					WHEN MONTH(lupd_datetime) = 11 THEN '11 - Nov'
					WHEN MONTH(lupd_datetime) = 12 THEN '12 - Dec'
				END

--*****************************  NUMBER 8 AR - CLIENT INVOICES *********************************
 insert #td
(
	RptType,
	[count],
	dMonth
) 
-- All Client Invoices
select distinct 'Client Invoices' RptType,
	[count] = count(inv.invoice_num),
	dMonth = CASE WHEN MONTH(inv.Invoice_Date) = 1 THEN '1 - Jan'
					WHEN MONTH(inv.Invoice_Date) = 2 THEN '2 - Feb'
					WHEN MONTH(inv.Invoice_Date) = 3 THEN '3 - March'
					WHEN MONTH(inv.Invoice_Date) = 4 THEN '4 - April'
					WHEN MONTH(inv.Invoice_Date) = 5 THEN '5 - May'
					WHEN MONTH(inv.Invoice_Date) = 6 THEN '6 - June'
					WHEN MONTH(inv.Invoice_Date) = 7 THEN '7 - July'
					WHEN MONTH(inv.Invoice_Date) = 8 THEN '8 - Aug'
					WHEN MONTH(inv.Invoice_Date) = 9 THEN '9 - Sept'
					WHEN MONTH(inv.Invoice_Date) = 10 THEN '10 - Oct'
					WHEN MONTH(inv.Invoice_Date) = 11 THEN '11 - Nov'
					WHEN MONTH(inv.Invoice_Date) = 12 THEN '12 - Dec'
				END
from denverapp.dbo.GLTran gl
left outer join denverapp.dbo.PJINVHDR inv
	on gl.BatNbr = inv.batch_id 
	and gl.RefNbr = inv.invoice_num 
left outer join denverapp.dbo.PJINVDET id
	on inv.draft_num = id.draft_num 
left outer join denverapp.dbo.PJPROJ p
	on id.project = p.project 
left outer join denverapp.dbo.PJCODE c
	on p.pm_id02 = c.code_value 
where YEAR(inv.Invoice_Date) = @iYear
	and gl.Module = 'BI' 
	and gl.JrnlType <> 'REV' 
	and c.code_type = 'BCYC'
 group by CASE WHEN MONTH(inv.Invoice_Date) = 1 THEN '1 - Jan'
					WHEN MONTH(inv.Invoice_Date) = 2 THEN '2 - Feb'
					WHEN MONTH(inv.Invoice_Date) = 3 THEN '3 - March'
					WHEN MONTH(inv.Invoice_Date) = 4 THEN '4 - April'
					WHEN MONTH(inv.Invoice_Date) = 5 THEN '5 - May'
					WHEN MONTH(inv.Invoice_Date) = 6 THEN '6 - June'
					WHEN MONTH(inv.Invoice_Date) = 7 THEN '7 - July'
					WHEN MONTH(inv.Invoice_Date) = 8 THEN '8 - Aug'
					WHEN MONTH(inv.Invoice_Date) = 9 THEN '9 - Sept'
					WHEN MONTH(inv.Invoice_Date) = 10 THEN '10 - Oct'
					WHEN MONTH(inv.Invoice_Date) = 11 THEN '11 - Nov'
					WHEN MONTH(inv.Invoice_Date) = 12 THEN '12 - Dec'
				END



	
insert #td
(
	RptType,
	[count],
	dMonth
) 
-- Production Client Invoices
select distinct 'Client Production Invoices' RptType,
	[count] = count(inv.invoice_num ),
	dMonth = CASE WHEN MONTH(inv.Invoice_Date) = 1 THEN '1 - Jan'
					WHEN MONTH(inv.Invoice_Date) = 2 THEN '2 - Feb'
					WHEN MONTH(inv.Invoice_Date) = 3 THEN '3 - March'
					WHEN MONTH(inv.Invoice_Date) = 4 THEN '4 - April'
					WHEN MONTH(inv.Invoice_Date) = 5 THEN '5 - May'
					WHEN MONTH(inv.Invoice_Date) = 6 THEN '6 - June'
					WHEN MONTH(inv.Invoice_Date) = 7 THEN '7 - July'
					WHEN MONTH(inv.Invoice_Date) = 8 THEN '8 - Aug'
					WHEN MONTH(inv.Invoice_Date) = 9 THEN '9 - Sept'
					WHEN MONTH(inv.Invoice_Date) = 10 THEN '10 - Oct'
					WHEN MONTH(inv.Invoice_Date) = 11 THEN '11 - Nov'
					WHEN MONTH(inv.Invoice_Date) = 12 THEN '12 - Dec'
				END
FROM denverapp.dbo.GLTran gl
LEFT OUTER JOIN denverapp.dbo.PJINVHDR inv
	ON gl.BatNbr = inv.batch_id 
	AND gl.RefNbr = inv.invoice_num 
LEFT OUTER JOIN denverapp.dbo.PJINVDET id
	ON inv.draft_num = id.draft_num 
LEFT OUTER JOIN denverapp.dbo.PJPROJ p
	ON id.project = p.project 
LEFT OUTER JOIN denverapp.dbo.PJCODE c
	ON p.pm_id02 = c.code_value 
LEFT OUTER JOIN denverapp.dbo.PJPROJ b 
	ON gl.ProjectID = b.project 
where YEAR(inv.invoice_date) = @iYear
	and b.contract_type IN ('PARN','PDNT','PRNT','PROD') 
	and gl.Module = 'BI' 
	and gl.JrnlType <> 'REV' 
	and c.code_type = 'BCYC'
group by CASE WHEN MONTH(inv.Invoice_Date) = 1 THEN '1 - Jan'
					WHEN MONTH(inv.Invoice_Date) = 2 THEN '2 - Feb'
					WHEN MONTH(inv.Invoice_Date) = 3 THEN '3 - March'
					WHEN MONTH(inv.Invoice_Date) = 4 THEN '4 - April'
					WHEN MONTH(inv.Invoice_Date) = 5 THEN '5 - May'
					WHEN MONTH(inv.Invoice_Date) = 6 THEN '6 - June'
					WHEN MONTH(inv.Invoice_Date) = 7 THEN '7 - July'
					WHEN MONTH(inv.Invoice_Date) = 8 THEN '8 - Aug'
					WHEN MONTH(inv.Invoice_Date) = 9 THEN '9 - Sept'
					WHEN MONTH(inv.Invoice_Date) = 10 THEN '10 - Oct'
					WHEN MONTH(inv.Invoice_Date) = 11 THEN '11 - Nov'
					WHEN MONTH(inv.Invoice_Date) = 12 THEN '12 - Dec'
				END




insert #td
(
	RptType,
	[count],
	dMonth
) 
-- Media Client Invoices
select distinct 'Client Media Invoices' RptType,
	[count] = count(inv.invoice_num ),
	dMonth = CASE WHEN MONTH(inv.Invoice_Date) = 1 THEN '1 - Jan'
					WHEN MONTH(inv.Invoice_Date) = 2 THEN '2 - Feb'
					WHEN MONTH(inv.Invoice_Date) = 3 THEN '3 - March'
					WHEN MONTH(inv.Invoice_Date) = 4 THEN '4 - April'
					WHEN MONTH(inv.Invoice_Date) = 5 THEN '5 - May'
					WHEN MONTH(inv.Invoice_Date) = 6 THEN '6 - June'
					WHEN MONTH(inv.Invoice_Date) = 7 THEN '7 - July'
					WHEN MONTH(inv.Invoice_Date) = 8 THEN '8 - Aug'
					WHEN MONTH(inv.Invoice_Date) = 9 THEN '9 - Sept'
					WHEN MONTH(inv.Invoice_Date) = 10 THEN '10 - Oct'
					WHEN MONTH(inv.Invoice_Date) = 11 THEN '11 - Nov'
					WHEN MONTH(inv.Invoice_Date) = 12 THEN '12 - Dec'
				END
FROM denverapp.dbo.GLTran gl
LEFT OUTER JOIN denverapp.dbo.PJINVHDR inv
	ON gl.BatNbr = inv.batch_id 
	AND gl.RefNbr = inv.invoice_num 
LEFT OUTER JOIN denverapp.dbo.PJINVDET id
	ON inv.draft_num = id.draft_num 
LEFT OUTER JOIN denverapp.dbo.PJPROJ p
	ON id.project = p.project 
LEFT OUTER JOIN denverapp.dbo.PJCODE c
	ON p.pm_id02 = c.code_value 
LEFT OUTER JOIN denverapp.dbo.PJPROJ b 
	ON gl.ProjectID = b.project 
where YEAR(inv.Invoice_Date) = @iYear
	and b.contract_type IN ('MED','BPRD')
	and gl.Module = 'BI' 
	and gl.JrnlType <> 'REV' 
	and c.code_type = 'BCYC'
group by CASE WHEN MONTH(inv.Invoice_Date) = 1 THEN '1 - Jan'
					WHEN MONTH(inv.Invoice_Date) = 2 THEN '2 - Feb'
					WHEN MONTH(inv.Invoice_Date) = 3 THEN '3 - March'
					WHEN MONTH(inv.Invoice_Date) = 4 THEN '4 - April'
					WHEN MONTH(inv.Invoice_Date) = 5 THEN '5 - May'
					WHEN MONTH(inv.Invoice_Date) = 6 THEN '6 - June'
					WHEN MONTH(inv.Invoice_Date) = 7 THEN '7 - July'
					WHEN MONTH(inv.Invoice_Date) = 8 THEN '8 - Aug'
					WHEN MONTH(inv.Invoice_Date) = 9 THEN '9 - Sept'
					WHEN MONTH(inv.Invoice_Date) = 10 THEN '10 - Oct'
					WHEN MONTH(inv.Invoice_Date) = 11 THEN '11 - Nov'
					WHEN MONTH(inv.Invoice_Date) = 12 THEN '12 - Dec'
				END
		
--*****************************  NUMBER 9 AR - CLIENT STATEMENTS *********************************

--- Get this by talking to AR to see if they send anything out.  They generally do not.

--***********************************************************************************************
--*****************************  NUMBER 10 TIMESHEETS ENTERED *********************************
--***********************************************************************************************
/*
-- get each month
select
(select (a.intcmpy + b1.APS) as JAN from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201201')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '1/1/2012' and '1/31/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '1/1/2012' and '1/31/2012')b)b1) as JAN
, (select (a.intcmpy + b1.APS) as FEB from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201202')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '2/1/2012' and '2/28/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '2/1/2012' and '2/28/2012')b)b1) as FEB
, (select (a.intcmpy + b1.APS) as MAR from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201203')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '3/1/2012' and '3/31/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '3/1/2012' and '3/31/2012')b)b1) as MAR
, (select (a.intcmpy + b1.APS) as APR from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201204')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '4/1/2012' and '4/30/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '4/1/2012' and '4/30/2012')b)b1) as APR
, (select (a.intcmpy + b1.APS) as MAY from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201205')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '5/1/2012' and '5/31/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '5/1/2012' and '5/31/2012')b)b1) as MAY
, (select (a.intcmpy + b1.APS) as JUN from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201206')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '6/1/2012' and '6/30/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '6/1/2012' and '6/30/2012')b)b1) as JUN
, (select (a.intcmpy + b1.APS) as JUL from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201207')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '7/1/2012' and '7/31/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '7/1/2012' and '7/31/2012')b)b1) as JUL
, (select (a.intcmpy + b1.APS) as AUG from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201208')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '8/1/2012' and '8/31/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '8/1/2012' and '8/31/2012')b)b1) as AUG
, (select (a.intcmpy + b1.APS) as SEP from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201209')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '9/1/2012' and '9/30/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '9/1/2012' and '9/30/2012')b)b1) as SEP
, (select (a.intcmpy + b1.APS) as OCT from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201210')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '10/1/2012' and '10/31/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '10/1/2012' and '10/31/2012')b)b1) as OCT
, (select (a.intcmpy + b1.APS) as NOV from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201211')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '11/1/2012' and '11/30/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '11/1/2012' and '11/30/2012')b)b1) as NOV
, (select (a.intcmpy + b1.APS) as DEC from 
(select COUNT (*) as intcmpy from PJLABHDR where period_num = '201210')a,
(select (a1.wk * b.emp) as APS from
	(select count (distinct a.Period_End_Date) as wk from
		(select CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
			THEN PJTIMDET.tl_date END as 'Period_End_Date', * from PJTIMDET where tl_date between '12/1/2012' and '12/31/2012')a)a1 ,
	(select count (distinct employee) as emp from PJTIMDET where tl_date between '12/1/2012' and '12/31/2012')b)b1) as DEC
	
	
 --***********************
 UNION ALL
  --***********************

*/

--*****************************  NUMBER 11 JOURNAL ENTRIES *********************************
insert #td
(
	RptType,
	[count],
	dMonth
) 
select distinct 'Journal Entries' RptType,
	[count] = count(batnbr),
	dMonth = CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END
 from denverapp.dbo.GLTran
 where YEAR(Crtd_DateTime) = @iYear
	and module IN ('GL') 
	and LedgerID IN ('ACTUAL','STAT')
 group by CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
					WHEN MONTH(Crtd_DateTime) = 2 THEN '2 - Feb'
					WHEN MONTH(Crtd_DateTime) = 3 THEN '3 - March'
					WHEN MONTH(Crtd_DateTime) = 4 THEN '4 - April'
					WHEN MONTH(Crtd_DateTime) = 5 THEN '5 - May'
					WHEN MONTH(Crtd_DateTime) = 6 THEN '6 - June'
					WHEN MONTH(Crtd_DateTime) = 7 THEN '7 - July'
					WHEN MONTH(Crtd_DateTime) = 8 THEN '8 - Aug'
					WHEN MONTH(Crtd_DateTime) = 9 THEN '9 - Sept'
					WHEN MONTH(Crtd_DateTime) = 10 THEN '10 - Oct'
					WHEN MONTH(Crtd_DateTime) = 11 THEN '11 - Nov'
					WHEN MONTH(Crtd_DateTime) = 12 THEN '12 - Dec'
				END


--*****************************  NUMBER 12 EXPENSE REPORTS *********************************


select RptType,
	[count],
	dMonth
from #td
order by dmonth

-- execute denverapp.dbo.Transactional_Data


RETURN
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

---------------------------------------------
-- permissions
---------------------------------------------