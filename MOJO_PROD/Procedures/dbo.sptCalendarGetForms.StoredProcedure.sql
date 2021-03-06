USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetForms]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetForms]
	(
		@UserKey int,
		@CompanyKey int, 
		@ProjectKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@FormFlag int	-- 1 My Forms, 2 All Forms
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 11/26/07 GHL 8.5   Removed non ANSI joins for SQL 2005 
  */
  
IF @ProjectKey > 0
BEGIN
	IF @FormFlag = 1	-- My Forms
	BEGIN
		SELECT	f.FormKey
				,fd.FormName
				,fd.FormPrefix
				,f.FormDefKey
				,ISNULL(fd.FormPrefix+'-', '')+ISNULL(CONVERT(VARCHAR(100),f.FormNumber), '') as FormNumber 
				,p.ProjectNumber
				,f.Subject
				,f.DueDate
				,ISNULL(fd.DisplayColor, '#ffffff') as FormColor
		FROM	tForm    f  (NOLOCK)
		       INNER JOIN tFormDef fd (NOLOCK) ON f.FormDefKey = fd.FormDefKey
		       LEFT OUTER JOIN tProject p (NOLOCK) ON f.ProjectKey = p.ProjectKey
		WHERE   f.ProjectKey = @ProjectKey
		AND     f.AssignedTo = @UserKey
		AND		f.DueDate >= @StartDate
		AND     f.DueDate <= @EndDate    
		AND     f.DateClosed IS NULL
	END
	
	IF @FormFlag = 2	-- My Forms
	BEGIN						-- All Forms
		SELECT	f.FormKey
				,fd.FormName
				,fd.FormPrefix
				,f.FormDefKey
				,ISNULL(fd.FormPrefix+'-', '')+ISNULL(CONVERT(VARCHAR(100),f.FormNumber), '') as FormNumber 
				,p.ProjectNumber
				,f.Subject
				,f.DueDate
				,ISNULL(fd.DisplayColor, '#ffffff') as FormColor
		FROM	tForm    f  (NOLOCK)
		       INNER JOIN tFormDef fd (NOLOCK) ON f.FormDefKey = fd.FormDefKey
		       LEFT OUTER JOIN tProject p (NOLOCK) ON f.ProjectKey = p.ProjectKey
		WHERE   f.ProjectKey = @ProjectKey
		AND     f.CompanyKey = @CompanyKey
		AND		f.DueDate >= @StartDate
		AND     f.DueDate <= @EndDate    
		AND     f.DateClosed IS NULL
		AND     (f.ProjectKey IS NULL OR f.ProjectKey IN (SELECT ProjectKey FROM tAssignment (NOLOCK) WHERE  UserKey = @UserKey) )		
	END
	 
END
ELSE
BEGIN

	IF @FormFlag = 1	-- My Forms
	BEGIN
		SELECT	f.FormKey
				,fd.FormName
				,fd.FormPrefix
				,ISNULL(fd.FormPrefix+'-', '')+ISNULL(CONVERT(VARCHAR(100),f.FormNumber), '') as FormNumber 
				,p.ProjectNumber
				,f.Subject
				,f.DueDate
				,ISNULL(fd.DisplayColor, '#ffffff') as FormColor
		FROM	tForm    f  (NOLOCK)
		       INNER JOIN tFormDef fd (NOLOCK) ON f.FormDefKey = fd.FormDefKey
		       LEFT OUTER JOIN tProject p (NOLOCK) ON f.ProjectKey = p.ProjectKey
		WHERE   f.AssignedTo = @UserKey
		AND		f.DueDate >= @StartDate
		AND     f.DueDate <= @EndDate    
		AND     f.DateClosed IS NULL
	END
	
	IF @FormFlag = 2	-- My Forms
	BEGIN						-- All Forms
		SELECT	f.FormKey
				,fd.FormName
				,fd.FormPrefix
				,ISNULL(fd.FormPrefix+'-', '')+ISNULL(CONVERT(VARCHAR(100),f.FormNumber), '') as FormNumber 
				,p.ProjectNumber
				,f.Subject
				,f.DueDate
				,ISNULL(fd.DisplayColor, '#ffffff') as FormColor
		FROM	tForm    f  (NOLOCK)
		       INNER JOIN tFormDef fd (NOLOCK) ON f.FormDefKey = fd.FormDefKey
		       LEFT OUTER JOIN tProject p (NOLOCK) ON f.ProjectKey = p.ProjectKey
		WHERE   f.CompanyKey = @CompanyKey
		AND		f.DueDate >= @StartDate
		AND     f.DueDate <= @EndDate    
		AND     f.DateClosed IS NULL
		AND     (f.ProjectKey IS NULL OR f.ProjectKey IN (SELECT ProjectKey FROM tAssignment (NOLOCK) WHERE  UserKey = @UserKey) )		
	END

END
	
	/* set nocount on */
	return 1
GO
