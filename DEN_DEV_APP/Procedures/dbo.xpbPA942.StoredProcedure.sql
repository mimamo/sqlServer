USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbPA942]    Script Date: 12/21/2015 14:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbPA942] (
@RI_ID int
)

AS



BEGIN
DELETE FROM xwrk_PA942
WHERE RI_ID = @RI_ID
END

BEGIN
DELETE FROM xwrk_PA942_AR000
WHERE RI_ID = @RI_ID
END

BEGIN
EXEC xpbPA942_AR000 @RI_ID
END


--DECLARE @RI_ID int
--SET @RI_ID = 1013


DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @RI_WHERE varchar(MAX)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM RptRuntime WHERE RI_ID = @RI_ID)

--PRINT @RI_WHERE

SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_PA942.', '')

--PRINT @RI_WHERE

SET @sql1 = CAST('
BEGIN
INSERT xwrk_PA942(RI_ID, UserID, RunDate, RunTime, TerminalNum, CustomerCode, CustomerName, ClassID, ProductCode, ProductDesc, Project, JobCat
, ExtCost, CostVouched, ProjectDesc, PONumber, StatusPA, StartDate, OnShelfDate, CloseDate, Type, SubType, ECD, OfferNum, ClientContact
, ContactEmailAddress, RetailCustName, RetailCustomerID, Differentiator, PTODesignator, PM, FJ_Estimate, EstimateAmountEAC, EstimateAmountFAC
, EstimateAmountTotal, ActAcct, Amount01, Amount02, Amount03, Amount04, Amount05, Amount06, Amount07, Amount08, Amount09, Amount10, Amount11
, Amount12, Amount13, Amount14, Amount15, AmountBF, FSYearNum, AcctGroupCode, ControlCode)
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.pm_id01 as ''CustomerCode''
, isnull(c.[name],''Customer Name Unavailable'') as ''CustomerName''
, isnull(c.classid, '''') as ''ClassID''
, p.pm_id02 as ''ProductCode''
, isnull(bcyc.code_value_desc,'''') as ''ProductDesc''
, p.project as ''Project''
, p.contract_type as ''JobCat''
, isnull(po.ExtCost, 0) as ''ExtCost''
, isnull(po.CostVouched, 0) as ''CostVouched''
, p.project_desc as ''ProjectDesc''
, p.purchase_order_num as ''PONumber''
, p.status_pa as ''StatusPA''
, p.start_date as ''StartDate''
, p.end_date AS ''OnShelfDate'' 
, p.pm_id08 AS ''CloseDate''
, p.pm_id04 AS ''Type''
, p.pm_id05 AS ''SubType''
, x.pm_id28 AS ''ECD''
, p.pm_id32 AS ''OfferNum''
, isnull(xc.CName, '''') as ''ClientContact''
, isnull(xc.EmailAddress, '''') as ''ContactEmailAddress''
, isnull(xr.RCustName, '''') as ''RetailCustName''
, p.user1 as ''RetailCustomerID''
, p.user3 as ''Differentiator''
, p.user4 as ''PTODesignator''
, p.manager1 as ''PM''
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
, isnull(act.Amount13,0) as ''Amount13''' as nvarchar(max))
SET @sql2 = CAST('
, isnull(act.Amount14,0) as ''Amount14''
, isnull(act.Amount15,0) as ''Amount15''
, isnull(act.AmountBF,0) as ''AmountBF''
, isnull(act.FSYearNum,''1900'') as ''FSYearNum''
, isnull(act.AcctGroupCode,'''') as ''AcctGroupCode''
, isnull(act.ControlCode,'''') as ''ControlCode''
FROM PJPROJ p LEFT JOIN Customer c on p.pm_id01 = c.custid
	LEFT JOIN PJCODE bcyc on p.pm_id02 = bcyc.code_value and bcyc.code_type = ''BCYC''
	LEFT JOIN xvr_PA942_Estimates est on p.project = est.project
	LEFT JOIN xvr_PA942_Actuals act on p.project = act.project
	LEFT JOIN xvr_PA942_PO po on p.project = po.ProjectID
	LEFT JOIN PJPROJEX x ON p.project = x.project
	LEFT JOIN xClientContact xc ON p.user2 = xc.EA_ID
	LEFT JOIN xRetailCustomer xr ON p.user1 = xr.RCustID
	JOIN RptRuntime r ON RI_ID = @RRI_ID
WHERE p.status_pa <> ''A''
	AND p.purchase_order_num <> ''''
	AND p.contract_type <> ''APS''
	AND p.purchase_order_num not in (SELECT purchase_order_num FROM xvr_PA942_POExclusion)
	AND p.project not in (SELECT DISTINCT ProjectID FROM xwrk_PA942_AR000 WHERE RI_ID = @RRI_ID)) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + char(13) +
'END ' as nvarchar(max))

DECLARE @sql3 nvarchar(MAX)

SET @sql3 = @sql1 + @sql2

--EXEC xPrintMax @sql3

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql3, @ParmDef, @RRI_ID = @RI_ID
GO
