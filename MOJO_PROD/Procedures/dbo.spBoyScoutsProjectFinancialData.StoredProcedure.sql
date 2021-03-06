USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBoyScoutsProjectFinancialData]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBoyScoutsProjectFinancialData]
	@StartDate smalldatetime,
	@EndDate smalldatetime
AS

/*
|| When      Who Rel      What
|| 4/16/13   CRG 10.5.6.7 (169622) Created for customization
*/

	--Custom Field logic copied from Custom Report code
	create table #cf1 
		(CustomFieldKey int null, 
		[CF_BusUnit] varchar(8000) null, 
		[CF_AccountNumber] varchar(8000) null, 
		[CF_CenterNumber] varchar(8000) null)
	create index tempcfidx1 on #cf1(CustomFieldKey)

	Insert Into #cf1 (CustomFieldKey) 
	Select	CustomFieldKey 
	from	tProject (nolock) 
	Where	CustomFieldKey > 0 
	and		CompanyKey = 104940

	update	#cf1 
	set		[CF_BusUnit] = FieldValue 
	From	vCFValues 
	Where	vCFValues.FieldName = 'BusUnit' 
	and		EntityKey = 104940 
	and		Entity = 'General' 
	and		#cf1.CustomFieldKey = vCFValues.CustomFieldKey 
	AND		LEN(ISNULL(FieldValue, '')) > 0
	
	update	#cf1 
	set		[CF_AccountNumber] = FieldValue 
	From	vCFValues 
	Where	vCFValues.FieldName = 'AccountNumber' 
	and		EntityKey = 104940 
	and		Entity = 'General' 
	and		#cf1.CustomFieldKey = vCFValues.CustomFieldKey 
	AND		LEN(ISNULL(FieldValue, '')) > 0
	
	update	#cf1 
	set		[CF_CenterNumber] = FieldValue 
	From	vCFValues 
	Where	vCFValues.FieldName = 'CenterNumber' 
	and		EntityKey = 104940 
	and		Entity = 'General' 
	and		#cf1.CustomFieldKey = vCFValues.CustomFieldKey 
	AND		LEN(ISNULL(FieldValue, '')) > 0

	CREATE TABLE #Rpt
		(SortField smallint NULL,
		BU varchar(50) NULL,
		Cent_Acct varchar(50) NULL,
		JobNum varchar(50) NULL,
		Sum_Costs money NULL)

	INSERT	#Rpt
			(SortField,
			BU,
			Cent_Acct,
			JobNum,
			Sum_Costs)
	SELECT	
			CASE 
				WHEN UPPER(ISNULL(#cf1.[CF_BusUnit], '')) = 'BSANC' THEN 0
				ELSE 1
			END,
			ISNULL(#cf1.[CF_BusUnit], ''), 
			ISNULL(#cf1.[CF_CenterNumber], '') + '-' + ISNULL(#cf1.[CF_AccountNumber], ''), 
			[Project Number], 
			SUM([Billable Amount])
	FROM	vReport_Transactions 
	LEFT OUTER JOIN #cf1 ON vReport_Transactions.CustomFieldKey = #cf1.CustomFieldKey 
	WHERE	CompanyKey = 104940 
	AND		[Transferred Out] = 'NO' 
	AND		[Marked as Billed] = 'NO' 
	AND		[Project Number] <> 'T-Nonbillable' 
	AND		[Transaction Department] <> '5220'
	AND		TransactionDate BETWEEN @StartDate AND @EndDate
	GROUP BY [CF_BusUnit], [CF_CenterNumber], [CF_AccountNumber], [Project Number]
	
	INSERT	#Rpt
			(SortField,
			BU,
			Cent_Acct,
			JobNum,
			Sum_Costs)
	SELECT	0,
			'BSANC',  --Rate Level 5 desdcription from tService is always BSANC
			ISNULL([Transaction Department], '') + '-79074', --Rate Level 4 description from tService is always 79074
			'000000',
			SUM(ISNULL([Billable Amount], 0) * -1)
	FROM	vReport_Transactions
	WHERE	CompanyKey = 104940 
	AND		[Transferred Out] = 'NO' 
	AND		[Marked as Billed] = 'NO' 
	AND		[Project Number] <> 'T-Nonbillable' 
	AND		[Transaction Department] <> '5220'
	AND		TransactionDate BETWEEN @StartDate AND @EndDate
	GROUP BY [Transaction Department]
	
	DELETE	#Rpt
	WHERE	ISNULL(Sum_Costs, 0) = 0

	SELECT	*
	FROM	#Rpt
	ORDER BY SortField, BU, Cent_Acct
GO
