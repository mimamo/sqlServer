USE DEN_DEV_APP; 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'AcctLeadershipFjrRpt'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[AcctLeadershipFjrRpt]
GO

CREATE PROCEDURE [dbo].[AcctLeadershipFjrRpt]     
	@company varchar(20),
	@sProject varchar(20) = null,
	@sClientID varchar(30) = null,
	@sClientPO varchar(20) = null,
	@sProductID varchar(20) = null,
	@sPM varchar(10) = null,
	@sStatus varchar(1) = null
	
 AS


/*******************************************************************************************************
*   DEN_DEV_APP.dbo.AcctLeadershipFjrRpt 
*
*   Creator:   
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:	
	
		execute DEN_DEV_APP.dbo.AcctLeadershipFjrRpt @company = 'SHOPPERNY', @sClientId = '1JJVC', @sProductId = 'CUST', @sPM = 'CUST', @sStatus = 'A'
		execute DEN_DEV_APP.dbo.AcctLeadershipFjrRpt @company = 'DENVER'
		

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	01/27/2016	Put query from SSRS into procedure
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
-- For internal reporting use
DECLARE @CurrentDate Date	--Would have been used in used in WIP AGING logic
DECLARE @iYear as int
--DECLARE @iMonth as char(2)
--DECLARE @EndPerNbr as char(6)
SET @CurrentDate = getdate()
SET @iYear = YEAR(@CurrentDate)
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

--Main Querry
SELECT a.* FROM(select Company = 'DENVER',
					Project,
					[Status],
					project_billwith,
					ClientID,
					ClientName,
					ProductID,
					ProductDesc,
					PM,
					AcctService,
					Project_Desc,
					ClientContact,
					ContactEmailAddress,
					ClientRefNo,
					ECD,
					OnShelfDate,
					[Final On-Shelf Date],
					CloseDate,
					OfferNum,
					ULEAmount,
					CLEAmount,
					CLEFeeAmount,
					TRVActuals,
					OOPActuals,
					OpenPO,
					Actuals,
					ActualsToBill = CASE WHEN Actuals - BTD < 0 THEN 0 ELSE Actuals - BTD END,
					BTD,
					WIPOver60Amount,
					ProjectHours,
					ContractType,
					ProjectStatus,
					---, FltContractType
					FltClientPO
				from (select Project = ltrim(rtrim(p.Project)), 
						[Status] = CASE WHEN p.status_pa = 'I' THEN 'INACTIVE' ELSE 'ACTIVE' END,  
						project_billwith = ltrim(rtrim(b.project_billwith)),   
						ClientID = ltrim(rtrim(p.pm_id01)), 
						ClientName = ISNULL(ltrim(rtrim(c.[name])),'Customer Name Unavailable'),  
						ProductID = ltrim(rtrim(p.pm_id02)), 
						ProductDesc = ltrim(rtrim(pc.descr)), 
						PM = ltrim(rtrim(p.manager1)), 
						AcctService = ltrim(rtrim(p.manager2)), 
						Project_Desc = ltrim(rtrim(p.Project_Desc)), 
						ClientContact = ltrim(rtrim(xc.CName)), 
						ContactEmailAddress = ltrim(rtrim(xc.EmailAddress)), 
						ClientRefNo = ltrim(rtrim(p.purchase_order_num)), 
						ECD = ltrim(rtrim(x.pm_id28)), 
						OnShelfDate = ltrim(rtrim(p.end_date)), 
						[Final On-Shelf Date] = CASE WHEN x.pm_id28 = '' THEN p.end_date ELSE ltrim(rtrim(x.pm_id28)) END,
						CloseDate= ltrim(rtrim(p.pm_id08)), 
						OfferNum = ltrim(rtrim(p.pm_id32)), 
						ULEAmount = ISNULL(ULE.ULEAmount, 0), 
						CLEAmount = ISNULL(CLE.CLEAmount, 0), 
						CLEFeeAmount = ISNULL(CLE.CLEFee, 0),
						TRVActuals = ISNULL(TRV.TRAVActuals, 0), 
						OOPActuals = ISNULL(OOP.OOPActuals, 0), 
						OpenPO = ISNULL(FJR.OpenPO, 0), 
						Actuals = ISNULL(FJR.Actuals, 0), 
						BTD = ISNULL(FJR.BTD, 0), 
						WIPOver60Amount = ISNULL(RptWIP.WIPOvr60Amount, 0),   --Period Sensitive being removed
						ProjectHours = ISNULL(ProjectHrs.TTLHrs, 0), 
						ProjectStatus = p.status_pa, 
						-- Filtering fields required when adding logic for all parent child to return when either is pulled.
						FltClientID = ip.pm_id01, 
						FltProductCode = ip.pm_id02, 
						FltProject = ip.project, 
						FltProjectDesc = ip.project_desc, 
						FltProjectStatus = ip.status_pa, 
						FltClientPO = p.purchase_order_num, 
						FltPM = ip.manager1, 
						FltAcctSvc = ip.manager2, 
						FltOfferNum = ip.pm_id32,
						---ip.contract_type as FltContractType,
						ContractType = CASE WHEN p.contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','NYK') THEN 'PROD'
											WHEN p.contract_type = 'TIME' THEN 'TIME'
										  END 
						From  --!!!!!! ALL FILTER CRITERIA MUST BE ON IP AND NOT P OR PARENT CHILD JOBS WILL NOT ALWAYS BE PULLED TOGETHER!!!!!!
							(SELECT * 
							FROM DEN_DEV_APP.dbo.PJPROJ 
							WHERE contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','TIME','NYK')) ip  
						INNER JOIN DEN_DEV_APP.dbo.PJBILL A 
							ON ip.Project = A.Project
						INNER JOIN DEN_DEV_APP.dbo.PJBILL B 
							ON A.project_billwith = B.project_billwith 
  						INNER JOIN DEN_DEV_APP.dbo.PJPROJ p 
  							ON b.project = p.project
  						LEFT OUTER JOIN DEN_DEV_APP.dbo.xIGProdCode pc 
  							ON p.pm_id02 = pc.code_ID
						LEFT OUTER JOIN DEN_DEV_APP.dbo.CUSTOMER c 
							ON p.pm_id01 = C.CustId
						LEFT OUTER JOIN DEN_DEV_APP.dbo.PJPROJEX x 
							ON p.project = x.project
						LEFT JOIN DEN_DEV_APP.dbo.xClientContact xc 
							ON p.user2 = xc.EA_ID
						--FJR query.  To get down to one line for reporting pulling as main source
						LEFT OUTER JOIN (SELECT m.Project,
											OpenPO = ISNULL((Max(m.ExtCost) - Max(m.CostVouched)),0), 
											--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
											Actuals = SUM (CASE WHEN m.AcctGroupCode IN ('WA','WP','CM','FE') THEN
													AmountBF + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15
													ELSE 0  END), 
											--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
											BTD = SUM (CASE WHEN m.ControlCode = 'BTD' OR m.AcctGroupCode = 'PB' THEN
													AmountBF + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15
													ELSE 0  END) 
										From DEN_DEV_APP.dbo.xvr_PA924_Main m 
										Where m.FSYearNum = @iYear 
										Group by m.Project) FJR 
							ON p.project = FJR.Project
							--END FJR query
						--Unlocked Estimate view by project
						LEFT OUTER JOIN DEN_DEV_APP.dbo.xvr_Est_ULE_Project ULE 
							ON p.Project = ULE.Project
						/*(Using Current Locked Estimate view with functions.  Must roll up to project or cartestion joins */
						LEFT OUTER JOIN (Select CLE.Project,
												CLEFee = SUM ( CASE WHEN (FC.code_group = 'FEE' and FC.code_ID <> '00975') THEN CLE.CLEAmount ELSE 0 END),
												CLEAmount = SUM (CLE.CLEAmount)  
										   From DEN_DEV_APP.dbo.xvr_Est_CLE CLE 
										   INNER JOIN DEN_DEV_APP.dbo.xIGFunctionCode FC 
												ON CLE.pjt_entity = FC.code_ID
										   Group by CLE.Project ) CLE ON p.Project = CLE.Project
        LEFT OUTER JOIN /*(Using Travel with functions.  Must roll up to project or cartestion joins */
        -- Get the Travel Actuals
			(SELECT project,
					TRAVActuals = sum(Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15)
				FROM DEN_DEV_APP.dbo.xvr_BU96C_Actuals 
				where [Function] in (select code_ID 
									from DEN_DEV_APP.dbo.xIGFunctionCode 
									where code_group = 'TRAV') 
					and acct = 'Billable'
				group by project) TRV 
					ON p.Project = TRV.Project
		LEFT OUTER JOIN /*(Using Out Of Pocket functions. This is all functions except TRAV and FEE Must roll up to project or cartestion joins */
			(-- Get the Out of Pocket Actuals
				SELECT project,
					OOPActuals = sum(Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15)
				FROM DEN_DEV_APP.dbo.xvr_BU96C_Actuals 
				where [Function] in (select code_ID 
									from DEN_DEV_APP.dbo.xIGFunctionCode 
									where code_group NOT IN ('TRAV','FEE') 
										or code_id = '00975') 
										and acct IN ('Billable','BILLABLE APS','BILLABLE FEES') 
				group by project) OOP 
			ON p.Project = OOP.Project			   
		LEFT OUTER JOIN /*(Logic taken from BI902 and stripped down.  Including aging days for reuse*/	   
			--Per Email, include all WIP transactions.  Leaving in as easy to uncomment if decisions change.
				(SELECT d.project,
					WIPOvr60Amount = SUM(CASE WHEN d.li_type NOT IN ('D', 'A') AND DateDiff(day, d.source_trx_date, GETDATE() /*@CurrentDate*/ ) > 60 THEN d.amount
											ELSE 0
										END) 							
					FROM DEN_DEV_APP.dbo.PJINVDET d 
					LEFT JOIN DEN_DEV_APP.dbo.PJINVHDR h 
						ON d.draft_num = h.draft_num
					INNER JOIN DEN_DEV_APP.dbo.PJPROJ p 
						ON d.project = p.project 
					INNER JOIN DEN_DEV_APP.dbo.PJACCT a 
						ON d.acct = a.acct
					WHERE d.hold_status <> 'PG' 
						AND d.bill_status <> 'B'
						AND a.acct_group_cd NOT IN ('CM', 'FE')
						AND p.project NOT IN (SELECT JobID 
												FROM DEN_DEV_APP.dbo.xWIPAgingException)
						AND (substring(d.acct, 1, 6) <> 'OFFSET' 
								OR d.acct = 'OFFSET PREBILL')
					Group By d.project) RptWIP 
			ON p.Project = RptWip.project
					/*  END WIP QUERY */
		LEFT OUTER JOIN --Time query taken from Client P&L
						(SELECT PJTRAN.project,
							TTLHrs = SUM(PJTRAN.units)  --PJTRAN.units AS Hrs
						FROM DEN_DEV_APP.dbo.PJTRAN PJTRAN 
						WHERE PJTRAN.acct = 'LABOR'
						Group By PJTRAN.Project) ProjectHrs
			ON p.Project = ProjectHrs.Project)b			
--END Time Query
			
--Shopper NY
UNION All

select Company = 'SHOPPERNY',
	Project,
	[Status],
	project_billwith,
	ClientID,
	ClientName,
	ProductID,
	ProductDesc,
	PM,
	AcctService,
	Project_Desc,
	ClientContact,
	ContactEmailAddress,
	ClientRefNo,
	ECD,
	OnShelfDate,
	[Final On-Shelf Date],
	CloseDate,
	OfferNum,
	ULEAmount,
	CLEAmount,
	CLEFeeAmount,
	TRVActuals,
	OOPActuals,
	OpenPO,
	Actuals,
	ActualsToBill = CASE WHEN Actuals - BTD < 0 THEN 0 ELSE Actuals - BTD END,
	BTD,
	WIPOver60Amount,
	ProjectHours,
	ContractType,
	ProjectStatus,
	---FltContractType,
	FltClientPO
from (select Project = ltrim(rtrim(p.Project)), 
		[Status] = CASE WHEN p.status_pa = 'I' THEN 'INACTIVE' ELSE 'ACTIVE' END,  
		project_billwith = ltrim(rtrim(b.project_billwith)),  
		ClientID = ltrim(rtrim(p.pm_id01)), 
		ClientName = ISNULL(ltrim(rtrim(c.[name])),'Customer Name Unavailable'), 
		ProductID = ltrim(rtrim(p.pm_id02)), 
		ProductDesc = ltrim(rtrim(pc.descr)), 
		PM = ltrim(rtrim(p.manager1)), 
		AcctService = ltrim(rtrim(p.manager2)), 
		Project_Desc = ltrim(rtrim(p.Project_Desc)), 
		ClientContact = ltrim(rtrim(xc.CName)), 
		ContactEmailAddress = ltrim(rtrim(xc.EmailAddress)),
		ClientRefNo = ltrim(rtrim(p.purchase_order_num)),
		ECD = ltrim(rtrim(x.pm_id28)), 
		OnShelfDate = ltrim(rtrim(p.end_date)), 
		[Final On-Shelf Date] = CASE WHEN x.pm_id28 = '' THEN p.end_date ELSE ltrim(rtrim(x.pm_id28)) END,
		CloseDate = ltrim(rtrim(p.pm_id08)), 
		OfferNum = ltrim(rtrim(p.pm_id32)), 
		ULEAmount = ISNULL(ULE.ULEAmount, 0), 
		CLEAmount = ISNULL(CLE.CLEAmount, 0), 
		CLEFeeAmount = ISNULL(CLE.CLEFee, 0), 
		TRVActuals = ISNULL(TRV.TRAVActuals, 0), 
		OOPActuals = ISNULL(OOP.OOPActuals, 0), 
		OpenPO = ISNULL(FJR.OpenPO, 0), 
		Actuals = ISNULL(FJR.Actuals, 0),  
		BTD = ISNULL(FJR.BTD, 0), 
		WIPOver60Amount = ISNULL(RptWIP.WIPOvr60Amount, 0),  --Period Sensitive being removed
		ProjectHours = ISNULL(ProjectHrs.TTLHrs, 0), 
		ProjectStatus = p.status_pa, 
		-- Filtering fields required when adding logic for all parent child to return when either is pulled.
		FltClientID = ip.pm_id01, 
		FltProductCode = ip.pm_id02, 
		FltProject = ip.project, 
		FltProjectDesc = ip.project_desc, 
		FltProjectStatus = ip.status_pa, 
		FltClientPO = p.purchase_order_num, 
		FltPM = ip.manager1, 
		FltAcctSvc = ip.manager2,
		FltOfferNum = ip.pm_id32, 
		--- ip.contract_type as FltContractType,
		ContractType = CASE WHEN p.contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','NYK') THEN 'PROD'
							WHEN p.contract_type = 'TIME' THEN 'TIME'
						  END 
	From  --!!!!!! ALL FILTER CRITERIA MUST BE ON IP AND NOT P OR PARENT CHILD JOBS WILL NOT ALWAYS BE PULLED TOGETHER!!!!!!
			(SELECT * 
			FROM SHOPPER_DEV_APP.dbo.PJPROJ 
			WHERE contract_type IN ('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','TIME','NYK')) ip  
		INNER JOIN SHOPPER_DEV_APP.dbo.PJBILL A 
			ON ip.Project = A.Project
        INNER JOIN SHOPPER_DEV_APP.dbo.PJBILL B 
			ON A.project_billwith = B.project_billwith 
  		 JOIN SHOPPER_DEV_APP.dbo.PJPROJ p 
  			ON b.project = p.project
  		 LEFT OUTER JOIN SHOPPER_DEV_APP.dbo.xIGProdCode pc 
  			ON p.pm_id02 = pc.code_ID
		 LEFT OUTER JOIN SHOPPER_DEV_APP.dbo.CUSTOMER c 
			ON p.pm_id01 = C.CustId
		 LEFT OUTER JOIN SHOPPER_DEV_APP.dbo.PJPROJEX x 
			ON p.project = x.project
		 LEFT JOIN SHOPPER_DEV_APP.dbo.xClientContact xc 
			ON p.user2 = xc.EA_ID
		 LEFT OUTER JOIN --FJR query.  To get down to one line for reporting pulling as main source
						(SELECT m.Project,
								OpenPO = ISNULL((Max(m.ExtCost) - Max(m.CostVouched)),0), 
								--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
								Actuals = SUM (CASE WHEN m.AcctGroupCode IN ('WA','WP','CM','FE') THEN
													AmountBF + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15
													ELSE 0  
												END), 
								--Removing month logic as no period sensitivity.  Leaving code in as easy to uncomment.
								BTD = SUM (CASE WHEN m.ControlCode = 'BTD' OR m.AcctGroupCode = 'PB' THEN
												AmountBF + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15
												ELSE 0  
											END) 
							From SHOPPER_DEV_APP.dbo.xvr_PA924_Main m 
							Where m.FSYearNum = @iYear 
							Group by m.Project) FJR 
			ON p.project = FJR.Project
							--END FJR query
		LEFT OUTER JOIN --Unlocked Estimate view by project
			SHOPPER_DEV_APP.dbo.xvr_Est_ULE_Project ULE 
				ON p.Project = ULE.Project
		LEFT OUTER JOIN /*(Using Current Locked Estimate view with functions.  Must roll up to project or cartestion joins */
			(Select CLE.Project,
					CLEFee = SUM(CASE WHEN (FC.code_group = 'FEE' and FC.code_ID <> '00975') THEN CLE.CLEAmount ELSE 0 END),
					CLEAmount = SUM(CLE.CLEAmount) 
			   From SHOPPER_DEV_APP.dbo.xvr_Est_CLE CLE 
			   INNER JOIN SHOPPER_DEV_APP.dbo.xIGFunctionCode FC 
					ON CLE.pjt_entity = FC.code_ID
			   Group by CLE.Project) CLE 
			ON p.Project = CLE.Project
        LEFT OUTER JOIN /*(Using Travel with functions.  Must roll up to project or cartestion joins */
			( -- Get the Travel Actuals
				SELECT project,
					TRAVActuals = sum(Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15)
				FROM SHOPPER_DEV_APP.dbo.xvr_BU96C_Actuals 
				where [Function] in (select code_ID 
									from SHOPPER_DEV_APP.dbo.xIGFunctionCode 
									where code_group = 'TRAV') 
										and acct = 'Billable'
				group by project) TRV 
			ON p.Project = TRV.Project
		LEFT OUTER JOIN /*(Using Out Of Pocket functions. This is all functions except TRAV and FEE Must roll up to project or cartestion joins */
			(-- Get the Out of Pocket Actuals
				SELECT project,
					OOPActuals = sum(Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15)
				FROM SHOPPER_DEV_APP.dbo.xvr_BU96C_Actuals 
				where [Function] in (select code_ID 
									from SHOPPER_DEV_APP.dbo.xIGFunctionCode 
									where code_group NOT IN ('TRAV','FEE') 
										or code_id = '00975') 
					and acct IN ('Billable','BILLABLE APS','BILLABLE FEES') 
				group by project) OOP 
			ON p.Project = OOP.Project			   
		LEFT OUTER JOIN /*(Logic taken from BI902 and stripped down.  Including aging days for reuse*/	   
			--Per Email, include all WIP transactions.  Leaving in as easy to uncomment if decisions change.
				(SELECT d.project,
						WIPOvr60Amount = SUM(CASE WHEN d.li_type NOT IN ('D', 'A') AND DateDiff(day, d.source_trx_date, GETDATE() /*@CurrentDate*/ ) >60 THEN d.amount
												ELSE 0
											END) 						
					FROM SHOPPER_DEV_APP.dbo.PJINVDET d 
					LEFT JOIN SHOPPER_DEV_APP.dbo.PJINVHDR h 
						ON d.draft_num = h.draft_num
					INNER JOIN SHOPPER_DEV_APP.dbo.PJPROJ p 
						ON d.project = p.project 
					INNER JOIN SHOPPER_DEV_APP.dbo.PJACCT a 
						ON d.acct = a.acct
					WHERE d.hold_status <> 'PG' 
						AND d.bill_status <> 'B'
						AND a.acct_group_cd NOT IN ('CM', 'FE')
						AND p.project NOT IN (SELECT JobID 
												FROM SHOPPER_DEV_APP.dbo.xWIPAgingException)
						AND (substring(d.acct, 1, 6) <> 'OFFSET' 
							OR d.acct = 'OFFSET PREBILL')
					Group By d.project) RptWIP 
			ON p.Project = RptWip.project
					/*  END WIP QUERY */
		LEFT OUTER JOIN --Time query taken from Client P&L
						(SELECT PJTRAN.project,
							TTLHrs = SUM(PJTRAN.units) --PJTRAN.units AS Hrs
						FROM SHOPPER_DEV_APP.dbo.PJTRAN PJTRAN 
						WHERE PJTRAN.acct = 'LABOR'
						Group By PJTRAN.Project) ProjectHrs 
			ON p.Project = ProjectHrs.Project) c) a
Where A.project_billwith <> ''
	AND a.Company = @company
	---AND a.FltContractType IN ---('BPRD','FEE','MED','PARN','PDNT','PRNT','PROD','RET','TIME','NYK')
	AND a.project = coalesce(@sProject,a.project) 
	AND a.ClientID = @sClientId
	AND a.FltClientPO = coalesce(@sClientPO,a.FltClientPO)
	AND a.ProductID = @sProductID
	AND a.PM = @sPM
	---AND a.FltContractType IN (@sType)
	AND a.ProjectStatus = @sStatus
group by Company,Project, project_billwith,ClientID,ClientName,ProductID,ProductDesc,PM,a.ActualsToBill,AcctService,Project_Desc,ClientContact,ContactEmailAddress,
	ClientRefNo,ECD,OnShelfDate,[Final On-Shelf Date],CloseDate,OfferNum,ULEAmount,CLEAmount,CLEFeeAmount,TRVActuals,OOPActuals,OpenPO,Actuals,BTD,WIPOver60Amount,---FltContractType,
	FltClientPO,ProjectHours,ContractType,ProjectStatus,[Status]
Order by a.PM, a.ClientID, a.ProductID, a.Project, a.contracttype