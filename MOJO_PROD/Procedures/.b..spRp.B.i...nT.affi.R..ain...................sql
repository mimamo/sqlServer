USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptBrittonTrafficRetainer]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptBrittonTrafficRetainer]
	(
	 @CompanyKey int
    ,@ClientID varchar(50)
    ,@CampaignID varchar(50)
	,@StartDate smalldatetime
	,@EndDate smalldatetime
	)
AS

  /*
  || When     Who Rel    What
  || 09/04/14 WDF 10.584 (225597) Custom Report for Britton
 */

	SET NOCOUNT ON
	--
	--  Generate Custom Field Data
	--
	create table #cf1 
	(CustomFieldKey int null
	,[CF_VeraPM] varchar(8000) null
	,[CF_VeraPM_CF_VeraPM] varchar(8000) null
	,[CF_FirstProof] datetime null
	,[CF_FirstProof_CF_FirstProof] datetime null)
 
	create index tempcfidx1 on #cf1(CustomFieldKey)
 
	INSERT INTO #cf1 (CustomFieldKey) 
	SELECT CustomFieldKey 
	  FROM tProject (nolock) 
	 WHERE CustomFieldKey > 0 
	   AND CompanyKey = @CompanyKey
    
	UPDATE #cf1 
	   SET [CF_VeraPM] = FieldValue
	      ,[CF_VeraPM_CF_VeraPM] = FieldValue2 
	  FROM vCFValues 
	 WHERE vCFValues.FieldName = 'VeraPM' 
	   AND EntityKey = @CompanyKey
	   AND Entity = 'General' 
	   AND #cf1.CustomFieldKey = vCFValues.CustomFieldKey 
	   AND LEN(ISNULL(FieldValue, '')) > 0

	UPDATE #cf1 
	   SET [CF_FirstProof] = FieldValue
	      ,[CF_FirstProof_CF_FirstProof] = FieldValue2 
	  FROM vCFValues 
	 WHERE vCFValues.FieldName = 'FirstProof' 
	   AND EntityKey = @CompanyKey
	   AND Entity = 'General' 
	   AND #cf1.CustomFieldKey = vCFValues.CustomFieldKey 
	   AND LEN(ISNULL(FieldValue, '')) > 0
	        
	--
	--  Generate data using only the End Date 
	--
	SELECT [Project Full Name]  
		 , [Account Manager]  
		 , isnull(#cf1.[CF_VeraPM], '') as [CF_VeraPM]  
		 , [Project Start Date]  
		 , cast (#cf1.[CF_FirstProof] as datetime) as [CF_FirstProof]  
		 , [Project Due Date]  
		 , [Project Status]  
		 , sum([Actual Hours Worked]) as [Actual Hours Worked]  
		 , isnull([Client Project Number], '00-000-0000') AS [Client Project Number]
	  INTO #Temp1
	  FROM vReport_TimeDetailNoCost left outer join #cf1 on vReport_TimeDetailNoCost.CustomFieldKey = #cf1.CustomFieldKey   
	 WHERE CompanyKey = @CompanyKey
	   AND ( (@EndDate is null or [Date Worked] >= @EndDate)
	   AND   (@EndDate is null or [Date Worked] <= @EndDate)
	   AND   (@ClientID is null or [Client ID] = @ClientID)
	   AND   (@CampaignID is null or [Campaign ID] = @CampaignID))
  GROUP BY   [Client Project Number]
			,[Project Full Name]
			,[Account Manager]
			,[CF_VeraPM]
			,[Project Start Date]
			,[CF_FirstProof]
			,[Project Due Date]
			,[Project Status] 
  ORDER BY [Client Project Number], [Project Full Name] ASC 
	--
	--  Generate data using the Begin/End dates
	--
	SELECT [Project Full Name]  
		 , [Account Manager]  
		 , isnull(#cf1.[CF_VeraPM], '') as [CF_VeraPM]  
		 , [Project Start Date]  
		 , cast (#cf1.[CF_FirstProof] as datetime) as [CF_FirstProof]  
		 , [Project Due Date]  
		 , [Project Status]  
		 , sum([Actual Hours Worked]) as [Actual Hours Worked]  
		 , isnull([Client Project Number], '00-000-0000') AS [Client Project Number]
	  INTO #Temp2
	  FROM vReport_TimeDetailNoCost left outer join #cf1 on vReport_TimeDetailNoCost.CustomFieldKey = #cf1.CustomFieldKey   
	 WHERE CompanyKey = @CompanyKey
	   AND ( (@StartDate is null or [Date Worked] >= @StartDate)
	   AND   (@EndDate is null or [Date Worked] <= @EndDate)
	   AND   (@ClientID is null or [Client ID] = @ClientID)
	   AND   (@CampaignID is null or [Campaign ID] = @CampaignID))
  GROUP BY   [Client Project Number]
			,[Project Full Name]
			,[Account Manager]
			,[CF_VeraPM]
			,[Project Start Date]
			,[CF_FirstProof]
			,[Project Due Date]
			,[Project Status] 
  ORDER BY [Client Project Number], [Project Full Name] ASC 
	--
	--  Generate a Single dataset containing only those records present in the 'One Day' Report
	--  while using the 'Actual Hours Worked' from both reports
	--
	SELECT t1.[Project Full Name] as ProjectFullName
	      ,t1.[Account Manager] as AccountManager
	      ,t1.CF_VeraPM
	      ,t1.[Project Start Date] as ProjectStartDate
	      ,t1.CF_FirstProof
	      ,t1.[Project Due Date] as ProjectDueDate
	      ,t1.[Project Status] as ProjectStatus
	      ,t1.[Actual Hours Worked] as HoursWorkedDay
	      ,t2.[Actual Hours Worked] as HoursWorkedSpan
	      ,CASE t1.[Client Project Number]
	          WHEN '00-000-0000' THEN NULL
	          ELSE t1.[Client Project Number]
	       END as ClientProjectNumber

	 FROM #Temp1 t1 INNER JOIN #Temp2 t2 ON (t1.[Client Project Number] = t2.[Client Project Number] AND
										     t1.[Project Full Name]     = t2.[Project Full Name])
GO
