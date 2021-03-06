USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Mod12ExploringDatascope]    Script Date: 12/21/2015 15:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Mod12ExploringDatascope]     
     @iYear int = 2015
     
AS
/*******************************************************************************************************
*   DENVERAPP.dbo.Transaction_Data 
* 
*   Dev Contact:	Michelle Morales
     
*
*   Notes:         
*                  
*
*   Usage:
        execute DENVERAPP.dbo.Transaction_Data 
        
        set statistics io on 
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/


---------------------------------------------
-- create temp tables
---------------------------------------------
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select a.* from
--***********************************************************************************************
--*****************************  NUMBER 1 VENDORS *********************************
--***********************************************************************************************
(
---- Get the Vendor Information
-- gets number of new vendors each month
select 'Vendors' as 'RptType'
,COUNT(a.VendID) as 'count'
, a.dMonth
from
(select VendId
, CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
 from Vendor)a
 where a.dYear = @iYear
 group by a.dMonth
-- order by a.dMonth
 
-- gets total active vendors at the end of 2012
--select COUNT (*) as 'Tot Active Vendors' from Vendor where Crtd_DateTime < '12/31/2012' and Status = 'A'

 --***********************
 UNION ALL
  --***********************

--***********************************************************************************************
--*****************************  NUMBER 2 VENDOR INVOICES *********************************
--***********************************************************************************************
---- for vendor invoices I used the View for the "AP Invoice Count Report" this allowed me to pull just what I wanted
select 'Vendor Invoices' as 'RptType'
,COUNT(a.InvcNbr) as 'count'
, a.dMonth
from
(select distinct InvcNbr
, CASE WHEN RIGHT(PerPost,2) = 01 THEN '1 - Jan'
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
		END as 'dMonth'
, LEFT(PerPost,4) as 'dYear'
 from xvr_AP200_Main)a
 where a.dYear = @iYear
 group by a.dMonth
 --order by a.dMonth
 
 --***********************
 UNION ALL
  --***********************
 
-- get only media invoices
select 'Vendor Media Invoices' as 'RptType'
, COUNT(a.InvcNbr) as 'count'
, a.dMonth
from
(select distinct InvcNbr
, CASE WHEN RIGHT(PerPost,2) = 01 THEN '1 - Jan'
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
		END as 'dMonth'
, LEFT(PerPost,4) as 'dYear'
 from xvr_AP200_Main 
 where PayGroup IN ('D-PRINT','D-SPOT'))a
 where a.dYear = @iYear
 group by a.dMonth
 --order by a.dMonth

/*
---- GET INVOICE COUNT BY PERSON
select COUNT(DISTINCT a.InvcNbr) AS 'NUM', b.Crtd_User, e.emp_name from xvr_AP200_Main a inner join 
APDoc b on a.InvcNbr = b.InvcNbr and a.DocType = b.DocType left outer join 
PJEMPLOY e on b.Crtd_User = e.employee
where a.PerPost = '201201'
GROUP BY b.Crtd_User, e.emp_name
*/

 --***********************
 UNION ALL
  --***********************

--***********************************************************************************************
--*****************************  NUMBER 3 INVOICES PROCESSED FOR PAYMENTS *********************************
--***********************************************************************************************

-- All Invoices
select 'Invoices' as 'rptType'
, COUNT(a.InvcNbr) as 'Count'
, a.dMonth
from
(select distinct InvcNbr
, CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
 from APDoc)a
 where a.dYear = @iYear
 group by a.dMonth
 --order by a.dMonth
 
  --***********************
 UNION ALL
  --***********************
 
 -- Production Invoices
 select 'Production Invoices' as 'rptType'
, COUNT(a.InvcNbr) as 'Count'
, a.dMonth
from
(select distinct InvcNbr
, CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
 from APDoc
 where Acct in ('2045','2046','2047'))a
 where a.dYear = @iYear
 group by a.dMonth
 --order by a.dMonth
 
   --***********************
 UNION ALL
  --***********************
 
 -- Media Invoices
 select 'Media Invoices' as 'rptType'
, COUNT(a.InvcNbr) as 'Count'
, a.dMonth
from
(select distinct InvcNbr
, CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
 from APDoc
 where Acct in ('2005','2010'))a
 where a.dYear = @iYear
 group by a.dMonth
 --order by a.dMonth
 
  --***********************
 UNION ALL
  --***********************
 
 -- Expense Reports
 select 'Expense Reports' as 'rptType'
, COUNT(a.RefNbr) as 'Count'
, a.dMonth
from
(select distinct RefNbr
, CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
 from APDoc
 where InvcNbr like 'ER%')a
 where a.dYear = @iYear
 group by a.dMonth
 --order by a.dMonth
 
 
     --***********************
 UNION ALL
  --***********************

 --***********************************************************************************************
--*****************************  NUMBER 4 AP CHECKS *********************************
--***********************************************************************************************

 -- All AP Checks
 select 'AP Checks' as 'rptType'
, COUNT(a.AdjgRefNbr) as 'Count'
, a.dMonth
from
(select distinct adj.AdjgRefNbr
 , CASE WHEN MONTH(adj.AdjgDocDate) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
	--adj.AdjgRefNbr , adj.AdjdRefNbr, ap.InvcNbr, ap.VendId, ap.DocDate, ap.CuryOrigDocAmt, adj.AdjgDocType, adj.AdjgDocDate
			from
			(select RefNbr, doctype, InvcNbr, vendid, DocDate, CuryOrigDocAmt from APDoc where doctype IN ('VO','VT'))ap,  
				APAdjust adj 
			where ap.RefNbr = adj.AdjdRefNbr 
			AND adj.AdjgDocType = 'CK'
			AND adj.AdjgRefNbr NOT IN (select adj.AdjgRefNbr from 
				(select RefNbr from APDoc where doctype IN ('VO','VT'))ap,  
				APAdjust adj 
				where ap.RefNbr = adj.AdjdRefNbr 
				AND adj.AdjgDocType = 'VC'))a
 where a.dYear = @iYear
 group by a.dMonth
  --order by a.dMonth
 
   --***********************
 UNION ALL
  --***********************
 
 -- AP Media Checks
 select 'AP Media Checks' as 'rptType'
, COUNT(a.AdjgRefNbr) as 'Count'
, a.dMonth
from
(select distinct adj.AdjgRefNbr
 , CASE WHEN MONTH(adj.AdjgDocDate) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
	--adj.AdjgRefNbr , adj.AdjdRefNbr, ap.InvcNbr, ap.VendId, ap.DocDate, ap.CuryOrigDocAmt, adj.AdjgDocType, adj.AdjgDocDate
			from
			(select RefNbr, doctype, InvcNbr, vendid, DocDate, CuryOrigDocAmt from APDoc where doctype IN ('VO','VT') and Acct in ('2005','2010'))ap,  
				APAdjust adj 
			where ap.RefNbr = adj.AdjdRefNbr 
			AND adj.AdjgDocType = 'CK'
			AND adj.AdjgRefNbr NOT IN (select adj.AdjgRefNbr from 
				(select RefNbr from APDoc where doctype IN ('VO','VT'))ap,  
				APAdjust adj 
				where ap.RefNbr = adj.AdjdRefNbr 
				AND adj.AdjgDocType = 'VC'))a
 where a.dYear = @iYear
 group by a.dMonth
  --order by a.dMonth

  --***********************
 UNION ALL
  --***********************

--***********************************************************************************************
--*****************************  NUMBER 5 POSITIVE PAY *********************************
--***********************************************************************************************

-- I could not get this information because i do not have access to e-cash.

--***********************************************************************************************
--*****************************  NUMBER 6 CLIENTS *********************************
--***********************************************************************************************
-- Clients
select 'Clients' as 'RptType'
,COUNT(a.CustId) as 'count'
, a.dMonth
from
(select distinct CustId
, CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
 from Customer)a
 where a.dYear = @iYear
 group by a.dMonth
-- order by a.dMonth

  --***********************
 UNION ALL
  --***********************

--***********************************************************************************************
--*****************************  NUMBER 7 PRODUCTION JOBS *********************************
--***********************************************************************************************
-- New Jobs
select 'New Jobs' as 'RptType'
,COUNT(a.project) as 'count'
, a.dMonth
from
(select distinct project
, CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
 from PJPROJ)a
 where a.dYear = @iYear
 group by a.dMonth
-- order by a.dMonth

  --***********************
 UNION ALL
  --***********************

-- Closed Jobs
select 'Closed Jobs' as 'RptType'
,COUNT(a.project) as 'count'
, a.dMonth
from
(select distinct project
, CASE WHEN MONTH(lupd_datetime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(lupd_datetime) as 'dYear'
 from PJPROJ
 where status_pa = 'I' and lupd_datetime <> '')a
 where a.dYear = @iYear
 group by a.dMonth
-- order by a.dMonth


  --***********************
 UNION ALL
  --***********************

--***********************************************************************************************
--*****************************  NUMBER 8 AR - CLIENT INVOICES *********************************
--***********************************************************************************************
-- All Client Invoices
select 'Client Invoices' as 'RptType'
,COUNT(a.InvoiceNum) as 'count'
, a.dMonth
from
(select distinct InvoiceNum
, CASE WHEN MONTH(Invoice_Date) = 1 THEN '1 - Jan'
		WHEN MONTH(Invoice_Date) = 2 THEN '2 - Feb'
		WHEN MONTH(Invoice_Date) = 3 THEN '3 - March'
		WHEN MONTH(Invoice_Date) = 4 THEN '4 - April'
		WHEN MONTH(Invoice_Date) = 5 THEN '5 - May'
		WHEN MONTH(Invoice_Date) = 6 THEN '6 - June'
		WHEN MONTH(Invoice_Date) = 7 THEN '7 - July'
		WHEN MONTH(Invoice_Date) = 8 THEN '8 - Aug'
		WHEN MONTH(Invoice_Date) = 9 THEN '9 - Sept'
		WHEN MONTH(Invoice_Date) = 10 THEN '10 - Oct'
		WHEN MONTH(Invoice_Date) = 11 THEN '11 - Nov'
		WHEN MONTH(Invoice_Date) = 12 THEN '12 - Dec'
		END as 'dMonth'
, YEAR(Invoice_Date) as 'dYear'
 from xvr_BI421_Main)a
 where a.dYear = @iYear
 group by a.dMonth
-- order by a.dMonth

 --***********************
 UNION ALL
  --***********************

-- Production Client Invoices
select 'Client Production Invoices' as 'RptType'
,COUNT(a.InvoiceNum) as 'count'
, a.dMonth
from
(select distinct x.InvoiceNum
, CASE WHEN MONTH(x.Invoice_Date) = 1 THEN '1 - Jan'
		WHEN MONTH(x.Invoice_Date) = 2 THEN '2 - Feb'
		WHEN MONTH(x.Invoice_Date) = 3 THEN '3 - March'
		WHEN MONTH(x.Invoice_Date) = 4 THEN '4 - April'
		WHEN MONTH(x.Invoice_Date) = 5 THEN '5 - May'
		WHEN MONTH(x.Invoice_Date) = 6 THEN '6 - June'
		WHEN MONTH(x.Invoice_Date) = 7 THEN '7 - July'
		WHEN MONTH(x.Invoice_Date) = 8 THEN '8 - Aug'
		WHEN MONTH(x.Invoice_Date) = 9 THEN '9 - Sept'
		WHEN MONTH(x.Invoice_Date) = 10 THEN '10 - Oct'
		WHEN MONTH(x.Invoice_Date) = 11 THEN '11 - Nov'
		WHEN MONTH(x.Invoice_Date) = 12 THEN '12 - Dec'
		END as 'dMonth'
, YEAR(x.Invoice_Date) as 'dYear'
 from xvr_BI421_Main x LEFT OUTER JOIN PJPROJ b ON x.GLTranProjectID = b.project 
	where b.contract_type IN ('PARN','PDNT','PRNT','PROD'))a 
 where a.dYear = @iYear
 group by a.dMonth
-- order by a.dMonth

 --***********************
 UNION ALL
  --***********************

-- Media Client Invoices
select 'Client Media Invoices' as 'RptType'
,COUNT(a.InvoiceNum) as 'count'
, a.dMonth
from
(select distinct x.InvoiceNum
, CASE WHEN MONTH(x.Invoice_Date) = 1 THEN '1 - Jan'
		WHEN MONTH(x.Invoice_Date) = 2 THEN '2 - Feb'
		WHEN MONTH(x.Invoice_Date) = 3 THEN '3 - March'
		WHEN MONTH(x.Invoice_Date) = 4 THEN '4 - April'
		WHEN MONTH(x.Invoice_Date) = 5 THEN '5 - May'
		WHEN MONTH(x.Invoice_Date) = 6 THEN '6 - June'
		WHEN MONTH(x.Invoice_Date) = 7 THEN '7 - July'
		WHEN MONTH(x.Invoice_Date) = 8 THEN '8 - Aug'
		WHEN MONTH(x.Invoice_Date) = 9 THEN '9 - Sept'
		WHEN MONTH(x.Invoice_Date) = 10 THEN '10 - Oct'
		WHEN MONTH(x.Invoice_Date) = 11 THEN '11 - Nov'
		WHEN MONTH(x.Invoice_Date) = 12 THEN '12 - Dec'
		END as 'dMonth'
, YEAR(x.Invoice_Date) as 'dYear'
 from xvr_BI421_Main x LEFT OUTER JOIN PJPROJ b ON x.GLTranProjectID = b.project 
	where b.contract_type IN ('MED','BPRD'))a 
 where a.dYear = @iYear
 group by a.dMonth
-- order by a.dMonth
	
	
 --***********************
 UNION ALL
  --***********************
	
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

--***********************************************************************************************
--*****************************  NUMBER 11 JOURNAL ENTRIES *********************************
--***********************************************************************************************
select 'Journal Entries' as 'RptType'
,COUNT(a.batnbr) as 'count'
, a.dMonth
from
(select distinct batnbr
, CASE WHEN MONTH(Crtd_DateTime) = 1 THEN '1 - Jan'
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
		END as 'dMonth'
, YEAR(Crtd_DateTime) as 'dYear'
 from GLTran
 where module IN ('GL') and LedgerID IN ('ACTUAL','STAT'))a
 where a.dYear = @iYear
 group by a.dMonth
-- order by a.dMonth


--***********************************************************************************************
--*****************************  NUMBER 12 EXPENSE REPORTS *********************************
--***********************************************************************************************

)a 
order by a.dMonth


RETURN
GO
