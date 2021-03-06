USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarGetForms]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCalendarGetForms]
	(
		@StartDate VARCHAR(10),
		@EndDate VARCHAR(10),
		@UserKey INT,
		@ProjectKey INT,
		@FormFlag INT	-- 0 No, 1 My Forms, 2 All Forms
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN
*/

	IF @FormFlag = 0
		RETURN 1
		
	DECLARE @CompanyKey INT
	
	SELECT @CompanyKey = OwnerCompanyKey
	FROM   tUser (NOLOCK)
	WHERE  UserKey = @UserKey
	
	IF @CompanyKey IS NULL
		SELECT @CompanyKey = CompanyKey
		FROM   tUser (NOLOCK)
		WHERE  UserKey = @UserKey		
	
	/*
	CREATE TABLE #tForm (
		FormKey INT	NULL
		,FormName VARCHAR(100) NULL
		,FormNumber VARCHAR(100) NULL
		,ProjectNumber VARCHAR(100) NULL
		,Subject VARCHAR(150) NULL
		,DueDate DATETIME NULL
		,DisplayColor VARCHAR(20) NULL)
	*/
		
	IF @FormFlag = 1	-- My Forms
	BEGIN
		INSERT #tForm
		SELECT	f.FormKey
					 ,fd.FormName
		       ,ISNULL(fd.FormPrefix+'-', '')+ISNULL(CONVERT(VARCHAR(100),f.FormNumber), '') 
					 ,p.ProjectNumber
					 ,f.Subject
					 ,f.DueDate
					 ,ISNULL(fd.DisplayColor, '#ffffff')
		FROM		tForm    f  (NOLOCK)
		       INNER JOIN tFormDef fd (NOLOCK) ON f.FormDefKey = fd.FormDefKey
		       LEFT OUTER JOIN tProject p  (NOLOCK) ON f.ProjectKey = p.ProjectKey
		WHERE   (f.ProjectKey = @ProjectKey OR @ProjectKey IS NULL)
		AND     f.AssignedTo = @UserKey
		AND		f.DueDate >= @StartDate
		AND     f.DueDate <= @EndDate    
		AND     f.DateClosed IS NULL
	END
	ELSE
	BEGIN						-- All Forms
		INSERT #tForm
		SELECT	f.FormKey
		       ,fd.FormName
		       ,ISNULL(fd.FormPrefix+'-', '')+ISNULL(CONVERT(VARCHAR(100),f.FormNumber), '')
					 ,p.ProjectNumber
					 ,f.Subject
					 ,f.DueDate
					 ,ISNULL(fd.DisplayColor, '#ffffff')
		FROM		tForm    f  (NOLOCK)
		       INNER JOIN tFormDef fd (NOLOCK) ON f.FormDefKey = fd.FormDefKey
		       LEFT OUTER JOIN tProject p  (NOLOCK) ON f.ProjectKey = p.ProjectKey
		WHERE   (f.ProjectKey = @ProjectKey OR @ProjectKey IS NULL)
		AND     f.CompanyKey = @CompanyKey
		AND		f.DueDate >= @StartDate
		AND     f.DueDate <= @EndDate    
		AND     f.DateClosed IS NULL
		AND     (f.ProjectKey IS NULL OR f.ProjectKey IN (SELECT ProjectKey FROM   tAssignment (NOLOCK) WHERE  UserKey = @UserKey) )		
	END
	 
	--select * from #tForm
	
	/* set nocount on */
	return 1
GO
