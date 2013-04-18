-- Step # 1 Loading Indirect Expenses (Donovan, Legal, Personnel, Rent, Overhead, Interest)

-- Run SQL:  
	-- This script corresponds to INDIRECT ALLOCATIONS Step 1 3 a. of the Client P&L Procedures Doc
	Truncate table indirectallocation
	
	
select * from vtbl_LoadWages

-- Step # 2 Loading Salary Expense 

-- Run SQL:  
	-- This script corresponds to SALARY Step 2 1 e. of the Client P&L Procedures Doc
	Truncate table vtbl_LoadWages

	-- This script corresponds to SALARY Step 2 2 a.ii. of the Client P&L Procedures Doc to see if there are new employees
	SELECT     vtbl_LoadWages.ADPID, vtbl_LoadWages.Name, '1' as 'active', vtbl_LoadWages.PayAmount, 
	vtbl_Employee_DefaultInfo.ADPID AS [Default]
	FROM         vtbl_LoadWages LEFT OUTER JOIN
						  vtbl_Employee_DefaultInfo ON vtbl_LoadWages.ADPID = vtbl_Employee_DefaultInfo.ADPID
	WHERE     (vtbl_Employee_DefaultInfo.ADPID IS NULL)


	-- This script corresponds to SALARY Step 2 2 a.iii. of the Client P&L Procedures Doc This will help you get the employee ID for the new employee
	--This script will get the majority of the employees 
	SELECT     vtbl_LoadWages.ADPID
, (Select rtrim(Employee) From SQL1.midwestapp.dbo.PJEMploy Where EMP_Name = vtbl_LoadWages.Name 
	/*OR EMP_Name = REPLACE(vtbl_LoadWages.Name,',','~')*/) as 'ID'
,  vtbl_LoadWages.Name
, '1' as 'active'
, vtbl_LoadWages.PayAmount, 
	vtbl_Employee_DefaultInfo.ADPID AS [Default]
	FROM         vtbl_LoadWages LEFT OUTER JOIN
						  vtbl_Employee_DefaultInfo ON vtbl_LoadWages.ADPID = vtbl_Employee_DefaultInfo.ADPID
	WHERE     (vtbl_Employee_DefaultInfo.ADPID IS NULL)
	
	-- if not you will have to look them up individually by their last name
	Select rtrim(Employee), emp_Name 
	From SQL1.midwestapp.dbo.PJEMploy
	Where EMP_Name like '%oconn%'
	




	-- This script corresponds to SALARY Step 2 2 a.iii. of the Client P&L Procedures Doc if there are any new employees
	--INSERT INTO vtbl_Employee_DefaultInfo (HomeDept) VALUES (value1)
INSERT INTO vtbl_Employee_DefaultInfo (ADPID,UserID,ADPNAme,active) VALUES ('008298','CBALL','Ball,Crystal','1')






-- Once all employees are accounted for run this script SALARY Step 2 2 a.iv.
-- update dates
declare @sPeriod as varchar(6)
declare @bDate as varchar(10)
declare @eDate as varchar(10)

set @sPeriod = '201303'
set @bDate = '3/1/2013'
set @eDate = '3/31/2013'

INSERT INTO Employee_info
                      (ADPID, LocationCode, UserID, UserName, PayAmt, FiscalPeriod, EMAILID, EmailAddr, ADPNAme, active)
SELECT     vtbl_LoadWages.ADPID, vtbl_Employee_DefaultInfo.LocationCode, vtbl_Employee_DefaultInfo.UserID, 
                      vtbl_Employee_DefaultInfo.ADPNAme, vtbl_LoadWages.PayAmount, @sPeriod AS Period, vtbl_Employee_DefaultInfo.EMAILID, 
                      vtbl_Employee_DefaultInfo.EmailAddr, vtbl_Employee_DefaultInfo.ADPNAme AS Name, 'True' AS Active
FROM         vtbl_LoadWages INNER JOIN vtbl_Employee_DefaultInfo ON vtbl_LoadWages.ADPID = vtbl_Employee_DefaultInfo.ADPID





-- UPDATE FOR MONTH BEING RUN !!!!!!!!!!!!!!!!!!
--Step # 3 Script Preparation & Step # 4 Running and Reconciliation

-- UPDATE FOR MONTH BEING RUN !!!!!!!!!!!!!!!!!!
-- Update TransDate for Hours, AR Interest Expense

-- update dates
declare @sPeriod as varchar(6)
declare @bDate as varchar(10)
declare @eDate as varchar(10)

set @sPeriod = '201303'
set @bDate = '3/1/2013'
set @eDate = '3/31/2013'


-- Hours 
Delete From   [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
    (CustId, [Name], codegrp, codegrpdesc, code_ID, descr, PJACCT.acct_type, PJACCT.acct,Total,TTLHrs, fiscalno, employee, SubAccount, Project)
SELECT     Customer.CustId, Customer.Name, xIGProdCode.code_group, PJCODE.code_value_desc, xIGProdCode.code_ID, xIGProdCode.descr, PJACCT.acct_type, PJACCT.acct, '0' AS Total, SUM(PJTRAN.units) AS TTLHrs, 

Case When PJTRAN.Fiscalno > 
	CONVERT(char(4), YEAR(PJTRAN.trans_date)) + CASE WHEN len(CONVERT(varchar, month(PJTRAN.trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(PJTRAN.trans_date)) 
	Then PJTRAN.Fiscalno 
	else CONVERT(char(4), YEAR(PJTRAN.trans_date)) + CASE WHEN len(CONVERT(varchar, month(PJTRAN.trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(PJTRAN.trans_date))
end as TDMonth, 

PJTRAN.employee, PJTRAN.gl_subacct, PJTRAN.project

FROM         SQL1.midwestapp.dbo.PJTRAN AS PJTRAN LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.PJPROJ AS PJPROJ ON PJTRAN.project = PJPROJ.project LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.Customer AS Customer ON PJPROJ.pm_id01 = Customer.CustId LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.xIGProdCode AS xIGProdCode ON PJPROJ.pm_id02 = xIGProdCode.code_ID LEFT OUTER JOIN 
                      SQL1.midwestapp.dbo.PJCODE AS PJCODE ON xIGProdCode.code_group = PJCODE.code_value LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.PJLABHDR AS PJLABHDR ON PJTRAN.employee = PJLABHDR.employee AND 
                      PJTRAN.bill_batch_id = PJLABHDR.docnbr LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.PJACCT AS PJACCT ON PJTRAN.acct = PJACCT.acct
WHERE     ((PJTRAN.trans_date BETWEEN @bDate AND @eDate) OR (PJTRAN.Fiscalno = @sPeriod)) AND (PJTRAN.acct = 'LABOR') AND (PJLABHDR.le_status IN ('A', 'C', 'I', 'P'))
GROUP BY Customer.CustId, Customer.Name, xIGProdCode.code_group, PJCODE.code_value_desc, xIGProdCode.code_ID, xIGProdCode.descr, PJACCT.acct_type, PJACCT.acct, PJTRAN.employee, 
                      PJTRAN.gl_subacct, PJTRAN.project,

Case When PJTRAN.Fiscalno > 
	CONVERT(char(4), YEAR(PJTRAN.trans_date)) + CASE WHEN len(CONVERT(varchar, month(PJTRAN.trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(PJTRAN.trans_date)) 
	Then PJTRAN.Fiscalno 
	else CONVERT(char(4), YEAR(PJTRAN.trans_date)) + CASE WHEN len(CONVERT(varchar, month(PJTRAN.trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(PJTRAN.trans_date))
end  


Delete from [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Where Fiscalno <> @sPeriod

Delete from [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Where CustID not like '1%'



--Revenue
-- DAB 1/25/2012:  Added 1045 to the Where clause for sub to include all New York Revenue
Insert Into [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
	(acct, Total, CustID, Code_ID, fiscalno, employee, ProfitCenter, SubAccount)
Select a.* from
(SELECT    
	Case When gl.Acct between '4000' and '4698' then 'Billings' 
	When gl.Acct = '4699' and gl.CpnyID <> 'MIDWEST'  Then 'EITF'  
	When gl.Acct between '4700' and '4999' then 'COS'
	--Else 'Unclassified'
	end  as acct, 

Sum(gl.CuryCrAmt - gl.CuryDrAmt) AS Amount, 
	PJPROJ.pm_id01 AS CustID, 

	PJPROJ.pm_id02 AS Code_ID,
	@sPeriod as fiscalno, 'user' as Emp, 'MIDWEST' as PCenter, gl.Sub
FROM         SQL1.midwestapp.dbo.PJPROJ RIGHT OUTER JOIN
                      (select * from SQL1.midwestapp.dbo.GLTran where projectID <> '')gl ON PJPROJ.project = gl.ProjectID
Where (Acct between '4000' and '4999') 
	and gl.CpnyID = 'MIDWEST'
	and gl.PerPost = @sPeriod
	and gl.Posted = 'P'
	and gl.LedgerId = 'ACTUAL'
	--and PJPROJ.pm_id01 like '1%'
Group By gl.Acct, PJPROJ.pm_id01, PJPROJ.pm_id02, gl.Sub, gl.CpnyID)a where a.acct is not null



-- Expenses 
INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
    (CustId, [Name], code_ID, descr, acct_type, acct,Total, fiscalno, employee, DirectSalaries, SubAccount)
SELECT     Customer.CustId, Customer.Name, xIGProdCode_1.code_ID, xIGProdCode_1.descr, PJACCT.acct_type, PJACCT.acct, SUM(PJTRAN.amount) AS Total, 
                      PJTRAN.fiscalno, PJTRAN.employee, SUM(PJTRAN.units * Employees.HRLRate) AS DirectSalaries, 
                      PJTRAN.gl_subacct
FROM         SQL1.midwestapp.dbo.PJTRAN AS PJTRAN LEFT OUTER JOIN
                      EmployeeAllocation_MDW.dbo.Employee_info AS Employees ON PJTRAN.employee = Employees.UserID AND 
                      PJTRAN.fiscalno = Employees.FiscalPeriod LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.PJPROJ AS PJPROJ ON PJTRAN.project = PJPROJ.project LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.PJACCT AS PJACCT ON PJTRAN.acct = PJACCT.acct LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.Customer AS Customer ON PJPROJ.pm_id01 = Customer.CustId LEFT OUTER JOIN
                      SQL1.midwestapp.dbo.xIGProdCode AS xIGProdCode_1 ON PJPROJ.pm_id02 = xIGProdCode_1.code_ID
WHERE   (Customer.CustId LIKE '1%') 
	AND (PJACCT.acct_type = 'EX') 
	AND (PJACCT.acct Not In ('APS TRANSFER', 'LABOR', 'APS TRANSFER REV','COS APS', 'NEW BUSINESS', 'OVERHEAD', 'WIP APS', 'WIP CLEARING', 'WIP FREELANCE', 'WIP PRODUCTION', 'WIP SALES TAX', 'WIP TALENT', 'WIP TRAVEL', 'APS SALES', 'PRODUCTION BILL', 'COS PRODUCTION', 'ART BUYING FEES', 'BRDCST FEES'))
	AND (PJTRAN.fiscalno = @sPeriod)
GROUP BY Customer.CustId, Customer.Name, xIGProdCode_1.code_ID, xIGProdCode_1.descr, PJACCT.acct_type, PJACCT.acct, PJTRAN.fiscalno, 
                      PJTRAN.employee, PJTRAN.gl_subacct




Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set TTLHrs = '0'
Where acct <> 'LABOR           '


-- Find all MIDWEST Profit Center GL accounts.  Delete all others as they have their own statements.
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set ProfitCenter = 'APS'
Where SubAccount in ('1090', '1085', '1076', '1031', '1032')

Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set ProfitCenter = 'IPM'
Where SubAccount in ('2700')

Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set ProfitCenter = 'Corporate'
Where SubAccount in ('1052', '1051', '1050')

-- DAB 1/25/2012:  Added 1045 to the subaccount filter so that we include all New York expenses.
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set ProfitCenter = 'MIDWEST'
Where SubAccount in ('1049', '5000', '1096', '1095', '1081', '1080', '1075', '1055', '1042', '1041', '1040', '1030', '1026', '1025', '1021'
, '1020', '1019', '1018', '1017', '1016', '1015', '1014', '1013', '1012', '1010', '1000', '0000', '1045','1100','1105','1110','1115','1120'
,'1125','1130','1135','1140','1145','1150','1155','1160','1165')

Update Period_PL
Set ProfitCenter = 'MIDWEST'
Where ProfitCenter Is Null
	and acct = 'SEA'


Delete from [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Where ProfitCenter <> 'MIDWEST'


-- Identify Direct vs. InDirect Clients for allocation purposes.  (*******Tim Changed Arell's logic to allow for 1TIGGN CustID's to be classified as direct.*********)
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set [Type] = 'Indirect'
Where CustID in ('2MWINT')

Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set [Type] = 'Direct'
Where [type]  Is Null

/*  For DENVER only not related to MIDWEST
-- This was to fix January 2011 SEA expense hitting indirect client code
-- DAB 1/25/2012:  Added ABSO to the code_id list to set that expense to direct
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set [Type] = 'Direct'
Where Acct = 'SEA' and LTRIM(RTRIM(code_id)) in ('GEN', 'INTR', 'ABSO')

Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set [Type] = 'Direct'
Where [type]  Is Null

Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set [Type] = 'Direct'
Where acct = 'Digital Fees'
	AND code_id = 'IGG'
*/


/* Employee Hours by Client/Product
 Clear out table for summary hours.  Could eventually get to a point to only append and keep historical data
 It seems like a triplicate of hours (here, Dynamics, ADP) */
Delete from  [SQLDEV2].EmployeeAllocation_MDW.dbo.Employee_SummaryHours

-- Get total hours entered for each employee by fiscal period.
INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.Employee_SummaryHours (employee, fiscalno, MonthlyHours)
Select Employee, Fiscalno, IsNull(Sum(TTLHrs),0) as Hours
From [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Group by Employee, fiscalno

--Must update sensitive information...Could work from query above but I do not know the code well enough to do it.			

UPDATE    [SQLDEV2].EmployeeAllocation_MDW.dbo.Employee_info
SET              TTLHrs = Employee_SummaryHours.MonthlyHours
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.Employee_info AS Employee_info INNER JOIN
                      [SQLDEV2].EmployeeAllocation_MDW.dbo.Employee_SummaryHours AS Employee_SummaryHours ON Employee_info.UserID = Employee_SummaryHours.Employee AND 
                      Employee_info.FiscalPeriod = Employee_SummaryHours.Fiscalno



/* Getting each employees hourly rate, varies month to month for salried workers.
 Will use this below to calculate direct salaries to client product. */
Update  [SQLDEV2].EmployeeAllocation_MDW.dbo.Employee_Info
Set HrlRate = PayAmt / TTLHrs
Where ttlHrs is not null and ttlhrs <>'0' and FiscalPeriod = @sPeriod

-- Update Direct salaries based on above calculation.
UPDATE    EmployeeAllocation_MDW.dbo.[Period_PL]
SET              DirectSalaries = EmployeeAllocation_MDW.dbo.[Period_PL].TTLHrs * EmployeeAllocation_MDW.dbo.Employee_info.HRLRate
FROM         EmployeeAllocation_MDW.dbo.[Period_PL] INNER JOIN
                      EmployeeAllocation_MDW.dbo.Employee_info ON EmployeeAllocation_MDW.dbo.[Period_PL].employee = EmployeeAllocation_MDW.dbo.Employee_info.UserID AND 
                      EmployeeAllocation_MDW.dbo.[Period_PL].fiscalno = EmployeeAllocation_MDW.dbo.Employee_info.FiscalPeriod

-- Update expenses as negative numbers so summing works, don't have to do revenue - expenses.  For speed only.
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set Total = total *-1
Where acct_type = 'EX'

-- Group Like items.  

Update [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
Set Acct = 'PROJECT FEE'
Where acct = 'MISC PRJCT FEE'



--**********************  Other Compensation wages Comes from CFO's P&L Summarized.  *************************
Insert into [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
	(Type, CustID, Name, Code_ID, Descr, Acct_Type, Acct, total, TTLHrs, Fiscalno,
		Employee, DirectSalaries, SubAccount, ProfitCenter)
Select 	'Indirect', '2MWINT', 'Midwest Internal', 'GEN', 'General Time', 'EX', 'Labor', '0', '0', 
		@sPeriod, 'VarUser', '3193.00', '1017', 'MIDWEST'

--********************** Must run recon for unallocated wages to allocate.  Wages that have no time associated to it. ********************** 
Insert into [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
	(Type, CustID, Name, Code_ID, Descr, Acct_Type, Acct, total, TTLHrs, Fiscalno,
		Employee, DirectSalaries, SubAccount, ProfitCenter)
Select 	'Indirect', '2MWINT', 'Midwest Internal', 'GEN', 'General Time', 'EX', 'Labor', '0', '0', 
		@sPeriod, 'VarUser', '125123.71', '1017', 'MIDWEST'


--**********************  Must run recon for variance to allocate.  Varriance with Wages. ********************** 
Insert into [SQLDEV2].EmployeeAllocation_MDW.dbo.[Period_PL]
	(Type, CustID, Name, Code_ID, Descr, Acct_Type, Acct, total, TTLHrs, Fiscalno,
		Employee, DirectSalaries, SubAccount, ProfitCenter)
Select 	'Indirect', '2MWINT', 'Midwest Internal', 'GEN', 'General Time', 'EX', 'Labor', '0', '0', 
		@sPeriod, 'VarUser', '-8054.42205', '1017', 'MIDWEST' 






/*

-- UnComment to Run for Interactive  
-- Interative allocation for their own P&L

Update [Period_PL]
Set Type = 'Direct', CustID = '1INACT', Name = 'Digital', CodeGrp = 'INA', CodeGrpDesc = 'Digital', Code_ID = 'INA', descr = 'Digital'
where subAccount = '1019' 

Update [Period_PL]
Set Type = 'Direct', CustID = '1INACT', Name = 'Digital', CodeGrp = 'INA', CodeGrpDesc = 'Digital', Code_ID = 'INA', descr = 'Digital'
where acct = 'Digital Fees'

--End Interactive Allcoation


*/

/*  Not needed in the Midwest queries
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
*/

-- Inserts Summary Information into PeriodReporting.

Delete from  [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting

INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
                      ([Type], ReportGroup, CustId, [Name], code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     [Type], 'Direct', CustId, Name, code_ID, descr, acct_type, acct, SUM(Total) AS Total, fiscalno, ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_PeriodReport
GROUP BY Type, CustId, [Name], code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct <> 'LABOR')

INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     Type, 'Direct', CustId, Name, code_ID, descr, acct_type, 'Direct Wages', SUM(TotalWages)*-1 AS Total, fiscalno, ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_PeriodReport
GROUP BY Type, CustId, Name, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct = 'LABOR') 
Order by CustID

INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
		      -- ******************  Edit the tax rate here ********************
SELECT     Type, 'Direct', CustId, Name, code_ID, descr, acct_type, 'Direct Wages Payroll Expenses', SUM(TotalWages*0.1645409896024)*-1 AS Total, fiscalno, ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_PeriodReport
GROUP BY Type, CustId, Name, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct = 'LABOR')


INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     Type, 'Indirect', CustId, Name, code_ID, descr, acct_type, 'Indirect Wages', SUM(indirectportion)*-1 AS Total, fiscalno, ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_PeriodReport
GROUP BY Type, CustId, Name, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct = 'LABOR')


INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
		      -- ******************  Edit the tax rate here ********************
SELECT     Type, 'Indirect', CustId, Name, code_ID, descr, acct_type, 'Indirect Wages Payroll Expenses', SUM(indirectportion*0.1645409896024)*-1 AS Total, fiscalno, ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_PeriodReport
GROUP BY Type, CustId, Name, code_ID, descr, acct_type, acct, fiscalno, ProfitCenter
HAVING      (acct = 'LABOR')

-- Indirect Expenses.  There are both pass through and allocation
--Pass through expenses


INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, '', Group1, product, Descr, 'EX' AS Expr3, 'Direct Rent Expense' AS Expr4, SUM(Amount)*-1 AS TTLRent, 
                      @sPeriod AS Expr5, 'MIDWEST' as ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.IndirectAllocation
GROUP BY Group1, product, Type, Descr
HAVING      (Type = 'Rent') AND (Group1 <> 'Allocate')


INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, '', Group1, product, Descr, 'EX' AS Expr3, 'Direct Personnel' AS Expr4, SUM(Amount)*-1 AS TTLPersonnel, 
                      @sPeriod AS Expr5, 'MIDWEST' as ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.IndirectAllocation
GROUP BY	Product, Type, Group1, Descr
HAVING      (Type = 'Personnel') AND (Group1 <> 'Allocate') 


--Allocation Expenses

INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Indirect Rent Expense' AS Expr4, SUM(Allocation)*-1 AS TTLRent, 
                      @sPeriod AS Expr5, 'MIDWEST' as ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_RentAllocation
GROUP BY  Type, CustId, code_ID, descr, Name
HAVING      (Type = 'Rent')



INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Indirect Personnel Expense' AS Expr4, SUM(Allocation)*-1 AS TTLPersonnel, 
                      @sPeriod AS Expr5, 'MIDWEST' as ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_IndirectAllocation
GROUP BY  Type, CustId, code_ID, descr, Name
HAVING      (Type = 'Personnel')


INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Indirect Overhead Expense' AS Expr4, SUM(Allocation)*-1 AS Overhead, 
                      @sPeriod AS Expr5, 'MIDWEST' as ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_IndirectAllocation
GROUP BY  Type, CustId, code_ID, descr, Name
HAVING      (Type = 'Overhead')



INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Interest Expense' AS Expr4, SUM(Allocation)*-1 AS Interest, 
                      @sPeriod AS Expr5, 'MIDWEST' as ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_Revenue_Allocation
GROUP BY  CustId, code_ID, descr, Name






INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Donovan Expense' AS Expr4, SUM(DonovanAllocation)*-1 AS TTLDonovan, 
                      @sPeriod AS Expr5, 'MIDWEST' as ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_Indirect_DonovanPass
GROUP BY  Type, CustId, code_ID, descr, Name


INSERT INTO [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Legal Expense' AS Expr4, SUM(LegalAllocation)*-1 AS TTLDonovan, 
                      @sPeriod AS Expr5, 'MIDWEST' as ProfitCenter
FROM         [SQLDEV2].EmployeeAllocation_MDW.dbo.vw_Indirect_LegalPass
GROUP BY  Type, CustId, code_ID, descr, Name





-- Start Aged Interest Expense
Delete From wk_Aged
INSERT INTO wk_Aged (CustID, ProjectID, ClientRefNum, JobDescr, ProdCode, RefNbr, DueDate, DocDate, 
						DocType, CuryOrigDocAmt, CuryDocBal, AvgDayToPay, CpnyID, TotalAdjdAmt,
						AdjdRefNbr,AdjgDocType,RecordID,DateAppl, InterestBal, InterestDays, InterestAmt)
SELECT d.CustID, d.ProjectID, ISNULL(p.purchase_order_num, '') as 'ClientRefNum', ISNULL(p.project_desc, '') as 'JobDescr' 
	, ISNULL(p.pm_id02,'') AS 'ProdCode', d.RefNbr, d.DueDate, d.DocDate, d.DocType, 
			CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
			THEN 1 
			ELSE -1 END * d.CuryOrigDocAmt as 'CuryOrigDocAmt', 

			CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
			THEN 1 
			ELSE -1 END * d.CuryDocBal as 'CuryDocBal'
, b.AvgDayToPay, d.CpnyID, 0 AS 'TotalAdjdAmt', '' AS 'AdjdRefNbr', '' AS 'AdjgDocType', 0 AS 'RecordID', '1900/01/01' AS 'DateAppl',
	0 as InterestBal, 0 as InterestDays, 0 as InterestAmt
FROM Sql1.midwestapp.dbo.ARDoc d JOIN sql1.midwestapp.dbo.AR_Balances b ON b.CustID = d.CustID 
     LEFT JOIN Sql1.midwestapp.dbo.PJPROJ p ON d.ProjectID = p.Project
WHERE d.Rlsed = 1 --Released
	and d.BatNbr not in ('802037', '802566')
	
   
UPDATE wk_Aged
SET TotalAdjdAmt = ISNULL(a.TotalAdjdAmt,0), AdjdRefNbr = ISNULL(a.AdjdRefNbr, '')
FROM wk_Aged LEFT JOIN 
	(SELECT AdjdRefNbr, SUM(CuryAdjdAmt) as 'TotalAdjdAmt' 
		FROM Sql1.midwestapp.dbo.ARAdjust
		WHERE DateAppl <= '2/28/2012'
			and adjbatnbr not in ('802037', '802566')
		GROUP BY AdjdRefNbr) a ON wk_Aged.RefNbr = a.AdjdRefNbr

UPDATE wk_Aged
SET AdjgDocType = ISNULL(a.AdjgDocType, ''), RecordID = ISNULL(a.RecordID, 0),
	DateAppl = ISNULL(a.DateAppl, '1900/01/01')
FROM wk_Aged LEFT JOIN sql1.midwestapp.dbo.ARAdjust a on wk_Aged.RefNbr = a.AdjdRefNbr
WHERE a.adjbatnbr not in ('802037', '802566')

UPDATE wk_Aged
SET TotalAdjdAmt = ISNULL(CuryOrigDocAmt - CuryDocBal, 0), AdjgDocType = 'DV' --derived
WHERE AdjdRefNbr = '' 
    AND AdjgDocType = ''
    AND DateAppl = '1900/01/01'
    AND RecordID = 0
    AND CuryOrigDocAmt <> CuryDocBal

Update wk_Aged
Set InterestBal = (CuryOrigDocAmt - TotalAdjdAmt), InterestDays = Datediff(d,DueDate, '1/31/2012')

Update wk_Aged
Set InterestAmt = (.085/365 * InterestDays * InterestBal)
Where InterestBal >0
	and InterestDays >0 


Delete from wk_aged
Where custID not like '1%'


INSERT INTO PeriodReporting
                      (Type, ReportGroup, ReportSort, CustId, Name, CodeGrpDesc, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter, Hours)
SELECT     'Direct' AS Type, 'Expense' AS ReportGroup, '32' AS ReportSort, vw_InterestSummary.CustID, vtbl_ProductGrouping.Group1, 
                      vtbl_ProductGrouping.Group2, vw_InterestSummary.ProdCode, vtbl_ProductGrouping.ProdDescr, 'EX' AS acct_typ, 'AR Interest Expense' AS acct, 
                      ROUND(vw_InterestSummary.Interest * - 1, 2) AS Interest, @sPeriod AS Fiscal, 'MIDWEST' AS Profit, '0' AS Hrs
FROM         vw_InterestSummary LEFT OUTER JOIN vtbl_ProductGrouping ON vw_InterestSummary.ProdCode = vtbl_ProductGrouping.ProductId

-- End Aged Interest Expense


-- Update Report Group and Report Sort for grouping and sorting resons.  Not able to sort by lineitems.
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '1', Acct = 'Billings'
Where Acct = 'Billings'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '3', Acct = 'EITF'
Where Acct = 'EITF'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Revenue', ReportSort = '5', Acct = 'COS'
Where Acct = 'COS'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '11'
Where Acct = 'Direct Wages'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort =  '13'
Where Acct = 'Direct Wages Payroll Expenses'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '15'
Where Acct = 'Indirect Wages'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '17'
Where Acct = 'Indirect Wages Payroll Expenses'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '19'
Where Acct = 'SEA'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '21'
Where Acct = 'Direct Personnel'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '23'
Where Acct = 'Indirect Personnel Expense'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '25'
Where Acct = 'Direct Rent Expense'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '27'
Where Acct = 'Indirect Rent Expense'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '29'
Where Acct = 'Donovan Expense'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '31'
Where Acct = 'Legal Expense'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '32'
Where Acct = 'AR Interest Expense'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '34'
Where Acct = 'Interest Expense'
Update [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting
Set ReportGroup = 'Expense', ReportSort = '36'
Where Acct = 'Indirect Overhead Expense'


-- Update period reporting with total direct hours.  Used for reporting to compare to contracts.
UPDATE    EmployeeAllocation_MDW.dbo.PeriodReporting
SET              Hours = Direct.ProductHours
FROM         EmployeeAllocation_MDW.dbo.vw_Period_ClientProd_Hours AS Direct INNER JOIN
                      EmployeeAllocation_MDW.dbo.PeriodReporting ON Direct.CustId = EmployeeAllocation_MDW.dbo.PeriodReporting.CustId AND 
                      Direct.code_ID = EmployeeAllocation_MDW.dbo.PeriodReporting.code_ID
WHERE     (EmployeeAllocation_MDW.dbo.PeriodReporting.Type = 'direct') AND (EmployeeAllocation_MDW.dbo.PeriodReporting.acct = N'Direct Wages')
		

-- Update for Product Groups.  This was added late in project so I did not reconfig all code as this is relational to the Product, 
UPDATE    EmployeeAllocation_MDW.dbo.PeriodReporting
SET              CodeGrp = xIGProdCode_1.code_group, CodeGrpDesc = PJCode_1.code_value_desc
FROM         SQL1.midwestapp.dbo.PJPROJ AS PJPROJ INNER JOIN
                      EmployeeAllocation_MDW.dbo.PeriodReporting ON PJPROJ.pm_id01 = EmployeeAllocation_MDW.dbo.PeriodReporting.CustId AND 
                      PJPROJ.pm_id02 = EmployeeAllocation_MDW.dbo.PeriodReporting.code_ID INNER JOIN
                      SQL1.midwestapp.dbo.xIGProdCode AS xIGProdCode_1 ON PJPROJ.pm_id02 = xIGProdCode_1.code_ID INNER JOIN
                      SQL1.midwestapp.dbo.PJCode AS PJCode_1 ON xIGProdCode_1.code_group = PJCode_1.code_value



--Display the Report
Select ProfitCenter as [Profit Center], ReportGroup as [Type], ReportSort as Sort, Group1, Group2, Group3, Group4, Group5, Code_id as Product, Descr as [Product Description], acct as [Line Item], total as Amount, Hours 
from [SQLDEV2].EmployeeAllocation_MDW.dbo.PeriodReporting Left JOIN [SQLDEV2].EmployeeAllocation_MDW.dbo.vtbl_ProductGrouping ON PeriodReporting.code_id = vtbl_ProductGrouping.ProductId
Where [Type] = 'Direct' and ProfitCenter = 'MIDWEST' and ReportGroup <> 'Direct'  
Order by Group1, Group2, Group3, Group4, Group5, code_id,   ReportSort,acct




/*
--***********************  Unallocated Wages due to no Hours.  *****************************
-- update dates
declare @sPeriod as varchar(6)

set @sPeriod = '201303'

Select Sum(PayAmt) as wage
from employee_info
where (ttlhrs is null or ttlhrs = '0') and fiscalperiod = @sPeriod
*/
-- info for whom does not have any hrs associated with their wages
--select * from employee_info where (ttlhrs is null or ttlhrs = '0') and fiscalperiod = @sPeriod










--Step # 5  Validate Product Groupings






/* ************************  New Product Codes  **************************

-- Get new product codes
Select custID, Name, CodeGrp, CodeGrpDesc, code_ID, Descr
from PeriodReporting Left Outer Join vtbl_ProductGrouping ON PeriodReporting.Code_id  = vtbl_ProductGrouping.ProductID
Where vtbl_ProductGrouping.ProductID is null
Group by custID, Name, CodeGrp, CodeGrpDesc, code_ID, Descr

-- Shows all of the data in the Product Grouping table
Select *
From vtbl_Productgrouping
Order by productid, Group1, Group2, Group3, Group4, Group5


Select g.*
from SQL1.midwestapp.dbo.xProdJobDefault x JOIN vtbl_ProductGrouping g ON x.Product = g.ProductID
Where custID Like '%'
	and prodDescr like '%Lowes%'
Order by 2, 3, 4

-- gets the product description for adding into the product grouping table
Select descr, code_id,* 
From SQL1.midwestapp.dbo.xIGProdCode
Where code_id = '0215'



--Find Groupings
-- Get class, client, products
select ltrim(rtrim(pc.code_ID)) as ProductID
, ltrim(rtrim(pc.descr)) as ProdDescr
, ltrim(rtrim(c.[Customer Code])) as Group1
, ltrim(rtrim(c.[Code Descr])) as Group2
, ltrim(rtrim(c.CustId)) as Group3
, ltrim(rtrim(c.CustName)) as Group4
, '' as Group5
, CASE WHEN pc.status = 'A' THEN '1' ELSE '0' END as Active
, '' as FTEID
from SQL1.midwestapp.dbo.xProdJobDefault jd 
LEFT OUTER JOIN (select  ltrim(rtrim(a.classid)) as 'Customer Code', ltrim(rtrim(a.descr)) as 'Code Descr', ltrim(rtrim(b.CustId)) as CustId, ltrim(rtrim(b.Name)) as CustName
from SQL1.midwestapp.dbo.CustClass a LEFT OUTER JOIN SQL1.midwestapp.dbo.Customer b ON a.ClassId = b.ClassId
where b.Status = 'A')c ON jd.CustID = c.CustId 
left outer join SQL1.midwestapp.dbo.xIGProdCode pc on jd.Product = pc.code_ID
where pc.status = 'A' and pc.code_ID IN ('0215','0223')
order by c.[Customer Code], c.CustId

               	
-- inset into the producat grouping table
insert into vtbl_Productgrouping (ProductID,ProdDescr,Group1,Group2,Group3,Group4,Group5,Active,FTEID)
	VALUES ('0215'
	, 'LOWES'
	, 'ELECTR'
	, 'ELECTROLUX'
	, '1ELEBR'
	, 'ELECTROLUX BRAND'
	, ''
	, '1'
	, '')
	
insert into vtbl_Productgrouping (ProductID,ProdDescr,Group1,Group2,Group3,Group4,Group5,Active,FTEID)
	VALUES ('0223'
	, 'HON'
	, 'ALL'
	, 'All Classes'
	, '1HON'
	, 'HON'
	, ''
	, '1'
	, '')

*/







--Step # 6 Archive

--FIX Fiscal Periods and Quarter (example "Q1")


/* Archive
-- update dates
declare @sPeriod as varchar(6)

set @sPeriod = '201303'

Delete from vtbl_IndirectAll Where fiscalperiod = @sPeriod
INSERT INTO vtbl_IndirectAll
                      (Type, Group1, Group2, Group3, Group4, Group5, product, Descr, FiscalPeriod, Amount)
SELECT     Type, Group1, Group2, Group3, Group4, Group5, product, Descr, FiscalPeriod, Amount
FROM         IndirectAllocation

Delete from vtbl_PeriodReportingAll  Where fiscalno = @sPeriod
INSERT INTO vtbl_PeriodReportingAll
                      (Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter, ReportSort, Hours, Quarter)
SELECT     Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter, ReportSort, Hours, 'Q4'
FROM         PeriodReporting

Delete from vtbl_Period_PL_All Where fiscalno = @sPeriod
INSERT INTO vtbl_Period_PL_All
                      (Type, CustId, Name, CodeGrp, CodeGrpDesc, code_ID, descr, acct_type, acct, Total, TTLHrs, fiscalno, employee, DirectSalaries, SubAccount, 
                      ProfitCenter)
SELECT     Type, CustId, Name, CodeGrp, CodeGrpDesc, code_ID, descr, acct_type, acct, Total, TTLHrs, fiscalno, employee, DirectSalaries, SubAccount, 
                      ProfitCenter
FROM         Period_PL

*/




select * from vtbl_PeriodReportingAll



--Step # 7 Interactive



--Here we are re-executing the code from Step # 3 after we uncomment the section called "Uncomment to run for interactive".




--Insert for Interactive Run to below
/*
-- update dates
declare @sPeriod as varchar(6)

set @sPeriod = '201303'

Delete from vtbl_PeriodReportingAll_InteractiveLoaded where fiscalno = @sPeriod
INSERT INTO vtbl_PeriodReportingAll_InteractiveLoaded
                      (Type, ReportGroup, ReportSort, CustId, Name, CodeGrp, CodeGrpDesc, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter, Hours)
SELECT     Type, ReportGroup, ReportSort, CustId, Name, CodeGrp, CodeGrpDesc, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter, Hours
FROM         PeriodReporting
WHERE     (CustId = '1INACT')

Delete from vtbl_Period_PL_Interactive Where fiscalno = @sPeriod
INSERT INTO vtbl_Period_PL_Interactive
                      (Type, CustId, Name, CodeGrp, CodeGrpDesc, code_ID, descr, acct_type, acct, Total, TTLHrs, fiscalno, employee, DirectSalaries, SubAccount, 
                      ProfitCenter)
SELECT     Type, CustId, Name, CodeGrp, CodeGrpDesc, code_ID, descr, acct_type, acct, Total, TTLHrs, fiscalno, employee, DirectSalaries, SubAccount, 
                      ProfitCenter
FROM         Period_PL
WHERE     (CustId = '1INACT')



*/





--Step # 8 - Prepare Reports - Final Step can be Multiple Months - Entire year at once




--All Consistant SQl Statement (Inserts $0 records for all product\Line item combination)

Insert into vtbl_PeriodREportingAll
						(Type, ReportGroup, ReportSort, code_Id, descr, fiscalno, acct_type, acct, total, profitcenter, hours, quarter)

Select 'Direct', PV.ReportGroup, PV.ReportSort, PV.ProductID, PV.ProdDescr, PV.Fiscalno, pv.acct_type, pv.acct, '0', 'MIDWEST', '0', PV.Qtr
From ( Select *
from vtbl_FiscalNo fno  Cross JOIN vtbl_LineItems li
	Cross Join vtbl_ProductGrouping pg ) PV LEFT JOIN vtbl_PeriodReportingAll rpt ON PV.Fiscalno = rpt.fiscalno
		and PV.ProductID = rpt.code_id
		and PV.ReportSort = rpt.ReportSort
Where rpt.Code_id is null	




/* Year to date Summary

Select pg.Group1, pg.Group2, pg.Group3, pg.Group4
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
from [SQLDEV2].EmployeeAllocation_MDW.dbo.vtbl_PeriodReportingAll rpt Left JOIN [SQLDEV2].EmployeeAllocation_MDW.dbo.vtbl_ProductGrouping pg ON rpt.code_id = pg.ProductID
Where [Type] = 'Direct' and ProfitCenter = 'MIDWEST'  and Fiscalno like '2013%' and ReportGroup <> 'Direct'
Group By pg.Group1, pg.Group2, pg.Group3, pg.Group4
Order by pg.Group1, pg.Group2, pg.Group3, pg.Group4

*/






/* Interactive Query
--Update Fiscalno for Current year
SELECT     acct, SUM(Total) AS Expr1, SUM(Hours) AS Expr2
FROM         vtbl_PeriodReportingAll_InteractiveLoaded
WHERE     (fiscalno like '2013%')
GROUP BY acct
*/



/*
--Execute this ONLY after you have also run for Interactive.
Delete From IndirectAllocation
Delete From Employee_SummaryHours
Delete From Period_PL
Delete From PeriodReporting

*/

/*
--Pull Hours by Employee.
--Update Fiscalno for current year

SELECT     Group1, Group2, Group3, Group4, Group5,
                      vtbl_Period_PL_All.code_ID AS ProductID, vtbl_Period_PL_All.descr AS ProdDesc, vtbl_Period_PL_All.employee, vtbl_Period_PL_All.SubAccount, 
                      SUM(vtbl_Period_PL_All.TTLHrs) AS TotalHrs, SUM(vtbl_Period_PL_All.DirectSalaries) AS TotalSalaries
FROM         vtbl_Period_PL_All LEFT OUTER JOIN
                      vtbl_ProductGrouping ON vtbl_Period_PL_All.code_ID = vtbl_ProductGrouping.ProductId
WHERE     (vtbl_Period_PL_All.acct = 'LABOR') AND (vtbl_Period_PL_All.fiscalno Like '2013%') and (vtbl_Period_PL_All.type = 'Direct') 
GROUP BY Group1, Group2, Group3, Group4, Group5, vtbl_Period_PL_All.code_ID, 
                      vtbl_Period_PL_All.descr, vtbl_Period_PL_All.employee, vtbl_Period_PL_All.SubAccount

*/




























/*  Quarterly Summary
Select ProfitCenter, ReportGroup, ReportSort, Group1, Group2, Group3, Group4, Group5, Code_id, Descr, acct, Sum(total) as Total, Sum(hours) as Hours, Quarter
from [SQLDEV2].EmployeeAllocation_MDW.dbo.vtbl_PeriodReportingAll JOIN [SQLDEV2].EmployeeAllocation_MDW.dbo.vtbl_ProductGrouping ON vtbl_PeriodReportingAll.code_id = vtbl_ProductGrouping.ProductId
Where [Type] = 'Direct' and ProfitCenter = 'MIDWEST' and Fiscalno in (@sPeriod, @sPeriod, @sPeriod)
Group By ProfitCenter, ReportGroup, ReportSort, Group1, Group2, Group3, Group4, Group5, Code_id, Descr, acct, Quarter
Order by Group1, Group2, Group3, Group4, Group5, code_id,   ReportSort,acct

*/



*/

