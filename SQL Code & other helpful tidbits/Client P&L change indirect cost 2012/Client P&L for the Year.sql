
-- UPDATE FOR MONTH BEING RUN !!!!!!!!!!!!!!!!!!
--Step # 3 Script Preparation & Step # 4 Running and Reconciliation

-- UPDATE FOR MONTH BEING RUN !!!!!!!!!!!!!!!!!!
-- Update TransDate for Hours, AR Interest Expense


-- Hours 
Delete From   [SQL2].EmployeeAllocation.dbo.[Period_PL]
INSERT INTO [SQL2].EmployeeAllocation.dbo.[Period_PL]
    (CustId, [Name], code_ID, descr, PJACCT.acct_type, PJACCT.acct,Total,TTLHrs, fiscalno, employee, SubAccount)
SELECT     Customer.CustId, Customer.Name, xIGProdCode.code_ID, xIGProdCode.descr, PJACCT.acct_type, PJACCT.acct, '0' AS Total, SUM(PJTRAN.units) AS TTLHrs, 

Case When PJTRAN.Fiscalno > 
	CONVERT(char(4), YEAR(PJTRAN.trans_date)) + CASE WHEN len(CONVERT(varchar, month(PJTRAN.trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(PJTRAN.trans_date)) 
	Then PJTRAN.Fiscalno 
	else CONVERT(char(4), YEAR(PJTRAN.trans_date)) + CASE WHEN len(CONVERT(varchar, month(PJTRAN.trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(PJTRAN.trans_date))
end as TDMonth, 

PJTRAN.employee, PJTRAN.gl_subacct

FROM         SQL1.DenverAPP.dbo.PJTRAN AS PJTRAN LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.PJPROJ AS PJPROJ ON PJTRAN.project = PJPROJ.project LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.Customer AS Customer ON PJPROJ.pm_id01 = Customer.CustId LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.xIGProdCode AS xIGProdCode ON PJPROJ.pm_id02 = xIGProdCode.code_ID LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.PJLABHDR AS PJLABHDR ON PJTRAN.employee = PJLABHDR.employee AND 
                      PJTRAN.bill_batch_id = PJLABHDR.docnbr LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.PJACCT AS PJACCT ON PJTRAN.acct = PJACCT.acct
WHERE     ((PJTRAN.trans_date BETWEEN '1/1/2011' AND '12/31/2011') OR (PJTRAN.Fiscalno LIKE '2011%')) AND (PJTRAN.acct = 'LABOR') AND (PJLABHDR.le_status IN ('A', 'C', 'I', 'P'))
GROUP BY Customer.CustId, Customer.Name, xIGProdCode.code_ID, xIGProdCode.descr, PJACCT.acct_type, PJACCT.acct, PJTRAN.employee, 
                      PJTRAN.gl_subacct, 

Case When PJTRAN.Fiscalno > 
	CONVERT(char(4), YEAR(PJTRAN.trans_date)) + CASE WHEN len(CONVERT(varchar, month(PJTRAN.trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(PJTRAN.trans_date)) 
	Then PJTRAN.Fiscalno 
	else CONVERT(char(4), YEAR(PJTRAN.trans_date)) + CASE WHEN len(CONVERT(varchar, month(PJTRAN.trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(PJTRAN.trans_date))
end  


Delete from [SQL2].EmployeeAllocation.dbo.[Period_PL]
Where Fiscalno NOT LIKE '2011%'

Delete from [SQL2].EmployeeAllocation.dbo.[Period_PL]
Where CustID not like '1%'




--Revenue
-- DAB 1/25/2012:  Added 1045 to the Where clause for sub to include all New York Revenue
Insert Into [SQL2].EmployeeAllocation.dbo.[Period_PL]
	(acct, Total, CustID, Code_ID, fiscalno, employee, ProfitCenter, SubAccount)
SELECT    
	Case When GLTran.Acct = '4501' Then 'Revenue Accruals'
	When GLTran.Acct = '4510' Then 'Retainers'
	--When GLTran.Acct = '4600' Then 'Project Fee'
	When GLTran.Acct = '4630' then 'Digital Fees'
	When GLTran.Acct = '4631' then 'Direct Mktg Fees'
	When GLTran.Acct in ('4300','4515','4520') then 'Revenue Accruals'
	When GLTran.Acct = '4625' Then 'I&S Fees'
	--When GLTran.Acct = '4640' Then 'Project Fee'
	When GLTran.Acct in ('4540','4600','4640','7515', '7516', '7185', '7186') then 'Project Fee'
	Else 'Unclassified'
	end  as acct, 

Sum(GLTran.CuryCrAmt - GLTran.CuryDrAmt) AS Amount, 
	Case When GLTran.Acct in ('7515', '7516', '7185', '7186') then '1CBC00'
		WHEN GLTran.Acct = '4540' THEN '1GWLA'
	Else  PJPROJ.pm_id01
	end  AS CustID, 

	Case When GLTran.Acct in ('7515', '7516', '7185', '7186') then 'WKF'
		WHEN GLTran.Acct = '4540' THEN 'GWLR'
	Else PJPROJ.pm_id02 
	End AS Code_ID,
	'201112' as fiscalno, 'user' as Emp, 'Denver' as PCenter, GLTran.Sub
FROM         SQL1.denverapp.dbo.PJPROJ RIGHT OUTER JOIN
                      SQL1.denverapp.dbo.GLTran ON PJPROJ.project = GLTran.ProjectID
Where ((Acct between 4299 and 4699 and Sub in ('0000', '1000', '1019', '1045', '1080')) OR (Acct in ('7515', '7516', '7185', '7186')))
	and GLTran.CpnyID = 'DENVER'
	and GLTran.PerPost LIKE '2011%'
	and GLTran.Posted = 'P'
	and GLTran.LedgerId = 'ACTUAL'
	--and PJPROJ.pm_id01 like '1%'
Group By GLTran.Acct, PJPROJ.pm_id01, PJPROJ.pm_id02, GLTran.Sub



-- Expenses 
INSERT INTO [SQL2].EmployeeAllocation.dbo.[Period_PL]
    (CustId, [Name], code_ID, descr, acct_type, acct,Total, fiscalno, employee, DirectSalaries, SubAccount)
SELECT     Customer.CustId, Customer.Name, xIGProdCode_1.code_ID, xIGProdCode_1.descr, PJACCT.acct_type, PJACCT.acct, SUM(PJTRAN.amount) AS Total, 
                      PJTRAN.fiscalno, PJTRAN.employee, SUM(PJTRAN.units * Employees.HRLRate) AS DirectSalaries, 
                      PJTRAN.gl_subacct
FROM         SQL1.DenverAPP.dbo.PJTRAN AS PJTRAN LEFT OUTER JOIN
                      EmployeeAllocation.dbo.Employee_info AS Employees ON PJTRAN.employee = Employees.UserID AND 
                      PJTRAN.fiscalno = Employees.FiscalPeriod LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.PJPROJ AS PJPROJ ON PJTRAN.project = PJPROJ.project LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.PJACCT AS PJACCT ON PJTRAN.acct = PJACCT.acct LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.Customer AS Customer ON PJPROJ.pm_id01 = Customer.CustId LEFT OUTER JOIN
                      SQL1.DenverAPP.dbo.xIGProdCode AS xIGProdCode_1 ON PJPROJ.pm_id02 = xIGProdCode_1.code_ID
WHERE   (Customer.CustId LIKE '1%') 
	AND (PJACCT.acct_type = 'EX') 
	AND (PJACCT.acct Not In ('APS TRANSFER', 'LABOR', 'APS TRANSFER REV','COS APS', 'NEW BUSINESS', 'OVERHEAD', 'WIP APS', 'WIP CLEARING', 'WIP FREELANCE', 'WIP PRODUCTION', 'WIP SALES TAX', 'WIP TALENT', 'WIP TRAVEL', 'APS SALES', 'PRODUCTION BILL', 'COS PRODUCTION', 'ART BUYING FEES', 'BRDCST FEES'))
	AND (PJTRAN.fiscalno LIKE '2011%')
GROUP BY Customer.CustId, Customer.Name, xIGProdCode_1.code_ID, xIGProdCode_1.descr, PJACCT.acct_type, PJACCT.acct, PJTRAN.fiscalno, 
                      PJTRAN.employee, PJTRAN.gl_subacct




Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set TTLHrs = '0'
Where acct <> 'LABOR           '


-- Find all Denver Profit Center GL accounts.  Delete all others as they have their own statements.
Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set ProfitCenter = 'APS'
Where SubAccount in ('1090', '1085', '1076', '1031', '1032')

Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set ProfitCenter = 'IPM'
Where SubAccount in ('2700')

Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set ProfitCenter = 'Corporate'
Where SubAccount in ('1052', '1051', '1050')

-- DAB 1/25/2012:  Added 1045 to the subaccount filter so that we include all New York expenses.
Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set ProfitCenter = 'Denver'
Where SubAccount in ('1049', '5000', '1096', '1095', '1081', '1080', '1075', '1055', '1042', '1041', '1040', '1030', '1026', '1025', '1021', '1020', '1019', '1018', '1017', '1016', '1015', '1014', '1013', '1012', '1010', '1000', '0000', '1045')

Update Period_PL
Set ProfitCenter = 'DENVER'
Where ProfitCenter Is Null
	and acct = 'SEA'


Delete from [SQL2].EmployeeAllocation.dbo.[Period_PL]
Where ProfitCenter <> 'Denver'


-- Identify Direct vs. InDirect Clients for allocation purposes.  (*******Tim Changed Arell's logic to allow for 1TIGGN CustID's to be classified as direct.*********)
Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set [Type] = 'Indirect'
Where CustID in ('1TIGGN','1INTJB', '1PROBO', '1TIGMN')

-- This was to fix January 2011 SEA expense hitting indirect client code
-- DAB 1/25/2012:  Added ABSO to the code_id list to set that expense to direct
Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set [Type] = 'Direct'
Where Acct = 'SEA' and LTRIM(RTRIM(code_id)) in ('GEN', 'INTR', 'ABSO')

Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set [Type] = 'Direct'
Where [type]  Is Null

Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set [Type] = 'Direct'
Where acct = 'Digital Fees'
	AND code_id = 'IGG'



/* Employee Hours by Client/Product
 Clear out table for summary hours.  Could eventually get to a point to only append and keep historical data
 It seems like a triplicate of hours (here, Dynamics, ADP) */
Delete from  [SQL2].EmployeeAllocation.dbo.Employee_SummaryHours

-- Get total hours entered for each employee by fiscal period.
INSERT INTO [SQL2].EmployeeAllocation.dbo.Employee_SummaryHours (employee, fiscalno, MonthlyHours)
Select Employee, Fiscalno, IsNull(Sum(TTLHrs),0) as Hours
From [SQL2].employeeallocation.dbo.[Period_PL]
Group by Employee, fiscalno

--Must update sensitive information...Could work from query above but I do not know the code well enough to do it.			
UPDATE    [SQL2].EmployeeAllocation.dbo.Employee_info
SET              TTLHrs = Employee_SummaryHours.MonthlyHours
FROM         [SQL2].EmployeeAllocation.dbo.Employee_info AS Employee_info INNER JOIN
                      [SQL2].EmployeeAllocation.dbo.Employee_SummaryHours AS Employee_SummaryHours ON Employee_info.UserID = Employee_SummaryHours.Employee AND 
                      Employee_info.FiscalPeriod = Employee_SummaryHours.Fiscalno



/* Getting each employees hourly rate, varies month to month for salried workers.
 Will use this below to calculate direct salaries to client product. */
Update  [SQL2].EmployeeAllocation.dbo.Employee_Info
Set HrlRate = PayAmt / TTLHrs
Where ttlHrs is not null and ttlhrs <>'0' and FiscalPeriod LIKE '2011%'

-- Update Direct salaries based on above calculation.
UPDATE    EmployeeAllocation.dbo.[Period_PL]
SET              DirectSalaries = EmployeeAllocation.dbo.[Period_PL].TTLHrs * EmployeeAllocation.dbo.Employee_info.HRLRate
FROM         EmployeeAllocation.dbo.[Period_PL] INNER JOIN
                      EmployeeAllocation.dbo.Employee_info ON EmployeeAllocation.dbo.[Period_PL].employee = EmployeeAllocation.dbo.Employee_info.UserID AND 
                      EmployeeAllocation.dbo.[Period_PL].fiscalno = EmployeeAllocation.dbo.Employee_info.FiscalPeriod

-- Update expenses as negative numbers so summing works, don't have to do revenue - expenses.  For speed only.
Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set Total = total *-1
Where acct_type = 'EX'

-- Group Like items.  

Update [SQL2].EmployeeAllocation.dbo.[Period_PL]
Set Acct = 'PROJECT FEE'
Where acct = 'MISC PRJCT FEE'



-- verify that there isn't anything in the Period_PL table for the year
select * from [Period_PL] where type = 'indirect' and code_id = 'GEN' and custid = '1TIGGN' and employee = 'VarUser'

-- update allocations for the year
Insert into [SQL2].employeeallocation.dbo.[Period_PL]
	(Type, CustID, Name, Code_ID, Descr, Acct_Type, Acct, total, TTLHrs, Fiscalno,
		Employee, DirectSalaries, SubAccount, ProfitCenter)
select Type, CustID, Name, Code_ID, Descr, Acct_Type, Acct, total, TTLHrs, Fiscalno,
		Employee, DirectSalaries, SubAccount, ProfitCenter from vtbl_Period_PL_All where type = 'indirect' and code_id = 'GEN' and custid = '1TIGGN' and employee = 'VarUser' and fiscalno like '2011%'






-- UnComment to Run for Interactive  
-- Interative allocation for their own P&L

Update [Period_PL]
Set Type = 'Direct', CustID = '1INACT', Name = 'Digital', CodeGrp = 'INA', CodeGrpDesc = 'Digital', Code_ID = 'INA', descr = 'Digital'
where subAccount = '1019' 

Update [Period_PL]
Set Type = 'Direct', CustID = '1INACT', Name = 'Digital', CodeGrp = 'INA', CodeGrpDesc = 'Digital', Code_ID = 'INA', descr = 'Digital'
where acct = 'Digital Fees'

--End Interactive Allcoation





-- Allocate all of 1PGGEN wages to all P & G Clients
-- Criteria is LIke P% and not like Polar%

INSERT INTO [Period_PL]
                      (Type, CustId, Name, CodeGrp, CodeGrpDesc, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter,DirectSalaries, employee)
SELECT     [Period_PL_1].Type, [Period_PL_1].CustId, [Period_PL_1].Name, [Period_PL_1].CodeGrp, [Period_PL_1].CodeGrpDesc, [Period_PL_1].code_ID, 
                      [Period_PL_1].descr, [Period_PL_1].acct_type, [Period_PL_1].acct, [Period_PL_1].fiscalno, [Period_PL_1].ProfitCenter, 
                      SUM([Period_PL_1].TTLHrs) / vw_PG_TTLHrs.TotalHrs * vw_PGGen_Wages.TtlPGGenWages AS Allocation, 'none' as Employee
FROM         [Period_PL] AS [Period_PL_1] CROSS JOIN
                      vw_PG_TTLHrs CROSS JOIN
                      vw_PGGen_Wages
GROUP BY [Period_PL_1].Type, [Period_PL_1].CustId, [Period_PL_1].Name, [Period_PL_1].CodeGrp, [Period_PL_1].CodeGrpDesc, 
                      [Period_PL_1].code_ID, [Period_PL_1].descr, [Period_PL_1].acct_type, [Period_PL_1].acct, [Period_PL_1].fiscalno, [Period_PL_1].ProfitCenter, 
                      vw_PG_TTLHrs.TotalHrs, vw_PGGen_Wages.TtlPGGenWages
HAVING      ([Period_PL_1].acct = 'Labor') AND ([Period_PL_1].Name LIKE 'P%') AND (NOT ([Period_PL_1].Name LIKE 'Polar%')) AND 
                      ([Period_PL_1].CustId <> '1PGGEN')


Update [Period_PL]
Set DirectSalaries = '0'
Where custID = '1PGGEN'


Update [Period_PL]
Set TTLHrs = '0'
Where custID = '1PGGEN'


-- Inserts Summary Information into PeriodReporting.

Delete from  [SQL2].EmployeeAllocation.dbo.PeriodReporting

INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
                      ([Type], ReportGroup, CustId, [Name], code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     [Type], 'Direct', CustId, Name, code_ID, descr, acct_type, acct, SUM(Total) AS Total, fiscalno, ProfitCenter
FROM         [SQL2].EmployeeAllocation.dbo.vw_PeriodReport
GROUP BY Type, CustId, [Name], code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct <> 'LABOR')

INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     Type, 'Direct', CustId, Name, code_ID, descr, acct_type, 'Direct Wages', SUM(TotalWages)*-1 AS Total, fiscalno, ProfitCenter
FROM         [SQL2].EmployeeAllocation.dbo.vw_PeriodReport
GROUP BY Type, CustId, Name, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct = 'LABOR') 
Order by CustID

INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
		      -- ******************  Edit the tax rate here ********************
SELECT     Type, 'Direct', CustId, Name, code_ID, descr, acct_type, 'Direct Wages Payroll Expenses', SUM(TotalWages*.295189203312322)*-1 AS Total, fiscalno, ProfitCenter
FROM         [SQL2].EmployeeAllocation.dbo.vw_PeriodReport
GROUP BY Type, CustId, Name, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct = 'LABOR')


INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     Type, 'Indirect', CustId, Name, code_ID, descr, acct_type, 'Indirect Wages', SUM(indirectportion)*-1 AS Total, fiscalno, ProfitCenter
FROM         [SQL2].EmployeeAllocation.dbo.vw_PeriodReport
GROUP BY Type, CustId, Name, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct = 'LABOR')


INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
		      -- ******************  Edit the tax rate here ********************
SELECT     Type, 'Indirect', CustId, Name, code_ID, descr, acct_type, 'Indirect Wages Payroll Expenses', SUM(indirectportion*.295189203312322)*-1 AS Total, fiscalno, ProfitCenter
FROM         [SQL2].EmployeeAllocation.dbo.vw_PeriodReport
GROUP BY Type, CustId, Name, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct = 'LABOR')



-- Indirect Expenses.  There are both pass through and allocation
--Pass through expenses


INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, '', Group1, product, Descr, 'EX' AS Expr3, 'Direct Rent Expense' AS Expr4, SUM(Amount)*-1 AS TTLRent, 
                      fiscalperiod AS Expr5, 'Denver' as ProfitCenter
FROM         vtbl_indirectall
GROUP BY Group1, product, Type, Descr, fiscalperiod
HAVING      (Type = 'Rent') AND (Group1 <> 'Allocate') AND (fiscalperiod like '2011%')


INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, '', Group1, product, Descr, 'EX' AS Expr3, 'Direct Personnel' AS Expr4, SUM(Amount)*-1 AS TTLPersonnel, 
                      fiscalperiod AS Expr5, 'Denver' as ProfitCenter
FROM         vtbl_indirectall
GROUP BY Group1, product, Type, Descr, fiscalperiod
HAVING      (Type = 'Personnel') AND (Group1 <> 'Allocate') AND (fiscalperiod like '2011%')

--****************************************************  I AM HERE  **************************************************************
--****************************************************  I AM HERE  **************************************************************
--****************************************************  I AM HERE  **************************************************************
--****************************************************  I AM HERE  **************************************************************

--Allocation Expenses

INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Indirect Rent Expense' AS Expr4, SUM(Allocation)*-1 AS TTLRent, 
                      fiscalno AS Expr5, 'Denver' as ProfitCenter
FROM         vw_RentAllocationAll
WHERE fiscalperiod like '2011%'
GROUP BY  Type, CustId, code_ID, descr, Name, fiscalno
HAVING      (Type = 'Rent')
	And Code_id not in ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS'
		, 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK', 'NYK'
		, 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 'LPD', 'LMB', 'LLA', 'LCD', 'KNA'
		, 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP', 'COPR', 'CMV', 'CIZ'
		, 'CIE', 'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL', '3RD')


INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Indirect Personnel Expense' AS Expr4, SUM(Allocation)*-1 AS TTLPersonnel, 
                      fiscalno AS Expr5, 'Denver' as ProfitCenter
FROM         vw_IndirectAllocationAll
where fiscalperiod like '2011%'
GROUP BY  Type, CustId, code_ID, descr, Name, fiscalno
HAVING      (Type = 'Personnel')


INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Indirect Overhead Expense' AS Expr4, SUM(Allocation)*-1 AS Overhead, 
                      fiscalno AS Expr5, 'Denver' as ProfitCenter
FROM          vw_IndirectAllocationAll
where fiscalperiod like '2011%'
GROUP BY  Type, CustId, code_ID, descr, Name, fiscalno
HAVING      (Type = 'Overhead') 



INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Interest Expense' AS Expr4, SUM(Allocation)*-1 AS Interest, 
                     fiscalperiod AS Expr5, 'Denver' as ProfitCenter
FROM        vw_Revenue_Allocation_All
where fiscalperiod like '2011%'
GROUP BY  CustId, code_ID, descr, Name, fiscalperiod






INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT 'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, acct, Total, fiscalno, ProfitCenter
  FROM [EmployeeAllocation].[dbo].[vtbl_PeriodReportingAll] where Type = 'Direct' and acct = 'Donovan Expense'
  AND fiscalno like '2011%'



INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT 'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, acct, Total, fiscalno, ProfitCenter
  FROM [EmployeeAllocation].[dbo].[vtbl_PeriodReportingAll] where Type = 'Direct' and acct = 'Legal Expense'
  AND fiscalno like '2011%'




-- AR Interest expense
INSERT INTO PeriodReporting
                      (Type, ReportGroup, ReportSort, CustId, Name, CodeGrpDesc, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter, Hours)

SELECT 'Direct' AS Expr1, 'Expense' AS Expr2, '32' AS ReportSort, CustId, Name, CodeGrpDesc, code_ID, descr, 'EX' AS Expr3, acct, Total, fiscalno, ProfitCenter, Hours
  FROM [EmployeeAllocation].[dbo].[vtbl_PeriodReportingAll] where Type = 'Direct' and acct = 'AR Interest Expense'
  AND fiscalno like '2011%'

-- End Aged Interest Expense


-- Update Report Group and Report Sort for grouping and sorting resons.  Not able to sort by lineitems.
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '1', Acct = 'Retainers'
Where Acct = 'Retainers'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '3', Acct = 'Project Fee'
Where Acct = 'PROJECT FEE'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '5', Acct = 'Digital Fees'
Where Acct = 'Digital FEES'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '7', Acct = 'Direct Mktg Fees'
Where Acct = 'DIRECT MKTG FEES'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '8', Acct = 'I&S Fees'
Where Acct = 'I&S Fees'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '9', Acct = 'Revenue Accruals'
Where Acct = 'REVENUE ACCRUALS'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '11'
Where Acct = 'Direct Wages'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort =  '13'
Where Acct = 'Direct Wages Payroll Expenses'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '15'
Where Acct = 'Indirect Wages'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '17'
Where Acct = 'Indirect Wages Payroll Expenses'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '19'
Where Acct = 'SEA'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '21'
Where Acct = 'Direct Personnel'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '23'
Where Acct = 'Indirect Personnel Expense'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '25'
Where Acct = 'Direct Rent Expense'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '27'
Where Acct = 'Indirect Rent Expense'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '29'
Where Acct = 'Donovan Expense'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '31'
Where Acct = 'Legal Expense'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '32'
Where Acct = 'AR Interest Expense'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '34'
Where Acct = 'Interest Expense'
Update [SQL2].EmployeeAllocation.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '36'
Where Acct = 'Indirect Overhead Expense'


-- Update period reporting with total direct hours.  Used for reporting to compare to contracts.
UPDATE    EmployeeAllocation.dbo.PeriodReporting
SET              Hours = Direct.ProductHours
FROM         EmployeeAllocation.dbo.vw_Period_ClientProd_Hours AS Direct INNER JOIN
                      EmployeeAllocation.dbo.PeriodReporting ON Direct.CustId = EmployeeAllocation.dbo.PeriodReporting.CustId AND 
                      Direct.code_ID = EmployeeAllocation.dbo.PeriodReporting.code_ID
WHERE     (EmployeeAllocation.dbo.PeriodReporting.Type = 'direct') AND (EmployeeAllocation.dbo.PeriodReporting.acct = N'Direct Wages')
		

-- Update for Product Groups.  This was added late in project so I did not reconfig all code as this is relational to the Product, 
UPDATE    EmployeeAllocation.dbo.PeriodReporting
SET              CodeGrp = xIGProdCode_1.code_group, CodeGrpDesc = PJCode_1.code_value_desc
FROM         SQL1.DenverAPP.dbo.PJPROJ AS PJPROJ INNER JOIN
                      EmployeeAllocation.dbo.PeriodReporting ON PJPROJ.pm_id01 = EmployeeAllocation.dbo.PeriodReporting.CustId AND 
                      PJPROJ.pm_id02 = EmployeeAllocation.dbo.PeriodReporting.code_ID INNER JOIN
                      SQL1.DenverAPP.dbo.xIGProdCode AS xIGProdCode_1 ON PJPROJ.pm_id02 = xIGProdCode_1.code_ID INNER JOIN
                      SQL1.Denverapp.dbo.PJCode AS PJCode_1 ON xIGProdCode_1.code_group = PJCode_1.code_value



--Display the Report
Select ProfitCenter as [Profit Center], ReportGroup as [Type], ReportSort as Sort, Group1, Group2, Group3, Group4, Group5, Code_id as Product, Descr as [Product Description], acct as [Line Item], total as Amount, Hours 
from [SQL2].EmployeeAllocation.dbo.PeriodReporting Left JOIN [SQL2].EmployeeAllocation.dbo.vtbl_ProductGrouping ON PeriodReporting.code_id = vtbl_ProductGrouping.ProductId
Where [Type] = 'Direct' and ProfitCenter = 'Denver' and ReportGroup <> 'Direct'  
Order by Group1, Group2, Group3, Group4, Group5, code_id,   ReportSort,acct



/*
--***********************  Unallocated Wages due to no Hours.  *****************************
Select Sum(PayAmt) as wage
from employee_info
where (ttlhrs is null or ttlhrs = '0') and fiscalperiod LIKE '2011%'
*/

Select * from PeriodReporting where acct = 'Indirect Rent Expense' and fiscalno like'2011%'

Select * from vtbl_PeriodReportingAll where acct = 'Indirect Rent Expense' and fiscalno like'2011%'

select * from vtbl_PeriodReporting_2011_TEST

insert into vtbl_PeriodReporting_2011_TEST 
select * from PeriodReporting where acct = 'Indirect Rent Expense'

BEGIN TRAN
INSERT INTO vtbl_PeriodReporting_2011_TEST 
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter, ReportSort, Hours, Quarter)
SELECT     Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter, ReportSort, Hours, 
CASE WHEN RIGHT(fiscalno, 2) <= 3 THEN 'Q1'
WHEN (RIGHT(fiscalno, 2) >= 4 AND RIGHT(fiscalno, 2) <=6) THEN 'Q2'
WHEN (RIGHT(fiscalno, 2) >= 7 AND RIGHT(fiscalno, 2) <=9) THEN 'Q3'
ELSE 'Q4' END
FROM         PeriodReporting
where acct = 'Indirect Rent Expense'
commit

BEGIN TRAN
--All Consistant SQl Statement (Inserts $0 records for all product\Line item combination)
Insert into vtbl_PeriodReporting_2011_TEST 
						(Type, ReportGroup, ReportSort, code_Id, descr, fiscalno, acct_type, acct, total, profitcenter, hours, quarter)

Select 'Direct', PV.ReportGroup, PV.ReportSort, PV.ProductID, PV.ProdDescr, PV.Fiscalno, pv.acct_type, pv.acct, '0', 'Denver', '0', PV.Qtr
From ( Select *
from vtbl_FiscalNo fno  Cross JOIN vtbl_LineItems li
	Cross Join vtbl_ProductGrouping pg ) PV LEFT JOIN vtbl_PeriodReporting_2011_TEST rpt ON PV.Fiscalno = rpt.fiscalno
		and PV.ProductID = rpt.code_id
		and PV.ReportSort = rpt.ReportSort
Where rpt.Code_id is null
commit

Select pg.Group1, pg.Group2
, sum(CASE WHEN  ReportGroup = 'Revenue' THEN IsNull(rpt.total,0) END) as 'Revenue'
, sum(CASE WHEN  ReportGroup = 'Expense' THEN IsNull(rpt.total,0) END) as 'Total Expense'
, sum(CASE WHEN  ReportSort = '11' THEN IsNull(rpt.total,0) END) as  'Direct Wages'
, sum(CASE WHEN  ReportSort =  '13' THEN IsNull(rpt.total,0) END) as  'Direct Wages Payroll Expenses'
, sum(CASE WHEN  ReportSort = '15' THEN IsNull(rpt.total,0) END) as  'Indirect Wages'
, sum(CASE WHEN  ReportSort = '17' THEN IsNull(rpt.total,0) END) as  'Indirect Wages Payroll Expenses'
, sum(CASE WHEN  ReportSort = '19' THEN IsNull(rpt.total,0) END) as  'SEA'
, sum(CASE WHEN  ReportSort = '21' THEN IsNull(rpt.total,0) END) as  'Direct Personnel'
, sum(CASE WHEN  ReportSort = '23' THEN IsNull(rpt.total,0) END) as  'Indirect Personnel Expense'
, sum(CASE WHEN  ReportSort = '25' THEN IsNull(rpt.total,0) END) as  'Direct Rent Expense'
, sum(CASE WHEN  ReportSort = '27' THEN IsNull(rpt.total,0) END) as  'Indirect Rent Expense'
, sum(CASE WHEN  ReportSort = '29' THEN IsNull(rpt.total,0) END) as  'Donovan Expense'
, sum(CASE WHEN  ReportSort = '31' THEN IsNull(rpt.total,0) END) as  'Legal Expense'
, sum(CASE WHEN  ReportSort = '32' THEN IsNull(rpt.total,0) END) as  'AR Interest Expense'
, sum(CASE WHEN  ReportSort = '34' THEN IsNull(rpt.total,0) END) as  'Interest Expense'
, sum(CASE WHEN  ReportSort = '36' THEN IsNull(rpt.total,0) END) as  'Indirect Overhead Expense'
, sum(IsNull(rpt.hours,0)) as  'Hours'
from [SQL2].EmployeeAllocation.dbo.vtbl_PeriodReporting_2011_TEST rpt Left JOIN [SQL2].EmployeeAllocation.dbo.vtbl_ProductGrouping pg ON rpt.code_id = pg.ProductID
Where [Type] = 'Direct' and ProfitCenter = 'Denver'  and Fiscalno like '201110' and ReportGroup <> 'Direct'
Group By pg.Group1, pg.Group2
Order by pg.Group1, pg.Group2
