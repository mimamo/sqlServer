USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarValidateProject]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCalendarValidateProject]
	(
		@ProjectNumber VARCHAR(50),
		@UserKey INT
	)
AS --Encrypt

	DECLARE @Administrator INT
	       ,@CompanyKey    INT
				 ,@LookupKey int
	       
	SELECT  
		@CompanyKey = OwnerCompanyKey
	 ,@Administrator = Administrator
	FROM    
		tUser (NOLOCK)
	WHERE 
		UserKey = @UserKey
 
	IF @CompanyKey IS NULL
		SELECT  
			@CompanyKey = CompanyKey
		FROM    
			tUser (NOLOCK)
		WHERE 
			UserKey = @UserKey

		if @Administrator = 1
			
			SELECT @LookupKey = ProjectKey 
			FROM 
				tProject p (NOLOCK)
			WHERE p.Active  = 1 -- @Active
				AND  p.Deleted  = 0
				AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
				AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber)))
				
	ELSE
		       
			SELECT @LookupKey = p.ProjectKey
			FROM 
				tProject p (NOLOCK),
				tAssignment a (NOLOCK)
			WHERE 
				a.UserKey  =@UserKey
				AND  a.ProjectKey =p.ProjectKey
				AND  p.Active  = 1 -- @Active
				AND  p.Deleted  = 0
				AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
				AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber)))
	
	IF @LookupKey IS NOT NULL	
		RETURN @LookupKey
	ELSE
		RETURN -1	
	
	/* set nocount on */
	return 1
GO
