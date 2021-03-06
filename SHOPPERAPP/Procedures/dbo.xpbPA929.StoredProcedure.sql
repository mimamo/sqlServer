USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbPA929]    Script Date: 12/21/2015 16:13:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbPA929] (
@RI_ID int
)

AS

--DECLARE @RI_ID int
--SET @RI_ID = 6984

DELETE FROM xwrk_PA929
WHERE RI_ID = @RI_ID

DECLARE @sql1 nvarchar(MAX)
--DECLARE @sql2 nvarchar(MAX)

DECLARE @RI_WHERE varchar(255)

SET @RI_WHERE = CASE WHEN (SELECT RI_WHERE FROM RptRuntime WHERE RI_ID = @RI_ID) = '' 
						THEN ''
						ELSE (SELECT REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(RI_WHERE)), '(', ''), ')', ''), 'xwrk_PA929.', '') FROM rptRuntime WHERE RI_ID = @RI_ID) end

SET @sql1 = CAST('
DECLARE @sort1 varchar(25)
DECLARE @sort2 varchar(25)
DECLARE @sort3 varchar(25)
DECLARE @sort4 varchar(25)
DECLARE @sort5 varchar(25)
DECLARE @concat varchar(255)

SET @sort1 = CASE WHEN @RRI_WHERE = ''''
					THEN ''''
					ELSE ISNULL((SELECT theValue FROM dbo.xfn_DelimitedToTable2(@RRI_WHERE, '' '') WHERE ident = 1), '''') end
SET @sort2 = CASE WHEN @RRI_WHERE = ''''
					THEN ''''
					ELSE ISNULL((SELECT theValue FROM dbo.xfn_DelimitedToTable2(@RRI_WHERE, '' '') WHERE ident = 5), '''') end
SET @sort3 = CASE WHEN @RRI_WHERE = ''''
					THEN ''''
					ELSE ISNULL((SELECT theValue FROM dbo.xfn_DelimitedToTable2(@RRI_WHERE, '' '') WHERE ident = 9), '''') end
SET @sort4 = CASE WHEN @RRI_WHERE = ''''
					THEN ''''
					ELSE ISNULL((SELECT theValue FROM dbo.xfn_DelimitedToTable2(@RRI_WHERE, '' '') WHERE ident = 13), '''') end
SET @sort5 = CASE WHEN @RRI_WHERE = ''''
					THEN ''''
					ELSE ISNULL((SELECT theValue FROM dbo.xfn_DelimitedToTable2(@RRI_WHERE, '' '') WHERE ident = 17), '''') end

IF @sort1 = ''''
BEGIN
SET @concat = '' {No selection criteria entered}''
GOTO NEXT_SECTION
END

BEGIN
SET @concat = CASE WHEN @sort1  = ''''
					THEN '''' 
					ELSE @sort1 + '', '' end + 
			CASE WHEN @sort2 = ''''
					THEN '''' 
					ELSE @sort2 + '', '' end +
			CASE WHEN @sort3 = ''''
					THEN '''' 
					ELSE @sort3 + '', '' end + 
			CASE WHEN @sort4 = ''''
					THEN '''' 
					ELSE @sort4 + '', '' end + 
			CASE WHEN @sort5 = ''''
					THEN '''' 
					ELSE @sort5 end 		
END

SET @concat = REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(@concat, 1, LEN(@concat) -1), ''CustomerCode'', ''Client ID''), ''Project_Billwith'', ''Project Billwith''), ''ProductCode'', ''Product ID''), ''PONumber'', ''PO'')
--PRINT @concat

NEXT_SECTION:
INSERT INTO xwrk_PA929
SELECT DISTINCT @RRI_ID
, r.UserId
, r.SystemDate
, r.SystemTime
, r.ComputerName
, p.pm_id01 as ''CustomerCode''
, isnull(c.[name],''Customer Name Unavailable'') as ''CustomerName''
, p.pm_id02 as ''ProductCode''
, isnull(bcyc.code_value_desc,'''') as ''ProductDesc''
, b.project_billwith as ''Project_Billwith''
, p.project_desc as ''ProjectDesc''
, p.contract_type as ''JobCat''
, po.ExtCost as ''ExtCost''
, po.CostVouched as ''CostVouched''
, p.purchase_order_num as ''PONumber''
, p.status_pa as ''StatusPA''
, p.[start_date] as ''StartDate''
, p.end_date as ''OnShelfDate'' 
, p.pm_id08 as ''CloseDate''
, p.pm_id04 as ''Type''
, p.pm_id05 as ''SubType''
, x.pm_id28 as ''ECD''
, p.pm_id32 as ''OfferNum''
, xc.CName as ''ClientContact''
, xc.EmailAddress as ''ContactEmailAddress''
, xr.RCustName as ''RetailCustName''
, p.user1 as ''RetailCustomerID''
, p.user3 as ''Differentiator''
, p.user4 as ''PTODesignator''
, p.manager1 as ''PM''
, p.manager2 as ''AcctService''
, isnull(x.pm_id26,0) as ''FJ_Estimate''
, isnull(est.EstimateAmountEAC,0) as ''EstimateAmountEAC''
, isnull(est.EstimateAmountFAC,0) as ''EstimateAmountFAC''
, isnull(est.EstimateAmountTotal,0) as ''EstimateAmountTotal''
, isnull(act.Acct,'''') as ''ActAcct''
, isnull(act.Amount01,0) as ''Amount01''
, isnull(act.Amount02,0) as ''Amount02''
, isnull(act.Amount03,0) as ''Amount03''
, isnull(act.Amount04,0) as ''Amount04''
, isnull(act.Amount05,0) as ''Amount05''
, isnull(act.Amount06,0) as ''Amount06''
, isnull(act.Amount07,0) as ''Amount07''
, isnull(act.Amount08,0) as ''Amount08''
, isnull(act.Amount09,0) as ''Amount09''
, isnull(act.Amount10,0) as ''Amount10''
, isnull(act.Amount11,0) as ''Amount11''
, isnull(act.Amount12,0) as ''Amount12''
, isnull(act.Amount13,0) as ''Amount13''
, isnull(act.Amount14,0) as ''Amount14''
, isnull(act.Amount15,0) as ''Amount15''
, isnull(act.AmountBF,0) as ''AmountBF''
, isnull(act.FSYearNum,''1900'') as ''FSYearNum''
, isnull(act.AcctGroupCode,'''') as ''AcctGroupCode''
, isnull(act.ControlCode,'''') as ''ControlCode''
, ISNULL(e.ULEAmount, 0) as ''ULEAmount''
, ISNULL(h.Create_Date, ''01/01/1900'') as ''ULECreate_Date''
, @concat as ''SortByHeader''
FROM PJBILL b LEFT JOIN PJPROJ p ON b.project_billwith = p.project
	LEFT JOIN Customer c ON p.pm_id01 = c.custid
	LEFT JOIN PJCODE bcyc ON p.pm_id02 = bcyc.code_value and bcyc.code_type = ''BCYC''
	LEFT JOIN xvr_PA929_Estimates est ON p.project = est.project
	LEFT JOIN xvr_PA929_Actuals act ON p.project = act.project
	LEFT JOIN xvr_PA929_PO po ON p.project = po.ProjectID
	LEFT JOIN PJPROJEX x ON p.project = x.project
	LEFT JOIN xClientContact xc ON p.user2 = xc.EA_ID
	LEFT JOIN xRetailCustomer xr ON p.user1 = xr.RCustID
	LEFT JOIN xvr_Est_ULE_Project e ON p.project = e.Project
	LEFT JOIN PJREVHDR h ON e.Project = h.Project
	JOIN RptRuntime r ON RI_ID = @RRI_ID
WHERE b.project <> b.project_billwith
	AND SUBSTRING(b.project, 10, 3) <> ''APS''
	AND b.project_billwith <> ''''
' as nvarchar(MAX))

DECLARE @ParmDef nvarchar(100)

SET @ParmDef = N'@RRI_ID int, @RRI_WHERE varchar(255)'

--EXEC xPrintMax @sql1

EXEC sp_executesql @sql1, @ParmDef, @RRI_ID = @RI_ID, @RRI_WHERE = @RI_WHERE
GO
