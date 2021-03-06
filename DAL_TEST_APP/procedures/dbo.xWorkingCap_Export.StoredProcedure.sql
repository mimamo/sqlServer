USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xWorkingCap_Export]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================
-- Author:		David Martin
-- Create date: 3/19/2013
-- Description:	Stored Procedure for Working Capital Export
-- =========================================================
CREATE PROCEDURE [dbo].[xWorkingCap_Export]
	-- Add the parameters for the stored procedure here
	@Entity nchar(15),
	@Period nchar(6)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @PeriodEndDate datetime
	SET @PeriodEndDate = DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,CONVERT(datetime,LEFT(@Period,4)+'-'+RIGHT(@Period,2)+'-01'))+1,0));

	SELECT		LEFT(LTRIM(RTRIM(@Period)),4) AS 'Year',
				CASE RIGHT(LTRIM(RTRIM(@Period)),2)
					WHEN '01' THEN 'Jan'
					WHEN '02' THEN 'Feb'
					WHEN '03' THEN 'Mar'
					WHEN '04' THEN 'Apr'
					WHEN '05' THEN 'May'
					WHEN '06' THEN 'Jun'
					WHEN '07' THEN 'Jul'
					WHEN '08' THEN 'Aug'
					WHEN '09' THEN 'Sep'
					WHEN '10' THEN 'Oct'
					WHEN '11' THEN 'Nov'
					WHEN '12' THEN 'Dec'
					ELSE ' !!!!INVALID DATE!!!!!'
				END AS 'Month',
				LTRIM(RTRIM(@Entity)) AS 'Entity',
				X.[HyperionAcct] AS 'Hyperion',
				X.[Client] AS 'Client',
				SUM(X.[Value]) AS 'Value'
	FROM		(
					SELECT		CASE 
									WHEN LEN(LTRIM(RTRIM(XA.User1))) < 3 THEN '!!!!!HYPERION NOT SET!!!!!!'
									ELSE LTRIM(RTRIM(XA.User1))
								END AS 'Client'
								, XX.[HyperionAcct]
								, SUM(XX.[Value]) AS 'Value'
					FROM		(/******** WC GL BALANCES ********/
									/*Accrued Rev - Unbilled AR*/
									SELECT	'[None]' AS 'Client', 'WCAccrInc' AS 'HyperionAcct', 0 AS 'Value'
									UNION ALL
									/*WIP*/
									/*AR*/
									/*AP*/
									/*Accrued COS*/
									/*ClientAdvances - Prebill*/
									/*Input into AR*/
									/*Input into AP*/

								/******** BILLINGS (INVOICING/INPUT INTO AR BY CLIENT) ********/
								SELECT		A.CustId AS 'Client','CurMonAR' AS 'HyperionAcct', SUM(A.OrigDocAmt) AS 'Value'
								FROM		DallasApp.dbo.ARDoc A
								WHERE		A.PerPost = @Period AND A.DocType IN ('IN','RC','DM','CM','FI','CS','PP','NC','RF')
								GROUP BY	A.CustId
								UNION ALL

								/******** AR AGING BY CLIENT FROM INVOICE DATE ********/

									/*AR Aging - 0-30 Days*/
									SELECT		A.Customer AS 'Client','ARID' AS HyperionAcct, ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) AS 'Value'
									FROM		DallasApp.dbo.xWorkingCap_Invoices A LEFT OUTER JOIN DallasApp.dbo.xWorkingCap_Payments B ON B.InvoiceNum = A.InvoiceNum AND B.InvoiceType = A.InvoiceType AND (B.Period <= @Period OR B.Period IS NULL)
									WHERE		A.Period <= @Period AND A.InvoiceDate >= DATEADD(dd,-30,@PeriodEndDate)
									GROUP BY	A.Customer,A.InvoiceNum, A.InvoiceType
									HAVING		ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) <> 0
									UNION ALL

									/*AR Aging - 31-60 Days*/
									SELECT		A.Customer AS 'Client','ARID31' AS HyperionAcct, ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) AS 'Value'
									FROM		DallasApp.dbo.xWorkingCap_Invoices A LEFT OUTER JOIN DallasApp.dbo.xWorkingCap_Payments B ON B.InvoiceNum = A.InvoiceNum AND B.InvoiceType = A.InvoiceType AND (B.Period <= @Period OR B.Period IS NULL)
									WHERE		A.Period <= @Period AND A.InvoiceDate < DATEADD(dd,-30,@PeriodEndDate) AND A.InvoiceDate >= DATEADD(dd,-60,@PeriodEndDate)
									GROUP BY	A.Customer,A.InvoiceNum, A.InvoiceType
									HAVING		ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) <> 0
									UNION ALL

									/*AR Aging - 61-90 Days*/
									SELECT		A.Customer AS 'Client','ARID61' AS HyperionAcct, ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) AS 'Value'
									FROM		DallasApp.dbo.xWorkingCap_Invoices A LEFT OUTER JOIN DallasApp.dbo.xWorkingCap_Payments B ON B.InvoiceNum = A.InvoiceNum AND B.InvoiceType = A.InvoiceType AND (B.Period <= @Period OR B.Period IS NULL)
									WHERE		A.Period <= @Period AND A.InvoiceDate < DATEADD(dd,-60,@PeriodEndDate) AND A.InvoiceDate >= DATEADD(dd,-90,@PeriodEndDate)
									GROUP BY	A.Customer,A.InvoiceNum, A.InvoiceType
									HAVING		ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) <> 0
									UNION ALL

									/*AR Aging - 91-120 Days*/
									SELECT		A.Customer AS 'Client','ARID91' AS HyperionAcct, ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) AS 'Value'
									FROM		DallasApp.dbo.xWorkingCap_Invoices A LEFT OUTER JOIN DallasApp.dbo.xWorkingCap_Payments B ON B.InvoiceNum = A.InvoiceNum AND B.InvoiceType = A.InvoiceType AND (B.Period <= @Period OR B.Period IS NULL)
									WHERE		A.Period <= @Period AND A.InvoiceDate < DATEADD(dd,-90,@PeriodEndDate) AND A.InvoiceDate >= DATEADD(dd,-120,@PeriodEndDate)
									GROUP BY	A.Customer,A.InvoiceNum, A.InvoiceType
									HAVING		ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) <> 0
									UNION ALL

									/*AR Aging - 121-150 Days*/
									SELECT		A.Customer AS 'Client','ARID121' AS HyperionAcct, ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) AS 'Value'
									FROM		DallasApp.dbo.xWorkingCap_Invoices A LEFT OUTER JOIN DallasApp.dbo.xWorkingCap_Payments B ON B.InvoiceNum = A.InvoiceNum AND B.InvoiceType = A.InvoiceType AND (B.Period <= @Period OR B.Period IS NULL)
									WHERE		A.Period <= @Period AND A.InvoiceDate < DATEADD(dd,-120,@PeriodEndDate) AND A.InvoiceDate >= DATEADD(dd,-150,@PeriodEndDate)
									GROUP BY	A.Customer,A.InvoiceNum, A.InvoiceType
									HAVING		ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) <> 0
									UNION ALL

									/*AR Aging - 151-180 Days*/
									SELECT		A.Customer AS 'Client','ARID151' AS HyperionAcct, ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) AS 'Value'
									FROM		DallasApp.dbo.xWorkingCap_Invoices A LEFT OUTER JOIN DallasApp.dbo.xWorkingCap_Payments B ON B.InvoiceNum = A.InvoiceNum AND B.InvoiceType = A.InvoiceType AND (B.Period <= @Period OR B.Period IS NULL)
									WHERE		A.Period <= @Period AND A.InvoiceDate < DATEADD(dd,-150,@PeriodEndDate) AND A.InvoiceDate >= DATEADD(dd,-180,@PeriodEndDate)
									GROUP BY	A.Customer,A.InvoiceNum, A.InvoiceType
									HAVING		ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) <> 0
									UNION ALL

									/*AR Aging - 181+ Days*/
									SELECT		A.Customer AS 'Client','ARID180' AS HyperionAcct, ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) AS 'Value'
									FROM		DallasApp.dbo.xWorkingCap_Invoices A LEFT OUTER JOIN DallasApp.dbo.xWorkingCap_Payments B ON B.InvoiceNum = A.InvoiceNum AND B.InvoiceType = A.InvoiceType AND (B.Period <= @Period OR B.Period IS NULL)
									WHERE		A.Period <= @Period AND A.InvoiceDate < DATEADD(dd,-180,@PeriodEndDate)
									GROUP BY	A.Customer,A.InvoiceNum, A.InvoiceType
									HAVING		ROUND((MAX(A.InvoiceAmount)+SUM(COALESCE(B.PaymentAmt,0))),2) <> 0

								/******** WIP BY CLIENT ********/

								/******** CASH RECEIVED BY CLIENT AND DATE FROM INVOICE ********/

								/*Cash Applications */
								/*DocType IN ('PA','DA','NS','RP','SB','SC')*/) AS XX LEFT OUTER JOIN DallasApp.dbo.Customer XA ON XX.[Client] = XA.CustId
					GROUP BY	XA.[User1], XX.[HyperionAcct]) AS X 
	GROUP BY	X.[Client], X.[HyperionAcct]

END
GO
