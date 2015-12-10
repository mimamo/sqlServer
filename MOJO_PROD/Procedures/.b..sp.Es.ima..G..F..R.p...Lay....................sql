USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetForReportLayout]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetForReportLayout]
	@EstimateKey int
AS

/*
|| When      Who Rel      What
|| 3/25/10   CRG 10.5.2.0 Created for new Estimate report from the Layout Designer
||                        Most logic copied from sptEstimateReportHeader
|| 4/7/10    CRG 10.5.2.1 Removed extra query for expenses because that is now being called from its own SP.
|| 4/14/10   CRG 10.5.2.1 Fixed duplicate LaborGross problem between header and detail.
||                        Also fixed service type query to get the TotalGross from LaborGross.
|| 4/23/10   CRG 10.5.2.2 Added join out to custom field temp tables that are created and populated in VB before this SP is run.
|| 6/24/10   MFT 10.5.3.1 Added EstimateTotal & DisplayOption
|| 08/05/10  MFT 10.5.3.3 Removed ISNULL from LaborHours, LaborGross and TotalGross
|| 08/10/10  MFT 10.5.3.3 Removed @ContingencyAmount calculation (same as ContingencyTotal in tEstimate)
||                        Added InternalDueDate, ExternalDueDate, WebSite
||                        Added GrandTotal, TotalWithSalesTax, TotalWithSalesTax1 calculations
|| 08/11/10  MFT 10.5.3.3 Added UPDATE to #tEstDetail when @GetDataBy = @BY_TASK to display all tTask lines
|| 08/17/10  MFT 10.5.3.4 Added dummy row as a header row for expenses on reports that print by service
|| 09/01/10  MFT 10.5.3.4 Added LaborHours & LaborGross on the initial @BY_TASK get
|| 09/02/10  MFT 10.5.3.4 Added Description to the line
|| 09/14/10  MFT 10.5.3.5 Added final sort order for BY_SERVICE and tWorkType, restricted BY_SERVICE "dummy" row to detail breakouts
|| 09/29/10  MFT 10.5.3.5 Changed Task/Service type to get BY_SERVICE no matter which line type is selected (91004)
|| 11/14/10  MFT 10.5.3.8 Fixing bug created by previous change. Line format is again respected, but with a LEFT JOIN to tEstimateTask when doing initial task inserts
|| 11/24/10  MFT 10.5.3.8 Changed text fields in #tEstDetail to varchar for MSSQL 2000 compatibility
|| 12/01/10  MFT 10.5.3.9 Added TotalSalesTax field
|| 01/17/11  MFT 10.5.4.0 Fixed Taxable display (*)
|| 02/16/11  MFT 10.5.4.1 Fixed LayoutOrder (added Layout key to sort order UPDATE statement), Removed dummy row on service estimates in favor of item lines, Added DisplayOption to By Service estimate
|| 04/25/11  MFT 10.5.4.2 Set DisplayOption for Campaign Estimates root level lines, removed GROUP BY clause and INNER JOIN to tTask in tItem insert for BY_SERVICE get
|| 04/26/11  MFT 10.5.4.2 Added fields LaborUnitRate, HoursQuantity to support items and services in the same dataset
|| 05/02/11  MFT 10.5.4.2 Changed join from INNER to LEFT on the tItem get in the BY_SERVICE section to accomodate project estimates as well as campaign
||                          Added(!) Taxable display (*) in BY_SERVICE section
|| 06/01/11  MFT 10.5.4.4 Added tService get for BY_TASK estimates, added ProfitGross, ProfitGrossPercent, ProfitNet, ProfitNetPercent, ProjectedHourlyMargin, ProjectedHourlyRate
|| 06/03/11  MFT 10.5.4.4 Changed DisplayOption in BY_TASK estimates to respect the Layout setting
|| 06/07/11  MFT 10.5.4.4 Added ExpenseGross field to #tEstDetail, changed ExpenseGross to ExpenseGrossHeader in #tEstHeader, made TotalGross = ExpenseGross + LaborGross in BY_TASK estimates
|| 06/07/11  GHL 10.5.4.5 Added logic for company address from the GL company
|| 06/08/11  GHL 10.5.4.5 Added CompanyName/Phone/Fax from Company OR GL Company 
|| 06/16/11  GHL 10.5.4.5 (111334) Getting now line format from tLayout.EstLineFormat vs tEstimate.LineFormat
|| 08/22/11  MFT 10.5.4.7 Created ExpenseItem (bit) column to flag rows to be hidden when an expense breakout is used. Added a GROUP BY for expense items.
|| 08/25/11  MFT 10.5.4.7 Removed TaskID from the Subject field (per Mike Wang) (119858)
|| 09/27/11  MFT 10.5.4.8 Added expense quatities, rates and totals for By Service estimates (122138)
|| 11/07/11  MFT 10.5.4.9 Altered @TaskDetailOption in @BY_TASK get
|| 11/08/11  MFT 10.5.4.9 Set TotalGross (in By Task) to NULL on SummaryLines that are 0 and LaborGross + ExpenseGross on all lines;Altered @TaskDetailOption in @BY_TASK get
|| 12/20/11  MFT 10.5.5.1 Added TaskID to By Task gets
|| 02/14/12  MFT 10.5.5.2 Added BillingContactEmail
|| 02/16/12  GHL 10.5.5.3 (134167) calc labor as sum(round(hours * rate))
|| 07/10/12  GHL 10.5.5.8 (148091) Added BillingName
|| 07/19/12  MFT 10.5.5.8 Joined vUserName to KeyPeople1-6
|| 08/16/12  MFT 10.5.5.8 Corrected vUserName joins (all using same table alias)
|| 09/07/12  MFT 10.5.5.9 (153604) In @BY_SERVICE insert, added join back to tLayoutBilling to remove WorkType parents that have no children
|| 09/20/12  MFT 10.5.6.0 Fixed missing alias in new query from above (153604)
|| 09/21/12  GHL 10.5.6.0 (154037) When displaying by Task, capture the case when tEstimateTaskExpense.TaskKey = null
||                        Also corrected reading of tEstimateTaskTemp for opportunities
|| 09/25/12  MFT 10.5.6.0 Added ClientDivisionName and ClientProductName
|| 09/28/12  MFT 10.5.6.0 Populated HoursQuantity (same as LaborHours) for @BY_TASK so it will work in either type
|| 10/31/12  MFT 10.5.6.1 Set the #tEstHeader tCampain join to the tProject.CampaignKey if the tEstmate.CampaignKey is NULL
|| 11/07/12  MFT 10.5.6.1 Defaulted @LineFormat to 1 even when reported as 0 - there is no 0, but sometimes is saved as 0 instead of NULL
|| 11/18/12  MFT 10.5.6.2 Altered DisplayOption in @BY_TASK get (non-Lead, All Tasks set to 2), Suppressed TaskType=1 0 values rather than SummaryTaskKey=0
|| 04/17/13  MFT 10.5.6.6 Altered @TaskDetailOption CASE statement in @BY_TASK get for Opportunities to match Projects
|| 11/01/13  MFT 10.5.7.3 Set LaborHours and LaborRate (in @BY_TASK query) to NULL on SummaryLines when 0
|| 08/01/14  WDF 10.5.8.3 (224360) Added EnteredByName
|| 11/14/14  MFT 10.5.8.6 Added Billing Title queries
|| 12/16/14  MFT 10.5.8.6 Fixed DECLARE defaults
|| 02/04/15  MFT 10.5.8.8 Changed UnitCost to UnitRate in all SELECT statements
|| 04/08/15  MFT 10.5.9.1 Changed Billing Title queries: removed tLayoutBilling references; Added Segment and Service/Title queries
*/

	DECLARE
		@EstType int,
		@ApprovedQty smallint,
		@LeadKey int,
		@CampaignKey int,
		@ProjectKey int,
		@ParentEntity varchar(50),
		@ParentEntityKey int,
		@LayoutKey int,
		@TaskDetailOption int,
		@LineFormat smallint,
		@GetDataBy smallint,
		@BY_TASK smallint,
		@BY_SERVICE smallint,
		@BY_SERVICE_AND_BILLING_TITLE smallint,
		@BY_BILLING_TITLE smallint,
		@BY_BILLING_TITLE_AND_SERVICE smallint,
		@BY_PROJECT smallint,
		@BY_SEGMENT_AND_SERVICE smallint,
		@BY_SEGMENT_AND_TITLE smallint,
		@FinalOrder int,
		@SortOrder int,
		@SortOrder2 int,
		@Entity varchar(50),
		@EntityKey int,
		@EstDetailKey int,
		@MaxIndentLevel int

	SELECT
		@EstType = EstType,
		@ApprovedQty = ApprovedQty,
		@LineFormat = CASE ISNULL(EstLineFormat, 1) WHEN 0 THEN 1 ELSE ISNULL(EstLineFormat, 1) END, -- default by task
		@LeadKey = LeadKey,
		@CampaignKey = CampaignKey,
		@ProjectKey = ProjectKey,
		@LayoutKey = e.LayoutKey,
		@TaskDetailOption = TaskDetailOption,
		@BY_TASK = 1,
		@BY_SERVICE = 2,
		@BY_SERVICE_AND_BILLING_TITLE = 3,
		@BY_BILLING_TITLE = 4,
		@BY_BILLING_TITLE_AND_SERVICE = 5,
		@BY_PROJECT = 6,
		@BY_SEGMENT_AND_SERVICE = 7,
		@BY_SEGMENT_AND_TITLE = 8
	FROM
		tEstimate e (nolock)
		INNER JOIN tLayout l (nolock) ON e.LayoutKey = l.LayoutKey
	WHERE	EstimateKey = @EstimateKey

	IF ISNULL(@LeadKey, 0) > 0
	BEGIN
		SELECT @ParentEntity = 'tLead'
		SELECT @ParentEntityKey = @LeadKey
	END

	IF ISNULL(@CampaignKey, 0) > 0
	BEGIN
		SELECT @ParentEntity = 'tCampaign'
		SELECT @ParentEntityKey = @CampaignKey
	END

	IF ISNULL(@ProjectKey, 0) > 0
	BEGIN
		SELECT @ParentEntity = 'tProject'
		SELECT @ParentEntityKey = @ProjectKey
	END

	SELECT
		e.EstimateKey,
		e.EstType,
		e.LineFormat,
		e.CompanyKey,
		e.ChangeOrder,
		e.EstimateName,
		e.EstimateNumber,
		e.Revision,
		e.DeliveryDate,
		e.EstimateDate,
		eb.UserName AS EnteredByName,
		ia.UserName AS InternalApprover,
		ea.UserName AS ExternalApprover,
		e.EstDescription,
		e.SalesTaxKey,
		e.SalesTaxAmount AS SalesTax1Amount,
		st.Description AS SalesTax1Name,
		st.TaxRate As TaxRate,
		e.SalesTax2Amount,
		e.SalesTax2Key,
		st2.Description AS SalesTax2Name,
		st2.TaxRate AS Tax2Rate,
		e.Hours,
		e.LaborNet,
		e.LaborGross AS LaborGrossHeader,
		e.ExpenseGross AS ExpenseGrossHeader,
		e.ExpenseNet,
		e.ContingencyTotal,
		e.TaxableTotal,
		e.EstimateTotal,
		e.InternalDueDate,
		e.ExternalDueDate,
		e.EstimateTotal - e.ExpenseNet As ProfitGross,
		e.EstimateTotal - e.ExpenseNet - e.LaborNet As ProfitNet,
		CASE WHEN ISNULL(e.EstimateTotal, 0) = 0 THEN 0
			ELSE ((e.EstimateTotal - e.ExpenseNet) * 100) / e.EstimateTotal END AS ProfitGrossPercent,
		CASE WHEN ISNULL(e.EstimateTotal, 0) = 0 THEN 0
			ELSE ((e.EstimateTotal - e.ExpenseNet - e.LaborNet) * 100) / e.EstimateTotal END AS ProfitNetPercent,
		CASE WHEN ISNULL(e.Hours,0) = 0 THEN 0
			ELSE (e.EstimateTotal - e.ExpenseNet - e.LaborNet) / e.Hours END AS ProjectedHourlyMargin,
		CASE WHEN ISNULL(e.Hours,0) = 0 THEN 0
			ELSE e.LaborGross / e.Hours END AS ProjectedHourlyRate,
		ISNULL(e.SalesTaxAmount, 0) + ISNULL(e.SalesTax2Amount, 0) AS TotalSalesTax,
		ISNULL(e.EstimateTotal, 0) + ISNULL(e.SalesTaxAmount, 0) AS TotalWithSalesTax1,
		ISNULL(e.EstimateTotal, 0) + ISNULL(e.SalesTaxAmount, 0) + ISNULL(e.SalesTax2Amount, 0) AS TotalWithSalesTax,
		ISNULL(e.EstimateTotal, 0) + ISNULL(e.SalesTaxAmount, 0) + ISNULL(e.SalesTax2Amount, 0) + ISNULL(e.ContingencyTotal, 0) AS GrandTotal,

		-- Billing Address 1) On Invoice, 2) on Client Billing Address, 3) on Client Default Address
		CASE
			WHEN e.AddressKey IS NOT NULL THEN ae.Address1
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN abc.Address1 ELSE adc.Address1 END
		END AS ClientAddress1,
		CASE
			WHEN e.AddressKey IS NOT NULL THEN ae.Address2
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN abc.Address2 ELSE adc.Address2 END
		END AS ClientAddress2,
		CASE
			WHEN e.AddressKey IS NOT NULL THEN ae.Address3
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN abc.Address3 ELSE adc.Address3 END
		END AS ClientAddress3,
		CASE
			WHEN e.AddressKey IS NOT NULL THEN ae.City
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN abc.City ELSE adc.City END
		END AS ClientCity,
		CASE
			WHEN e.AddressKey IS NOT NULL THEN ae.State
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN abc.State ELSE adc.State END
		END AS ClientState,
		CASE
			WHEN e.AddressKey IS NOT NULL THEN ae.PostalCode
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN abc.PostalCode ELSE adc.PostalCode END
		END AS ClientPostalCode,
		CASE
			WHEN e.AddressKey IS NOT NULL THEN ae.Country
			ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN abc.Country ELSE adc.Country END
		END AS ClientCountry,

		case when gl.GLCompanyKey is not null then gl.PrintedName else c1.CompanyName end as CompanyName,
		case when gl.GLCompanyKey is not null then gl.Phone else c1.Phone end as Phone,
		case when gl.GLCompanyKey is not null then gl.Fax else c1.Fax end as Fax,
		c1.WebSite,

		-- Company Address 1) on GLCompany 2) Default Address on Company
		case when glca.AddressKey IS NOT NULL THEN glca.Address1 ELSE ac1.Address1 END AS Address1,
		case when glca.AddressKey IS NOT NULL THEN glca.Address2 ELSE ac1.Address2 END AS Address2,
		case when glca.AddressKey IS NOT NULL THEN glca.Address3 ELSE ac1.Address3 END AS Address3,
		case when glca.AddressKey IS NOT NULL THEN glca.City ELSE ac1.City END AS City,
		case when glca.AddressKey IS NOT NULL THEN glca.State ELSE ac1.State END AS State,
		case when glca.AddressKey IS NOT NULL THEN glca.PostalCode ELSE ac1.PostalCode END AS PostalCode,
		case when glca.AddressKey IS NOT NULL THEN glca.Country ELSE ac1.Country END AS Country,

		--Project fields
		p.ProjectKey,
		p.ProjectName,
		p.ProjectNumber,
		p.Description AS ProjectDescription,
		c.CustomerID,
		ISNULL(c.BillingName, c.CompanyName) AS ClientName,
		CASE
			WHEN e.PrimaryContactKey IS NOT NULL THEN ue.UserName
			ELSE up.UserName
		END AS BillingContact,
		CASE
			WHEN e.PrimaryContactKey IS NOT NULL THEN ue.Email
			ELSE up.Email
		END AS BillingContactEmail,
		pc.CompanyName AS ParentCompanyName,
		p.ClientProjectNumber,
		o.OfficeID,
		o.OfficeName,
		pam.UserName AS ProjectAccountManager,
		kp1.UserName AS KeyPeople1,
		kp2.UserName AS KeyPeople2,
		kp3.UserName AS KeyPeople3,
		kp4.UserName AS KeyPeople4,
		kp5.UserName AS KeyPeople5,
		kp6.UserName AS KeyPeople6,
		r.RequestID,
		p.ClientNotes,
		gl.GLCompanyName,
		cl.ClassName,
		p.StartDate AS ProjectStartDate,
		p.CompleteDate AS ProjectCompleteDate,
		p.CustomFieldKey AS HeaderCustomFieldKey,
		pt.ProjectTypeName,

		--Campaign fields
		camp.CampaignID,
		camp.CampaignName,
		camp.Description AS CampaignDescription,
		camp.Objective,
		camp.StartDate AS CampaignStartDate,
		camp.EndDate AS CampaignEndDate,
		cam.UserName AS CampaignAccountManager
	INTO	#tEstHeader
	FROM	tEstimate e (nolock)
		INNER JOIN vEstimateClient vc (nolock) ON e.EstimateKey = vc.EstimateKey
		INNER JOIN tCompany c1 (nolock) ON e.CompanyKey = c1.CompanyKey
		LEFT JOIN tCompany c (nolock) ON vc.ClientKey = c.CompanyKey
		LEFT JOIN tProject p (nolock) ON e.ProjectKey = p.ProjectKey
		LEFT JOIN tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey
		LEFT JOIN vUserName up (nolock) ON up.UserKey = p.BillingContact
		LEFT JOIN vUserName ue (nolock) ON ue.UserKey = e.PrimaryContactKey
		LEFT JOIN vUserName eb (nolock) ON eb.UserKey = e.EnteredBy
		LEFT JOIN tCompany pc (nolock) ON c.ParentCompanyKey = pc.CompanyKey
		LEFT JOIN tOffice o (nolock) ON p.OfficeKey = o.OfficeKey
		LEFT JOIN vUserName pam (nolock) ON p.AccountManager = pam.UserKey
		LEFT JOIN tRequest r (nolock) ON p.RequestKey = r.RequestKey
		LEFT JOIN tGLCompany gl (nolock) ON p.GLCompanyKey = gl.GLCompanyKey
		LEFT JOIN tClass cl (nolock) ON p.ClassKey = cl.ClassKey
		LEFT JOIN tCampaign camp (nolock) ON ISNULL(e.CampaignKey, p.CampaignKey) = camp.CampaignKey
		LEFT JOIN vUserName cam (nolock) ON camp.AEKey = cam.UserKey
		LEFT JOIN vUserName ia (nolock) ON e.InternalApprover = ia.UserKey
		LEFT JOIN vUserName ea (nolock) ON e.ExternalApprover = ea.UserKey
		LEFT JOIN tSalesTax st (nolock) ON e.SalesTaxKey = st.SalesTaxKey
		LEFT JOIN tSalesTax st2 (nolock) ON e.SalesTax2Key = st2.SalesTaxKey
		LEFT JOIN tAddress ae (nolock) ON e.AddressKey = ae.AddressKey
		LEFT JOIN tAddress abc (nolock) ON c.BillingAddressKey = abc.AddressKey
		LEFT JOIN tAddress adc (nolock) ON c.DefaultAddressKey = adc.AddressKey
		LEFT JOIN tAddress ac1 (nolock) ON c1.DefaultAddressKey = ac1.AddressKey
		LEFT JOIN tAddress glca (nolock) ON gl.AddressKey = glca.AddressKey
		LEFT JOIN vUserName kp1 (nolock) ON kp1.UserKey = p.KeyPeople1
		LEFT JOIN vUserName kp2 (nolock) ON kp2.UserKey = p.KeyPeople2
		LEFT JOIN vUserName kp3 (nolock) ON kp3.UserKey = p.KeyPeople3
		LEFT JOIN vUserName kp4 (nolock) ON kp4.UserKey = p.KeyPeople4
		LEFT JOIN vUserName kp5 (nolock) ON kp5.UserKey = p.KeyPeople5
		LEFT JOIN vUserName kp6 (nolock) ON kp6.UserKey = p.KeyPeople6
	WHERE	e.EstimateKey = @EstimateKey

	CREATE TABLE #tEstDetail
		(EstDetailKey int NOT NULL
			IDENTITY(1, 1) PRIMARY KEY,
		Entity varchar(50) NULL,
		EntityKey int NULL,
		ExpenseItem bit NOT NULL
			DEFAULT(0),
		Subject varchar(500) NULL,
		Description varchar(6000) NULL,
		TaskID varchar(30) NULL,
		ClientDivisionName varchar(300),
		ClientProductName varchar(300),
		IndentLevel int NULL,
		SummaryTaskKey int NULL,
		CampaignSegmentKey int NULL,
		WorkTypeKey int NULL,
		ServiceKey int NULL,
		TitleKey int NULL,
		HoursQuantity decimal(24, 4) NULL,
		LaborUnitRate money NULL,
		LaborHours decimal(24,4) NULL,
		LaborGross money NULL,
		LaborRate money NULL,
		ItemQty decimal(24,4) NULL,
		ItemUnitRate money NULL,
		ExpenseGross money NULL,
		TotalGross money NULL,
		Taxable1 varchar(1) NULL,
		Taxable2 varchar(1) NULL,
		SortOrder int NULL,
		FinalOrder int NULL,
		KeepRow tinyint NULL,
		Bold tinyint NULL,
		DisplayOption smallint NULL,
		TaskType int NULL)

		IF @EstType = 1 --By Task
			SELECT @GetDataBy = @BY_TASK
		ELSE IF @EstType = 2 --By Task/Service
			SELECT @GetDataBy = @LineFormat
		ELSE IF @EstType = 3 -- By Task/Person
			SELECT @GetDataBy = @BY_TASK 
		ELSE IF @EstType = 6 -- By Project
			SELECT @GetDataBy = @BY_PROJECT
		ELSE IF @EstType = 7 -- By Title
			SELECT @GetDataBy = @BY_BILLING_TITLE
		ELSE IF @EstType = 8 -- By Segment and Title
			SELECT @GetDataBy = @BY_SEGMENT_AND_TITLE
		ELSE IF @EstType = 5 -- By Segment and Service
			SELECT @GetDataBy = @BY_SEGMENT_AND_SERVICE
		ELSE --4=Service,5=Segment/Service
			SELECT @GetDataBy = @BY_SERVICE

------------------------------------------------------------------------
	IF @GetDataBy = @BY_TASK
	BEGIN
		--From: sptEstimateReportTasks
		IF EXISTS(
				SELECT	NULL
				FROM	tEstimateTaskTemp (nolock)
				WHERE	Entity = 'tLead'
				AND		EntityKey = @LeadKey)
		BEGIN
			-- query tEstimateTaskTemp to get the task structure
			-- it is saved there because the project on opportunities are just templates and can vary over time
			INSERT	#tEstDetail
					(Entity,
					EntityKey,
					SummaryTaskKey,
					Subject,
					Description,
					TaskID,
					ClientDivisionName,
					ClientProductName,
					IndentLevel,
					SortOrder,
					Bold,
					DisplayOption,
					LaborHours,
					HoursQuantity,
					LaborGross,
					Taxable1,
					Taxable2,
					TaskType)
			SELECT DISTINCT
					'tTask',
					ett.TaskKey,
					ett.SummaryTaskKey,
					ISNULL(ett.TaskName, ''),
					ett.Description,
					ISNULL(ett.TaskID, ''),
					DivisionName,
					ProductName,
					ett.TaskLevel,
					ett.ProjectOrder,
					CASE ett.TaskType
						WHEN 1 THEN 1
						ELSE 0
					END,
					CASE @TaskDetailOption
						WHEN 0 THEN 1
						WHEN 1 THEN
							CASE ett.TaskType
								WHEN 1 THEN 1
								ELSE 2
							END
						ELSE 2
					END,
					et.Hours,
					et.Hours,
					et.EstLabor,
					CASE ett.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
					CASE ett.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2,
					TaskType
			FROM
				tEstimateTaskTemp ett (nolock)
				LEFT JOIN tEstimateTask et (nolock) ON ett.TaskKey = et.TaskKey AND et.EstimateKey = @EstimateKey
			LEFT JOIN tProject p (nolock) ON ett.ProjectKey = p.ProjectKey
			LEFT JOIN tClientDivision cd (nolock) ON p.ClientDivisionKey = cd.ClientDivisionKey
			LEFT JOIN tClientProduct cp (nolock) ON p.ClientProductKey = cp.ClientProductKey
			WHERE	ett.Entity = 'tLead'
			AND		ett.EntityKey = @LeadKey

		END
		ELSE
		BEGIN
			INSERT	#tEstDetail
					(Entity,
					EntityKey,
					SummaryTaskKey,
					Subject,
					Description,
					TaskID,
					ClientDivisionName,
					ClientProductName,
					IndentLevel,
					SortOrder,
					Bold,
					DisplayOption,
					LaborHours,
					HoursQuantity,
					LaborGross,
					Taxable1,
					Taxable2,
					TaskType)
			SELECT DISTINCT
					'tTask',
					t.TaskKey,
					t.SummaryTaskKey,
					ISNULL(t.TaskName, ''),
					t.Description,
					ISNULL(TaskID, ''),
					DivisionName,
					ProductName,
					t.TaskLevel,
					t.ProjectOrder,
					CASE t.TaskType
						WHEN 1 THEN 1
						ELSE 0
					END,
					CASE @TaskDetailOption
						WHEN 0 THEN 1
						WHEN 1 THEN
							CASE t.TaskType
								WHEN 1 THEN 1
								ELSE 2
							END
						ELSE 2
					END,
					et.Hours,
					et.Hours,
					et.EstLabor,
					CASE Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
					CASE Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2,
					TaskType
			FROM
				tTask t (nolock)
				LEFT JOIN tEstimateTask et (nolock) ON t.TaskKey = et.TaskKey AND et.EstimateKey = @EstimateKey
				LEFT JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
				LEFT JOIN tClientDivision cd (nolock) ON p.ClientDivisionKey = cd.ClientDivisionKey
				LEFT JOIN tClientProduct cp (nolock) ON p.ClientProductKey = cp.ClientProductKey
			WHERE	t.ProjectKey = @ProjectKey
		END

		-- Only if we have an expense without task
		IF EXISTS (SELECT 1 FROM tEstimateTaskExpense (nolock) WHERE EstimateKey = @EstimateKey
					AND ISNULL(TaskKey, 0) = 0)
			INSERT	#tEstDetail
				(Entity,
				EntityKey,
				SummaryTaskKey,
				Subject,
				Description,
				TaskID,
				IndentLevel,
				SortOrder,
				FinalOrder,
				Bold,
				DisplayOption,
				Taxable1,
				Taxable2) 
			-- SortOrder = -2 so that we do not interfere with logic below on tasks 
			-- FinalOrder = 9999 so that it will be at the bottom in the final query
			-- TaskKey = 0 for now because we need ExpenseGross, but we will change that
			VALUES ('tTask', 0, 0, 'No Task', '', '', 0, -2, 9999, 0,0,NULL, NULL)

		--Labor/Item expense calc
		UPDATE	#tEstDetail
		SET			LaborHours = ISNULL(LaborHours, 0) + ISNULL((SELECT SUM(Hours) FROM tEstimateTaskLabor (nolock) WHERE EstimateKey = @EstimateKey AND TaskKey = #tEstDetail.EntityKey), 0),
						HoursQuantity = ISNULL(LaborHours, 0) + ISNULL((SELECT SUM(Hours) FROM tEstimateTaskLabor (nolock) WHERE EstimateKey = @EstimateKey AND TaskKey = #tEstDetail.EntityKey), 0),
						LaborGross = ISNULL(LaborGross, 0) + ISNULL((SELECT SUM(ROUND(Hours * Rate,2)) FROM tEstimateTaskLabor (nolock) WHERE EstimateKey = @EstimateKey AND TaskKey = #tEstDetail.EntityKey), 0),
						ExpenseGross = ISNULL(ExpenseGross, 0) + 
							ISNULL((SELECT SUM(CASE
											WHEN @ApprovedQty = 1 THEN BillableCost
											WHEN @ApprovedQty = 2 THEN BillableCost2
											WHEN @ApprovedQty = 3 THEN BillableCost3
											WHEN @ApprovedQty = 4 THEN BillableCost4
											WHEN @ApprovedQty = 5 THEN BillableCost5
											WHEN @ApprovedQty = 6 THEN BillableCost6
											END)
										FROM tEstimateTaskExpense (nolock)
										WHERE
											EstimateKey = @EstimateKey AND
											-- take ISNULL(TaskKey, 0) to capture expenses with no taxes
											ISNULL(TaskKey, 0) = #tEstDetail.EntityKey), 0)

		-- now change the TaskKey and SummaryTaskKey for the No Task row, to bypass task logic below
		UPDATE #tEstDetail
		SET    EntityKey = -1, SummaryTaskKey = -1
		WHERE  EntityKey = 0 -- No Task row 

		UPDATE #tEstDetail
		SET
			TotalGross = ISNULL(LaborGross, 0) + ISNULL(ExpenseGross, 0)

		UPDATE #tEstDetail
		SET
			LaborGross = CASE LaborGross WHEN 0 THEN NULL ELSE LaborGross END,
			LaborHours = CASE WHEN LaborHours = 0 THEN NULL ELSE LaborHours END,
			LaborRate = CASE WHEN LaborRate = 0 THEN NULL ELSE LaborRate END,
			ExpenseGross = CASE ExpenseGross WHEN 0 THEN NULL ELSE ExpenseGross END,
			TotalGross = CASE TotalGross WHEN 0 THEN NULL ELSE TotalGross END
		WHERE TaskType = 1

		--First mark rows with data entered to be kept
		UPDATE	#tEstDetail
		SET		KeepRow = 1
		WHERE	(ISNULL(LaborHours, 0) <> 0
				OR ISNULL(LaborGross, 0) <> 0
				OR ISNULL(TotalGross, 0) <> 0)

		--Then, mark all parent rows to be kept
		WHILE(1=1)
		BEGIN
			IF EXISTS(
					SELECT	NULL
					FROM	#tEstDetail
					WHERE	EntityKey IN (SELECT SummaryTaskKey FROM #tEstDetail WHERE KeepRow = 1)
					AND		ISNULL(KeepRow, 0) = 0)
				UPDATE	#tEstDetail
				SET		KeepRow = 1
				WHERE	EntityKey IN (SELECT SummaryTaskKey FROM #tEstDetail WHERE KeepRow = 1)
				AND		ISNULL(KeepRow, 0) = 0
			ELSE
				BREAK
		END

		--select * from #tEstDetail

		DELETE	#tEstDetail
		WHERE	ISNULL(KeepRow, 0) = 0

		--select * from #tEstDetail order by SortOrder

		--Set "Bold" option based on presence of summary lines
		UPDATE #tEstDetail
		SET Bold = CASE WHEN edr.BoldOption > 0 THEN 1 ELSE 0 END
		FROM
			#tEstDetail ed
			LEFT JOIN
			(
				SELECT
					ISNULL(COUNT(*), 0) AS BoldOption,
					SummaryTaskKey
				FROM #tEstDetail
				WHERE SummaryTaskKey > 0
				GROUP BY SummaryTaskKey
			) edr
				ON ed.Entity = 'tTask' AND ed.EntityKey = edr.SummaryTaskKey

		SELECT
			@FinalOrder = 1,
			@SortOrder = -1

		--The top level is Task
		--Go through the hierarchiy and set the final order
		WHILE(1=1)
		BEGIN
			SELECT	@SortOrder = MIN(SortOrder)
			FROM	#tEstDetail
			WHERE
				Entity = 'tTask' AND
				SortOrder > @SortOrder

			IF @SortOrder IS NULL
				BREAK

			SELECT	@EntityKey = EntityKey
			FROM	#tEstDetail
			WHERE
				Entity = 'tTask' AND
				SortOrder = @SortOrder

			UPDATE	#tEstDetail
			SET	FinalOrder = @FinalOrder
			WHERE
				Entity = 'tTask' AND
				EntityKey = @EntityKey

			SELECT @FinalOrder = @FinalOrder + 1
			SELECT @SortOrder2 = -1

			WHILE(1=1)
			BEGIN
				SELECT	@SortOrder2 = MIN(SortOrder)
				FROM	#tEstDetail
				WHERE
					SummaryTaskKey = @EntityKey AND
					SortOrder > @SortOrder2

				IF @SortOrder2 IS NULL
					BREAK

				UPDATE	#tEstDetail
				SET	FinalOrder = @FinalOrder
				WHERE
					SummaryTaskKey = @EntityKey AND
					SortOrder = @SortOrder2

				SELECT @FinalOrder = @FinalOrder + 1		
			END--subsort
		END--primary sort

		-- now change back the TaskKey and SummaryTaskKey for the No Task row, we are done with the task logic above
		UPDATE #tEstDetail
		SET    EntityKey = 0, SummaryTaskKey = 0
		WHERE  EntityKey = -1 -- No Task row 

	END -- End By Task

------------------------------------------------------------------------
	IF @GetDataBy = @BY_SERVICE
	BEGIN
		-- From: sptEstimateGetServiceDetail
		INSERT	#tEstDetail
			(Entity,
			EntityKey,
			Subject,
			CampaignSegmentKey,
			LaborHours,
			HoursQuantity,
			LaborRate,
			LaborUnitRate,
			LaborGross,
			Taxable1,
			Taxable2)
		SELECT
			'tService',
			s.ServiceKey,
			s.Description,
			etl.CampaignSegmentKey,
			SUM(ISNULL(etl.Hours, 0)),
			SUM(ISNULL(etl.Hours, 0)),
			SUM(ISNULL(etl.Rate, 0)),
			SUM(ISNULL(etl.Rate, 0)),
			SUM(ROUND(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)),
			CASE Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
			CASE Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2
		FROM
			tService s (nolock)
			INNER JOIN tEstimateTaskLabor etl (nolock) ON s.ServiceKey = etl.ServiceKey AND etl.EstimateKey = @EstimateKey AND ISNULL(etl.Hours, 0) > 0
		GROUP BY
			s.ServiceKey,
			s.Description,
			etl.CampaignSegmentKey,
			Taxable,
			Taxable2

		INSERT	#tEstDetail
			(Entity,
			EntityKey,
			ExpenseItem,
			Subject,
			CampaignSegmentKey,
			Description,
			HoursQuantity,
			ItemQty,
			LaborUnitRate,
			ItemUnitRate,
			TotalGross,
			ExpenseGross,
			DisplayOption,
			SortOrder,
			IndentLevel,
			WorkTypeKey,
			Taxable1,
			Taxable2)
		SELECT
			'tItem',
			i.ItemKey,
			1,
			i.ItemName,
			cs.CampaignSegmentKey,
			i.StandardDescription,
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.Quantity
				WHEN 2 THEN ete.Quantity2
				WHEN 3 THEN ete.Quantity3
				WHEN 4 THEN ete.Quantity4
				WHEN 5 THEN ete.Quantity5
				WHEN 6 THEN ete.Quantity6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.Quantity
				WHEN 2 THEN ete.Quantity2
				WHEN 3 THEN ete.Quantity3
				WHEN 4 THEN ete.Quantity4
				WHEN 5 THEN ete.Quantity5
				WHEN 6 THEN ete.Quantity6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.UnitRate
				WHEN 2 THEN ete.UnitRate2
				WHEN 3 THEN ete.UnitRate3
				WHEN 4 THEN ete.UnitRate4
				WHEN 5 THEN ete.UnitRate5
				WHEN 6 THEN ete.UnitRate6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.UnitRate
				WHEN 2 THEN ete.UnitRate2
				WHEN 3 THEN ete.UnitRate3
				WHEN 4 THEN ete.UnitRate4
				WHEN 5 THEN ete.UnitRate5
				WHEN 6 THEN ete.UnitRate6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.BillableCost
				WHEN 2 THEN ete.BillableCost2
				WHEN 3 THEN ete.BillableCost3
				WHEN 4 THEN ete.BillableCost4
				WHEN 5 THEN ete.BillableCost5
				WHEN 6 THEN ete.BillableCost6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.BillableCost
				WHEN 2 THEN ete.BillableCost2
				WHEN 3 THEN ete.BillableCost3
				WHEN 4 THEN ete.BillableCost4
				WHEN 5 THEN ete.BillableCost5
				WHEN 6 THEN ete.BillableCost6 END),
			lb.DisplayOption,
			lb.LayoutOrder,
			lb.LayoutLevel - 1,
			CASE lb.ParentEntity WHEN 'tWorkType' THEN lb.ParentEntityKey ELSE NULL END,
			CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
			CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2
		FROM
			tEstimateTaskExpense ete (nolock)
			INNER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
			INNER JOIN tLayoutBilling lb (nolock) ON
				lb.Entity = 'tItem' AND
				lb.EntityKey = i.ItemKey AND
				lb.LayoutKey = @LayoutKey
			LEFT JOIN tCampaignSegment cs (nolock) ON ete.CampaignSegmentKey = cs.CampaignSegmentKey
		WHERE
			ete.EstimateKey = @EstimateKey
		GROUP BY
			i.ItemKey,
			i.ItemName,
			cs.CampaignSegmentKey,
			i.StandardDescription,
			lb.DisplayOption,
			lb.LayoutOrder,
			lb.LayoutLevel - 1,
			CASE lb.ParentEntity WHEN 'tWorkType' THEN lb.ParentEntityKey ELSE NULL END,
			CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END,
			CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END

		--Update the WorkTypeKey based on either the layout, or its default in tService
		UPDATE	#tEstDetail
		SET			WorkTypeKey =
						CASE
							WHEN l.ParentEntity = 'tWorkType' THEN l.ParentEntityKey
							ELSE s.WorkTypeKey
						END
		FROM	#tEstDetail
					INNER JOIN tService s (nolock) ON #tEstDetail.EntityKey = s.ServiceKey
					LEFT JOIN tLayoutBilling l (nolock) ON l.Entity = 'tService' AND #tEstDetail.EntityKey = l.EntityKey
		WHERE	LayoutKey = @LayoutKey

		--Insert rows for all Work Types that were inserted (repeat them if they're in more than one segment)
		--(153604) Added join back to tLayoutBilling to remove WorkType parents that have no children
		INSERT	#tEstDetail
				(Entity,
				EntityKey,
				CampaignSegmentKey)
		SELECT DISTINCT
			'tWorkType',
			WorkTypeKey,
			CampaignSegmentKey
		FROM
			#tEstDetail ed
			INNER JOIN tLayoutBilling lb ON
				lb.LayoutKey = @LayoutKey AND
				ed.Entity = lb.Entity COLLATE SQL_Latin1_General_CP1_CI_AI AND
				ed.EntityKey = lb.EntityKey AND
				ed.WorkTypeKey = lb.ParentEntityKey

		UPDATE  #tEstDetail
		SET ExpenseItem = b.ExpenseItem
		FROM
			#tEstDetail a
			INNER JOIN (SELECT EntityKey, WorkTypeKey, ExpenseItem FROM #tEstDetail WHERE ExpenseItem = 1 GROUP BY EntityKey, WorkTypeKey, ExpenseItem) b
				ON a.EntityKey = b.WorkTypeKey
		WHERE
			Entity = 'tWorkType'

		UPDATE	#tEstDetail
		SET			Subject =
						CASE
							WHEN wtc.Subject IS NOT NULL THEN wtc.Subject
							ELSE wt.WorkTypeName
						END
		FROM		#tEstDetail
						INNER JOIN tWorkType wt (nolock) ON #tEstDetail.Entity = 'tWorkType' AND #tEstDetail.EntityKey = wt.WorkTypeKey
						LEFT JOIN tWorkTypeCustom wtc (nolock) ON #tEstDetail.Entity = 'tWorkType' AND #tEstDetail.EntityKey = wtc.WorkTypeKey
							AND wtc.Entity = @ParentEntity AND wtc.EntityKey = @ParentEntityKey

		--Insert segments
		INSERT	#tEstDetail (
			Entity,
			EntityKey,
			IndentLevel,
			DisplayOption)
		SELECT DISTINCT 'tCampaignSegment',
			CampaignSegmentKey,
			0,
			(SELECT	DisplayOption
			FROM	tLayoutBilling
			WHERE
				LayoutKey = @LayoutKey AND
				EntityKey = 0)
		FROM	#tEstDetail
		WHERE	CampaignSegmentKey > 0

		UPDATE	#tEstDetail
		SET			#tEstDetail.Subject = cs.SegmentName,
						#tEstDetail.SortOrder = cs.DisplayOrder
		FROM		#tEstDetail
						INNER JOIN tCampaignSegment cs (nolock) ON #tEstDetail.EntityKey = cs.CampaignSegmentKey AND #tEstDetail.Entity = 'tCampaignSegment'

		--Update the Sort Order and Level from the selected layout
		UPDATE	#tEstDetail
		SET			SortOrder = l.LayoutOrder,
						IndentLevel =
							CASE
								WHEN ISNULL(#tEstDetail.CampaignSegmentKey, 0) > 0 THEN l.LayoutLevel
								ELSE ISNULL(l.LayoutLevel, 0) - 1 --Subtract 1 because there's no Segment level
							END,
						DisplayOption = l.DisplayOption
		FROM		#tEstDetail
						INNER JOIN 
						tLayoutBilling l (nolock) ON
							#tEstDetail.Entity = l.Entity COLLATE DATABASE_DEFAULT AND 
							#tEstDetail.EntityKey = l.EntityKey AND
							l.LayoutKey = @LayoutKey

		UPDATE	#tEstDetail
		SET			TotalGross = LaborGross
		WHERE		Entity != 'tItem'

		--Now set the final order from the Hierarchy
		SELECT
			@FinalOrder = 1,
			@SortOrder = -1

		SELECT	@Entity = MIN(Entity)
		FROM		#tEstDetail
		WHERE		IndentLevel = 0

		IF ISNULL(@Entity, 0) IN ('tCampaignSegment', 'tWorkType')
		BEGIN
			--The top level is a Campaign Segment
			--Go through the hierarchiy and set the final order
			WHILE(1=1)
			BEGIN
				SELECT	@SortOrder = MIN(SortOrder)
				FROM	#tEstDetail
				WHERE	Entity = @Entity
				AND		SortOrder > @SortOrder

				IF @SortOrder IS NULL
					BREAK

				SELECT	@EntityKey = EntityKey
				FROM	#tEstDetail
				WHERE	Entity = @Entity
				AND		SortOrder = @SortOrder

				UPDATE	#tEstDetail
				SET		FinalOrder = @FinalOrder
				WHERE	Entity = @Entity
				AND		EntityKey = @EntityKey

				SELECT	@FinalOrder = @FinalOrder + 1
				SELECT	@SortOrder2 = -1

				WHILE(1=1)
				BEGIN
					IF @Entity = 'tWorkType'
					BEGIN
						SELECT	@SortOrder2 = MIN(SortOrder)
						FROM	#tEstDetail
						WHERE	WorkTypeKey = @EntityKey
							AND SortOrder > @SortOrder2

						IF @SortOrder2 IS NULL
							BREAK

						UPDATE	#tEstDetail
						SET	FinalOrder = @FinalOrder
						WHERE	WorkTypeKey = @EntityKey
							AND SortOrder = @SortOrder2
					END
					IF @Entity = 'tCampaignSegment'
					BEGIN
						SELECT	@SortOrder2 = MIN(SortOrder)
						FROM	#tEstDetail
						WHERE	CampaignSegmentKey = @EntityKey
							AND SortOrder > @SortOrder2

						IF @SortOrder2 IS NULL
							BREAK

						UPDATE	#tEstDetail
						SET	FinalOrder = @FinalOrder
						WHERE	CampaignSegmentKey = @EntityKey
							AND SortOrder = @SortOrder2
					END
					SELECT	@FinalOrder = @FinalOrder + 1
				END
			END
		END
		ELSE
			UPDATE	#tEstDetail
			SET		FinalOrder = SortOrder

		SELECT	@MaxIndentLevel = MAX(IndentLevel)
		FROM	#tEstDetail

		UPDATE	#tEstDetail
		SET		Bold = 1
		WHERE	IndentLevel < @MaxIndentLevel
	END -- End By Service

------------------------------------------------------------------------
IF @GetDataBy = @BY_SEGMENT_AND_TITLE
BEGIN
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		Subject,
		DisplayOption,
		ServiceKey,
		CampaignSegmentKey,
		LaborHours,
		HoursQuantity,
		LaborRate,
		LaborUnitRate,
		LaborGross,
		Taxable1,
		Taxable2,
		IndentLevel,
		SortOrder)
	SELECT
		'tTitle',
		etl.TitleKey,
		ti.TitleName,
		2,
		etl.ServiceKey,
		etl.CampaignSegmentKey,
		etl.Hours,
		etl.Hours,
		etl.Rate,
		etl.Rate,
		ROUND(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2),
		CASE ti.Taxable WHEN 1 THEN '*' ELSE NULL END,
		CASE ti.Taxable2 WHEN 1 THEN '*' ELSE NULL END,
		1,
		(ROW_NUMBER() OVER(ORDER BY ti.TitleName ASC))
	FROM
		tEstimateTaskLabor etl (nolock)
		INNER JOIN tTitle ti (nolock) ON etl.TitleKey = ti.TitleKey
	WHERE
		etl.EstimateKey = @EstimateKey AND
		etl.Hours > 0

	--Insert rows for all Segments that have Titles inserted (repeat them if they're in more than one segment)
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		CampaignSegmentKey,
		Subject,
		DisplayOption,
		IndentLevel,
		SortOrder)
	SELECT DISTINCT
		'tCampaignSegment',
		cs.CampaignSegmentKey,
		cs.CampaignSegmentKey,
		cs.SegmentName,
		2,
		0,
		(ROW_NUMBER() OVER(ORDER BY cs.SegmentName ASC))
	FROM
		#tEstDetail ed
		INNER JOIN tCampaignSegment cs (nolock) ON ed.CampaignSegmentKey = cs.CampaignSegmentKey
	WHERE ed.Entity = 'tTitle'
	GROUP BY
		cs.CampaignSegmentKey,
		cs.SegmentName
	
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		ExpenseItem,
		Subject,
		CampaignSegmentKey,
		Description,
		HoursQuantity,
		ItemQty,
		LaborUnitRate,
		ItemUnitRate,
		TotalGross,
		ExpenseGross,
		DisplayOption,
		SortOrder,
		IndentLevel,
		WorkTypeKey,
		Taxable1,
		Taxable2)
	SELECT
		'tItem',
		i.ItemKey,
		1,
		ete.ShortDescription,
		cs.CampaignSegmentKey,
		i.StandardDescription,
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.Quantity
			WHEN 2 THEN ete.Quantity2
			WHEN 3 THEN ete.Quantity3
			WHEN 4 THEN ete.Quantity4
			WHEN 5 THEN ete.Quantity5
			WHEN 6 THEN ete.Quantity6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.Quantity
			WHEN 2 THEN ete.Quantity2
			WHEN 3 THEN ete.Quantity3
			WHEN 4 THEN ete.Quantity4
			WHEN 5 THEN ete.Quantity5
			WHEN 6 THEN ete.Quantity6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.UnitRate
			WHEN 2 THEN ete.UnitRate2
			WHEN 3 THEN ete.UnitRate3
			WHEN 4 THEN ete.UnitRate4
			WHEN 5 THEN ete.UnitRate5
			WHEN 6 THEN ete.UnitRate6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.UnitRate
			WHEN 2 THEN ete.UnitRate2
			WHEN 3 THEN ete.UnitRate3
			WHEN 4 THEN ete.UnitRate4
			WHEN 5 THEN ete.UnitRate5
			WHEN 6 THEN ete.UnitRate6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.BillableCost
			WHEN 2 THEN ete.BillableCost2
			WHEN 3 THEN ete.BillableCost3
			WHEN 4 THEN ete.BillableCost4
			WHEN 5 THEN ete.BillableCost5
			WHEN 6 THEN ete.BillableCost6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.BillableCost
			WHEN 2 THEN ete.BillableCost2
			WHEN 3 THEN ete.BillableCost3
			WHEN 4 THEN ete.BillableCost4
			WHEN 5 THEN ete.BillableCost5
			WHEN 6 THEN ete.BillableCost6 END),
		2,
		(ROW_NUMBER() OVER(ORDER BY ete.ShortDescription ASC)),
		CASE WHEN ISNULL(i.WorkTypeKey , 0) > 0 THEN 2 ELSE 1 END,
		i.WorkTypeKey,
		CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
		CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2
	FROM
		tEstimateTaskExpense ete (nolock)
		INNER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
		LEFT JOIN tCampaignSegment cs (nolock) ON ete.CampaignSegmentKey = cs.CampaignSegmentKey
	WHERE
		ete.EstimateKey = @EstimateKey
	GROUP BY
		i.ItemKey,
		ete.ShortDescription,
		cs.CampaignSegmentKey,
		i.StandardDescription,
		i.WorkTypeKey,
		CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END,
		CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END

	IF EXISTS(SELECT * FROM #tEstDetail WHERE Entity = 'tItem')
		INSERT #tEstDetail
			(Entity,
			EntityKey,
			Subject,
			DisplayOption,
			IndentLevel,
			SortOrder)
		SELECT DISTINCT
			'EXPENSES',
			0,
			'Expenses',
			2,
			0,
			1
	
	UPDATE #tEstDetail
	SET TotalGross = LaborGross
	WHERE Entity != 'tItem'
	
	--Now set the final order from the Hierarchy
	SELECT
		@FinalOrder = 1,
		@SortOrder = -1
	
	--Go through the hierarchiy and set the final order
	WHILE(1=1)
	BEGIN
		SELECT TOP 1
			@EstDetailKey = EstDetailKey,
			@Entity = Entity,
			@EntityKey = EntityKey
		FROM #tEstDetail
		WHERE
			IndentLevel = 0 AND
			FinalOrder IS NULL
		ORDER BY
			EstDetailKey,
			SortOrder,
			Description
		
		IF @EstDetailKey IS NULL
			BREAK
		
		UPDATE #tEstDetail
		SET	FinalOrder = @FinalOrder
		WHERE
			EstDetailKey = @EstDetailKey
		
		SELECT
			@FinalOrder = @FinalOrder + 1,
			@EstDetailKey = NULL
		
		WHILE(1=1)
		BEGIN
			IF @Entity = 'EXPENSES'
			BEGIN
				SELECT TOP 1
					@EstDetailKey = EstDetailKey
				FROM #tEstDetail
				WHERE
					Entity = 'tItem' AND
					FinalOrder IS NULL
				ORDER BY ISNULL(Subject, '')
				
				IF @EstDetailKey IS NULL
					BREAK

				UPDATE #tEstDetail
				SET	FinalOrder = @FinalOrder
				WHERE
					EstDetailKey = @EstDetailKey
			END
			IF @Entity = 'tCampaignSegment'
			BEGIN
				SELECT TOP 1
					@EstDetailKey = EstDetailKey
				FROM #tEstDetail
				WHERE
					CampaignSegmentKey = @EntityKey AND
					Entity = 'tTitle' AND
					FinalOrder IS NULL
				ORDER BY ISNULL(Subject, '')
				
				IF @EstDetailKey IS NULL
					BREAK
				
				UPDATE #tEstDetail
				SET
					FinalOrder = @FinalOrder,
					IndentLevel = 1 --tTitle is top level (0)
				WHERE
					EstDetailKey = @EstDetailKey
			END
			SELECT @FinalOrder = @FinalOrder + 1
			SELECT @EstDetailKey = NULL
		END
	END

	SELECT	@MaxIndentLevel = MAX(IndentLevel)
	FROM	#tEstDetail

	UPDATE	#tEstDetail
	SET	Bold = 1
	WHERE	IndentLevel = 0
END -- By Segment and Title

------------------------------------------------------------------------
IF @GetDataBy = @BY_SEGMENT_AND_SERVICE
BEGIN
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		Subject,
		DisplayOption,
		ServiceKey,
		CampaignSegmentKey,
		LaborHours,
		HoursQuantity,
		LaborRate,
		LaborUnitRate,
		LaborGross,
		Taxable1,
		Taxable2,
		IndentLevel,
		SortOrder)
	SELECT
		'tService',
		etl.TitleKey,
		s.Description,
		2,
		etl.ServiceKey,
		etl.CampaignSegmentKey,
		etl.Hours,
		etl.Hours,
		etl.Rate,
		etl.Rate,
		ROUND(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2),
		CASE s.Taxable WHEN 1 THEN '*' ELSE NULL END,
		CASE s.Taxable2 WHEN 1 THEN '*' ELSE NULL END,
		1,
		(ROW_NUMBER() OVER(ORDER BY s.Description ASC))
	FROM
		tEstimateTaskLabor etl (nolock)
		INNER JOIN tService s (nolock) ON etl.ServiceKey = s.ServiceKey
	WHERE
		etl.EstimateKey = @EstimateKey AND
		etl.Hours > 0
	
	--Insert rows for all Segments that have Services inserted
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		CampaignSegmentKey,
		Subject,
		DisplayOption,
		IndentLevel,
		SortOrder)
	SELECT DISTINCT
		'tCampaignSegment',
		cs.CampaignSegmentKey,
		cs.CampaignSegmentKey,
		cs.SegmentName,
		2,
		0,
		(ROW_NUMBER() OVER(ORDER BY cs.SegmentName ASC))
	FROM
		#tEstDetail ed
		INNER JOIN tCampaignSegment cs (nolock) ON ed.CampaignSegmentKey = cs.CampaignSegmentKey
	WHERE ed.Entity = 'tService'
	GROUP BY
		cs.CampaignSegmentKey,
		cs.SegmentName
	
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		ExpenseItem,
		Subject,
		CampaignSegmentKey,
		Description,
		HoursQuantity,
		ItemQty,
		LaborUnitRate,
		ItemUnitRate,
		TotalGross,
		ExpenseGross,
		DisplayOption,
		SortOrder,
		IndentLevel,
		WorkTypeKey,
		Taxable1,
		Taxable2)
	SELECT
		'tItem',
		i.ItemKey,
		1,
		ete.ShortDescription,
		cs.CampaignSegmentKey,
		i.StandardDescription,
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.Quantity
			WHEN 2 THEN ete.Quantity2
			WHEN 3 THEN ete.Quantity3
			WHEN 4 THEN ete.Quantity4
			WHEN 5 THEN ete.Quantity5
			WHEN 6 THEN ete.Quantity6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.Quantity
			WHEN 2 THEN ete.Quantity2
			WHEN 3 THEN ete.Quantity3
			WHEN 4 THEN ete.Quantity4
			WHEN 5 THEN ete.Quantity5
			WHEN 6 THEN ete.Quantity6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.UnitRate
			WHEN 2 THEN ete.UnitRate2
			WHEN 3 THEN ete.UnitRate3
			WHEN 4 THEN ete.UnitRate4
			WHEN 5 THEN ete.UnitRate5
			WHEN 6 THEN ete.UnitRate6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.UnitRate
			WHEN 2 THEN ete.UnitRate2
			WHEN 3 THEN ete.UnitRate3
			WHEN 4 THEN ete.UnitRate4
			WHEN 5 THEN ete.UnitRate5
			WHEN 6 THEN ete.UnitRate6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.BillableCost
			WHEN 2 THEN ete.BillableCost2
			WHEN 3 THEN ete.BillableCost3
			WHEN 4 THEN ete.BillableCost4
			WHEN 5 THEN ete.BillableCost5
			WHEN 6 THEN ete.BillableCost6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.BillableCost
			WHEN 2 THEN ete.BillableCost2
			WHEN 3 THEN ete.BillableCost3
			WHEN 4 THEN ete.BillableCost4
			WHEN 5 THEN ete.BillableCost5
			WHEN 6 THEN ete.BillableCost6 END),
		2,
		(ROW_NUMBER() OVER(ORDER BY ete.ShortDescription ASC)),
		CASE WHEN ISNULL(i.WorkTypeKey , 0) > 0 THEN 2 ELSE 1 END,
		i.WorkTypeKey,
		CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
		CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2
	FROM
		tEstimateTaskExpense ete (nolock)
		INNER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
		LEFT JOIN tCampaignSegment cs (nolock) ON ete.CampaignSegmentKey = cs.CampaignSegmentKey
	WHERE
		ete.EstimateKey = @EstimateKey
	GROUP BY
		i.ItemKey,
		ete.ShortDescription,
		cs.CampaignSegmentKey,
		i.StandardDescription,
		i.WorkTypeKey,
		CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END,
		CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END

	IF EXISTS(SELECT * FROM #tEstDetail WHERE Entity = 'tItem')
		INSERT #tEstDetail
			(Entity,
			EntityKey,
			Subject,
			DisplayOption,
			IndentLevel,
			SortOrder)
		SELECT DISTINCT
			'EXPENSES',
			0,
			'Expenses',
			2,
			0,
			1
	
	UPDATE #tEstDetail
	SET TotalGross = LaborGross
	WHERE Entity != 'tItem'
	
	--Now set the final order from the Hierarchy
	SELECT
		@FinalOrder = 1,
		@SortOrder = -1
	
	--Go through the hierarchiy and set the final order
	WHILE(1=1)
	BEGIN
		SELECT TOP 1
			@EstDetailKey = EstDetailKey,
			@Entity = Entity,
			@EntityKey = EntityKey
		FROM #tEstDetail
		WHERE
			IndentLevel = 0 AND
			FinalOrder IS NULL
		ORDER BY
			EstDetailKey,
			SortOrder,
			Description
		
		IF @EstDetailKey IS NULL
			BREAK
		
		UPDATE #tEstDetail
		SET	FinalOrder = @FinalOrder
		WHERE
			EstDetailKey = @EstDetailKey
		
		SELECT
			@FinalOrder = @FinalOrder + 1,
			@EstDetailKey = NULL
		
		WHILE(1=1)
		BEGIN
			IF @Entity = 'EXPENSES'
			BEGIN
				SELECT TOP 1
					@EstDetailKey = EstDetailKey
				FROM #tEstDetail
				WHERE
					Entity = 'tItem' AND
					FinalOrder IS NULL
				ORDER BY ISNULL(Subject, '')
				
				IF @EstDetailKey IS NULL
					BREAK

				UPDATE #tEstDetail
				SET	FinalOrder = @FinalOrder
				WHERE
					EstDetailKey = @EstDetailKey
			END
			IF @Entity = 'tCampaignSegment'
			BEGIN
				SELECT TOP 1
					@EstDetailKey = EstDetailKey
				FROM #tEstDetail
				WHERE
					CampaignSegmentKey = @EntityKey AND
					Entity = 'tService' AND
					FinalOrder IS NULL
				ORDER BY ISNULL(Subject, '')
				
				IF @EstDetailKey IS NULL
					BREAK
				
				UPDATE #tEstDetail
				SET
					FinalOrder = @FinalOrder,
					IndentLevel = 1 --tTitle is top level (0)
				WHERE
					EstDetailKey = @EstDetailKey
			END
			SELECT @FinalOrder = @FinalOrder + 1
			SELECT @EstDetailKey = NULL
		END
	END

	SELECT	@MaxIndentLevel = MAX(IndentLevel)
	FROM	#tEstDetail

	UPDATE	#tEstDetail
	SET	Bold = 1
	WHERE	IndentLevel = 0
END -- By Segment and Service

------------------------------------------------------------------------
IF @GetDataBy = @BY_SERVICE_AND_BILLING_TITLE
BEGIN
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		Subject,
		DisplayOption,
		ServiceKey,
		CampaignSegmentKey,
		LaborHours,
		HoursQuantity,
		LaborRate,
		LaborUnitRate,
		LaborGross,
		Taxable1,
		Taxable2)
	SELECT
		'tTitle',
		ISNULL(etlt.TitleKey, 0),
		ISNULL(ti.TitleName, ''),
		1,
		s.ServiceKey,
		ISNULL(etlt.CampaignSegmentKey, etl.CampaignSegmentKey),
		ISNULL(etlt.Hours, ISNULL(etl.Hours, 0)),
		ISNULL(etlt.Hours, ISNULL(etl.Hours, 0)),
		ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),
		ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),
		ROUND(ISNULL(etlt.Hours, ISNULL(etl.Hours, 0)) * ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),2),
		CASE s.Taxable WHEN 1 THEN '*' ELSE NULL END,
		CASE s.Taxable2 WHEN 1 THEN '*' ELSE NULL END
	FROM
		tEstimateTaskLabor etl (nolock)
		INNER JOIN tTask t (nolock) ON etl.TaskKey = t.TaskKey
		INNER JOIN tService s (nolock) ON etl.ServiceKey = s.ServiceKey AND etl.EstimateKey = @EstimateKey AND ISNULL(etl.Hours, 0) > 0
		LEFT JOIN tEstimateTaskLaborTitle etlt (nolock) ON etl.TaskKey = etlt.TaskKey AND etl.ServiceKey = etlt.ServiceKey
		LEFT JOIN tTitle ti (nolock) ON etlt.TitleKey = ti.TitleKey
	WHERE
		etl.EstimateKey = @EstimateKey

	--Insert rows for all Services that have Titles inserted (repeat them if they're in more than one segment)
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		CampaignSegmentKey,
		Subject,
		DisplayOption)
	SELECT DISTINCT
		'tService',
		s.ServiceKey,
		CampaignSegmentKey,
		s.Description,
		2
	FROM
		#tEstDetail ed
		INNER JOIN tService s (nolock) ON ed.ServiceKey = s.ServiceKey
	WHERE ed.Entity = 'tTitle'

	INSERT	#tEstDetail
			(Entity,
			EntityKey,
			ExpenseItem,
			Subject,
			CampaignSegmentKey,
			Description,
			HoursQuantity,
			ItemQty,
			LaborUnitRate,
			ItemUnitRate,
			TotalGross,
			ExpenseGross,
			DisplayOption,
			SortOrder,
			IndentLevel,
			WorkTypeKey,
			Taxable1,
			Taxable2)
		SELECT
			'tItem',
			i.ItemKey,
			1,
			i.ItemName,
			cs.CampaignSegmentKey,
			i.StandardDescription,
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.Quantity
				WHEN 2 THEN ete.Quantity2
				WHEN 3 THEN ete.Quantity3
				WHEN 4 THEN ete.Quantity4
				WHEN 5 THEN ete.Quantity5
				WHEN 6 THEN ete.Quantity6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.Quantity
				WHEN 2 THEN ete.Quantity2
				WHEN 3 THEN ete.Quantity3
				WHEN 4 THEN ete.Quantity4
				WHEN 5 THEN ete.Quantity5
				WHEN 6 THEN ete.Quantity6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.UnitRate
				WHEN 2 THEN ete.UnitRate2
				WHEN 3 THEN ete.UnitRate3
				WHEN 4 THEN ete.UnitRate4
				WHEN 5 THEN ete.UnitRate5
				WHEN 6 THEN ete.UnitRate6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.UnitRate
				WHEN 2 THEN ete.UnitRate2
				WHEN 3 THEN ete.UnitRate3
				WHEN 4 THEN ete.UnitRate4
				WHEN 5 THEN ete.UnitRate5
				WHEN 6 THEN ete.UnitRate6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.BillableCost
				WHEN 2 THEN ete.BillableCost2
				WHEN 3 THEN ete.BillableCost3
				WHEN 4 THEN ete.BillableCost4
				WHEN 5 THEN ete.BillableCost5
				WHEN 6 THEN ete.BillableCost6 END),
			SUM(CASE @ApprovedQty
				WHEN 1 THEN ete.BillableCost
				WHEN 2 THEN ete.BillableCost2
				WHEN 3 THEN ete.BillableCost3
				WHEN 4 THEN ete.BillableCost4
				WHEN 5 THEN ete.BillableCost5
				WHEN 6 THEN ete.BillableCost6 END),
			2,
			lb.LayoutOrder,
			lb.LayoutLevel - 1,
			CASE lb.ParentEntity WHEN 'tWorkType' THEN lb.ParentEntityKey ELSE NULL END,
			CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
			CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2
		FROM
			tEstimateTaskExpense ete (nolock)
			INNER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
			INNER JOIN tLayoutBilling lb (nolock) ON
				lb.Entity = 'tItem' AND
				lb.EntityKey = i.ItemKey AND
				lb.LayoutKey = @LayoutKey
			LEFT JOIN tCampaignSegment cs (nolock) ON ete.CampaignSegmentKey = cs.CampaignSegmentKey
		WHERE
			ete.EstimateKey = @EstimateKey
		GROUP BY
			i.ItemKey,
			i.ItemName,
			cs.CampaignSegmentKey,
			i.StandardDescription,
			lb.LayoutOrder,
			lb.LayoutLevel - 1,
			CASE lb.ParentEntity WHEN 'tWorkType' THEN lb.ParentEntityKey ELSE NULL END,
			CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END,
	CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END

	--Insert rows for all Work Types that were inserted (repeat them if they're in more than one segment)
	--(153604) Added join back to tLayoutBilling to remove WorkType parents that have no children
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		CampaignSegmentKey,
		DisplayOption)
	SELECT DISTINCT
		'tWorkType',
		WorkTypeKey,
		CampaignSegmentKey,
		2
	FROM
		#tEstDetail ed
		INNER JOIN
			tLayoutBilling lb ON
			lb.LayoutKey = @LayoutKey AND
			ed.Entity = lb.Entity COLLATE SQL_Latin1_General_CP1_CI_AI AND
			ed.EntityKey = lb.EntityKey AND
			ed.WorkTypeKey = lb.ParentEntityKey
	WHERE
		ed.Entity = 'tItem'

	UPDATE #tEstDetail
	SET Subject =
		CASE
			WHEN wtc.Subject IS NOT NULL THEN wtc.Subject
			ELSE wt.WorkTypeName
		END
	FROM
		#tEstDetail
		INNER JOIN tWorkType wt (nolock) ON #tEstDetail.Entity = 'tWorkType' AND #tEstDetail.EntityKey = wt.WorkTypeKey
		LEFT JOIN tWorkTypeCustom wtc (nolock) ON #tEstDetail.Entity = 'tWorkType' AND #tEstDetail.EntityKey = wtc.WorkTypeKey
			AND wtc.Entity = @ParentEntity AND wtc.EntityKey = @ParentEntityKey

	--Update the Sort Order and Level from the selected layout
	UPDATE #tEstDetail
	SET
		SortOrder = l.LayoutOrder,
				IndentLevel =
					CASE
						WHEN ISNULL(ed.CampaignSegmentKey, 0) > 0 THEN l.LayoutLevel
						WHEN ed.Entity = 'tService' THEN 0 --This line type puts Service at the top of the hierarchy
						ELSE ISNULL(l.LayoutLevel, 0) - 1 --Subtract 1 because there's no Segment level
					END,
				DisplayOption = CASE WHEN ed.Entity = 'tService' THEN
					2
				ELSE
					l.DisplayOption
		END
	FROM
		#tEstDetail ed
		INNER JOIN tLayoutBilling l (nolock) ON
			ed.Entity = l.Entity COLLATE DATABASE_DEFAULT AND
			ed.EntityKey = l.EntityKey AND
			l.LayoutKey = @LayoutKey

	UPDATE #tEstDetail
	SET TotalGross = LaborGross
	WHERE Entity != 'tItem'

	--Now set the final order from the Hierarchy
	SELECT
		@FinalOrder = 1,
		@SortOrder = -1

	--Go through the hierarchiy and set the final order
	WHILE(1=1)
	BEGIN
		SELECT @SortOrder = MIN(SortOrder)
		FROM #tEstDetail
		WHERE
			IndentLevel = 0 AND
			SortOrder > @SortOrder

		IF @SortOrder IS NULL
			BREAK

		--Could be tWorkType or tService
		SELECT @Entity = MIN(Entity)
		FROM #tEstDetail
		WHERE
			IndentLevel = 0 AND
			SortOrder = @SortOrder

		SELECT @EntityKey = EntityKey
		FROM #tEstDetail
		WHERE
			IndentLevel = 0 AND
			Entity = @Entity AND
			SortOrder = @SortOrder

		UPDATE #tEstDetail
		SET	FinalOrder = @FinalOrder
		WHERE
			Entity = @Entity AND
			EntityKey = @EntityKey

		SELECT @FinalOrder = @FinalOrder + 1
		SELECT @SortOrder2 = NULL

		WHILE(1=1)
		BEGIN
			IF @Entity = 'tWorkType'
			BEGIN
				SELECT @SortOrder2 = MIN(SortOrder)
				FROM #tEstDetail
				WHERE
					WorkTypeKey = @EntityKey AND
					FinalOrder IS NULL

				IF @SortOrder2 IS NULL
					BREAK

				UPDATE #tEstDetail
				SET	FinalOrder = @FinalOrder
				WHERE
					WorkTypeKey = @EntityKey AND
					SortOrder = @SortOrder2
			END
			IF @Entity = 'tService'
			BEGIN
				SELECT @SortOrder2 = ISNULL(EntityKey, 0)
				FROM #tEstDetail
				WHERE
					ServiceKey = @EntityKey AND
					Entity = 'tTitle' AND
					FinalOrder IS NULL
				ORDER BY ISNULL(Subject, '')

				IF @SortOrder2 IS NULL
					BREAK

				UPDATE #tEstDetail
				SET
					FinalOrder = @FinalOrder,
					IndentLevel = 1 --tService is top level (0)
				WHERE
					ServiceKey = @EntityKey AND
					Entity = 'tTitle' AND
					ISNULL(EntityKey, 0) = @SortOrder2 AND
					FinalOrder IS NULL
			END
			SELECT @FinalOrder = @FinalOrder + 1
			SELECT @SortOrder2 = NULL
		END
	END

	SELECT	@MaxIndentLevel = MAX(IndentLevel)
	FROM	#tEstDetail

	UPDATE	#tEstDetail
	SET	Bold = 1
	WHERE	IndentLevel < @MaxIndentLevel	
END -- End By Service and Billing Title

------------------------------------------------------------------------
IF @GetDataBy IN (@BY_BILLING_TITLE_AND_SERVICE, @BY_BILLING_TITLE)
BEGIN
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		Subject,
		DisplayOption,
		WorkTypeKey,
		TitleKey,
		CampaignSegmentKey,
		LaborHours,
		HoursQuantity,
		LaborRate,
		LaborUnitRate,
		LaborGross,
		Taxable1,
		Taxable2,
		SortOrder)
	SELECT
		'tService',
		s.ServiceKey,
		s.Description,
		1,
		ti.WorkTypeKey,
		ti.TitleKey,
		ISNULL(etlt.CampaignSegmentKey, etl.CampaignSegmentKey),
		SUM(ISNULL(etlt.Hours, ISNULL(etl.Hours, 0))),
		SUM(ISNULL(etlt.Hours, ISNULL(etl.Hours, 0))),
		ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),
		ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),
		ROUND(ISNULL(etlt.Hours, ISNULL(etl.Hours, 0)) * ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),2),
		CASE ISNULL(s.Taxable, 0) WHEN 1 THEN '*' ELSE NULL END,
		CASE ISNULL(s.Taxable2, 0) WHEN 1 THEN '*' ELSE NULL END,
		(ROW_NUMBER() OVER(ORDER BY s.Description ASC))
	FROM
		tEstimateTaskLabor etl (nolock)
		INNER JOIN tService s (nolock) ON etl.ServiceKey = s.ServiceKey AND etl.EstimateKey = @EstimateKey AND ISNULL(etl.Hours, 0) > 0
		LEFT JOIN tEstimateTaskLaborTitle etlt (nolock) ON etl.TaskKey = etlt.TaskKey AND etl.ServiceKey = etlt.ServiceKey
		LEFT JOIN tTitle ti (nolock) ON etlt.TitleKey = ti.TitleKey
	WHERE
		etl.EstimateKey = @EstimateKey
	GROUP BY
		s.ServiceKey,
		s.Description,
		ti.WorkTypeKey,
		ti.TitleKey,
		ISNULL(etlt.CampaignSegmentKey, etl.CampaignSegmentKey),
		ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),
		ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),
		ROUND(ISNULL(etlt.Hours, ISNULL(etl.Hours, 0)) * ISNULL(etlt.Rate, ISNULL(etl.Rate, 0)),2),
		CASE ISNULL(s.Taxable, 0) WHEN 1 THEN '*' ELSE NULL END,
		CASE ISNULL(s.Taxable2, 0) WHEN 1 THEN '*' ELSE NULL END
	
	--Insert rows for all Titles that have Services inserted (repeat them if they're in more than one segment)
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		CampaignSegmentKey,
		Subject,
		DisplayOption,
		SortOrder)
	SELECT
		'tTitle',
		t.TitleKey,
		CampaignSegmentKey,
		t.TitleName,
		CASE @GetDataBy WHEN @BY_BILLING_TITLE THEN 1 ELSE 2 END,
		(ROW_NUMBER() OVER(ORDER BY t.TitleName ASC))
	FROM
		#tEstDetail ed
		INNER JOIN tTitle t (nolock) ON ed.TitleKey = t.TitleKey
	WHERE ed.Entity = 'tService'
	GROUP BY
		t.TitleKey,
		CampaignSegmentKey,
		t.TitleName
	
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		ExpenseItem,
		Subject,
		CampaignSegmentKey,
		Description,
		HoursQuantity,
		ItemQty,
		LaborUnitRate,
		ItemUnitRate,
		TotalGross,
		ExpenseGross,
		DisplayOption,
		SortOrder,
		IndentLevel,
		WorkTypeKey,
		Taxable1,
		Taxable2)
	SELECT
		'tItem',
		i.ItemKey,
		1,
		i.ItemName,
		cs.CampaignSegmentKey,
		i.StandardDescription,
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.Quantity
			WHEN 2 THEN ete.Quantity2
			WHEN 3 THEN ete.Quantity3
			WHEN 4 THEN ete.Quantity4
			WHEN 5 THEN ete.Quantity5
			WHEN 6 THEN ete.Quantity6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.Quantity
			WHEN 2 THEN ete.Quantity2
			WHEN 3 THEN ete.Quantity3
			WHEN 4 THEN ete.Quantity4
			WHEN 5 THEN ete.Quantity5
			WHEN 6 THEN ete.Quantity6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.UnitRate
			WHEN 2 THEN ete.UnitRate2
			WHEN 3 THEN ete.UnitRate3
			WHEN 4 THEN ete.UnitRate4
			WHEN 5 THEN ete.UnitRate5
			WHEN 6 THEN ete.UnitRate6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.UnitRate
			WHEN 2 THEN ete.UnitRate2
			WHEN 3 THEN ete.UnitRate3
			WHEN 4 THEN ete.UnitRate4
			WHEN 5 THEN ete.UnitRate5
			WHEN 6 THEN ete.UnitRate6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.BillableCost
			WHEN 2 THEN ete.BillableCost2
			WHEN 3 THEN ete.BillableCost3
			WHEN 4 THEN ete.BillableCost4
			WHEN 5 THEN ete.BillableCost5
			WHEN 6 THEN ete.BillableCost6 END),
		SUM(CASE @ApprovedQty
			WHEN 1 THEN ete.BillableCost
			WHEN 2 THEN ete.BillableCost2
			WHEN 3 THEN ete.BillableCost3
			WHEN 4 THEN ete.BillableCost4
			WHEN 5 THEN ete.BillableCost5
			WHEN 6 THEN ete.BillableCost6 END),
		2,
		(ROW_NUMBER() OVER(ORDER BY i.StandardDescription ASC)),
		CASE WHEN ISNULL(i.WorkTypeKey , 0) > 0 THEN 2 ELSE 1 END,
		i.WorkTypeKey,
		CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
		CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2
	FROM
		tEstimateTaskExpense ete (nolock)
		INNER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
		LEFT JOIN tCampaignSegment cs (nolock) ON ete.CampaignSegmentKey = cs.CampaignSegmentKey
	WHERE
		ete.EstimateKey = @EstimateKey
	GROUP BY
		i.ItemKey,
		i.ItemName,
		cs.CampaignSegmentKey,
		i.StandardDescription,
		i.WorkTypeKey,
		CASE i.Taxable WHEN 1 THEN '*' ELSE NULL END,
		CASE i.Taxable2 WHEN 1 THEN '*' ELSE NULL END
	
	--Insert rows for all Work Types that were inserted (repeat them if they're in more than one segment)
	INSERT #tEstDetail
		(Entity,
		EntityKey,
		CampaignSegmentKey,
		DisplayOption,
		SortOrder)
	SELECT DISTINCT
		'tWorkType',
		WorkTypeKey,
		CampaignSegmentKey,
		1,
		(ROW_NUMBER() OVER(ORDER BY Subject ASC))
	FROM
		#tEstDetail ed
	WHERE
		ed.Entity = 'tItem' OR
		(
			ed.Entity = 'tService' AND
			TitleKey IS NULL
		)
	
	UPDATE #tEstDetail
	SET Subject =
		CASE
			WHEN wtc.Subject IS NOT NULL THEN wtc.Subject
			ELSE wt.WorkTypeName
		END
	FROM
		#tEstDetail
		INNER JOIN tWorkType wt (nolock) ON #tEstDetail.Entity = 'tWorkType' AND #tEstDetail.EntityKey = wt.WorkTypeKey
		LEFT JOIN tWorkTypeCustom wtc (nolock) ON #tEstDetail.Entity = 'tWorkType' AND #tEstDetail.EntityKey = wtc.WorkTypeKey
			AND wtc.Entity = @ParentEntity AND wtc.EntityKey = @ParentEntityKey
	
	--Update the Level from the selected layout
	UPDATE #tEstDetail
	SET
		IndentLevel =
			CASE
				WHEN ed.Entity IN('tTitle', 'tWorkType') THEN 0 --This line type puts Title at the top of the hierarchy
				ELSE 1 --Subtract 1 because there's no Segment level
			END
	FROM
		#tEstDetail ed
	
	UPDATE #tEstDetail
	SET TotalGross = LaborGross
	WHERE Entity != 'tItem'
	
	--Now set the final order from the Hierarchy
	SELECT
		@FinalOrder = 1,
		@SortOrder = -9999
	
	--Go through the hierarchiy and set the final order
	WHILE(1=1)
	BEGIN
		SELECT TOP 1
			@EstDetailKey = EstDetailKey,
			@SortOrder = SortOrder,
			@Entity = Entity,
			@EntityKey = EntityKey
		FROM #tEstDetail
		WHERE
			IndentLevel = 0 AND
			FinalOrder IS NULL
		ORDER BY
			Entity,
			SortOrder,
			Description
		
		/*DEBUG SHOW
		SELECT
			@SortOrder,
			@Entity,
			@EntityKey
		*/
		
		IF @EstDetailKey IS NULL
			BREAK
		
		UPDATE #tEstDetail
		SET	FinalOrder = @FinalOrder
		WHERE
			EstDetailKey = @EstDetailKey
	
		SELECT @FinalOrder = @FinalOrder + 1
		SELECT @SortOrder2 = NULL
		
		WHILE(1=1)
		BEGIN
			IF @Entity = 'tWorkType'
			BEGIN
				SELECT @SortOrder2 = MIN(SortOrder)
				FROM #tEstDetail
				WHERE
					WorkTypeKey = @EntityKey AND
					FinalOrder IS NULL
				
				IF @SortOrder2 IS NULL
					BREAK
				
				UPDATE #tEstDetail
				SET	FinalOrder = @FinalOrder
				WHERE
					WorkTypeKey = @EntityKey AND
					SortOrder = @SortOrder2
			END
			IF @Entity = 'tTitle'
			BEGIN
				SELECT @SortOrder2 = SortOrder
				FROM #tEstDetail
				WHERE
					TitleKey = @EntityKey AND
					Entity = 'tService' AND
					FinalOrder IS NULL
				ORDER BY ISNULL(Subject, '')
				
				IF @SortOrder2 IS NULL
					BREAK
				
				UPDATE #tEstDetail
				SET
					FinalOrder = @FinalOrder,
					IndentLevel = 1 --tTitle is top level (0)
				WHERE
					TitleKey = @EntityKey AND
					Entity = 'tService' AND
					SortOrder = @SortOrder2 AND
					FinalOrder IS NULL
			END
			SELECT @FinalOrder = @FinalOrder + 1
			SELECT @SortOrder2 = NULL
			SELECT @EstDetailKey = NULL
		END
	END
END --End By Billing Title And Service

------------------------------------------------------------------------
	IF @GetDataBy = @BY_PROJECT
	BEGIN
		EXEC sptEstimateGetForReportLayoutP @EstimateKey
	END

------------------------------------------------------------------------
	IF @GetDataBy IN (@BY_TASK, @BY_SERVICE)
	BEGIN

		UPDATE	#tEstDetail
		SET		LaborRate =
					CASE
						WHEN LaborHours = 0 THEN 0
						ELSE LaborGross / LaborHours
					END

		UPDATE	#tEstDetail
		SET			DisplayOption = lb.DisplayOption
		FROM
			#tEstDetail ed
			INNER JOIN (
					SELECT	lb.*,
							CASE Entity
								WHEN 'tProject'	THEN 'Campaign / Project / Segment'
								WHEN 'tWorkType' THEN wt.WorkTypeName
								WHEN 'tService' THEN s.Description
								WHEN 'tItem' THEN i.ItemName
							END AS EntityName
					FROM	tLayoutBilling lb (nolock)
					LEFT JOIN tWorkType wt (nolock) ON lb.EntityKey = wt.WorkTypeKey
					LEFT JOIN tService s (nolock) ON lb.EntityKey = s.ServiceKey
					LEFT JOIN tItem i (nolock) ON lb.EntityKey = i.ItemKey
					WHERE	lb.LayoutKey = @LayoutKey
				) lb
				ON ed.Entity = lb.Entity COLLATE DATABASE_DEFAULT AND ed.EntityKey = lb.EntityKey

	END -- By task / By Service

	--Include the Header fields repeated on every detail row
	--A cartesian product is OK here because there's only one header line (so it's 1 X the detail lines)
	SELECT	h.*, d.*
	FROM	(SELECT #tEstHeader.*, #cfHeader.*
			FROM #tEstHeader
			LEFT JOIN #cfHeader ON #tEstHeader.HeaderCustomFieldKey = #cfHeader.CustomFieldKey) as h,
			#tEstDetail d
	ORDER BY d.FinalOrder
GO
