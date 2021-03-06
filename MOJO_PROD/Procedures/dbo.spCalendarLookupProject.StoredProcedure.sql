USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarLookupProject]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCalendarLookupProject]
	(
		@ProjectNumber VARCHAR(50),
		@UserKey INT
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN
*/

	DECLARE @Administrator INT
	       ,@CompanyKey    INT
		   ,@Count         INT
	
	/*
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
			
			IF @ProjectNumber IS NULL
			SELECT p.*
			      ,c.CustomerID
				,c.CompanyName
			FROM 
				tProject p,
				tCompany c
			WHERE 
				     p.ClientKey  *=c.CompanyKey
				AND  p.Active  = 1 -- @Active
				AND  p.Deleted  = 0
				AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
			ORDER BY 
				ProjectNumber ASC
			
			ELSE
			BEGIN
			
			SELECT @Count = COUNT(p.ProjectKey)
			FROM 
				tProject p
			WHERE p.Active  = 1 -- @Active
				AND  p.Deleted  = 0
				AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
				AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber))) + '%'
			
			IF @Count = 1 

						SELECT p.*
						      ,c.CustomerID
						      ,c.CompanyName
						FROM 
							tProject p,
							tCompany c
						WHERE 
							     p.ClientKey  *=c.CompanyKey
							AND  p.Active  = 1 -- @Active
							AND  p.Deleted  = 0
							AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
						ORDER BY 
							ProjectNumber ASC

				ELSE
									
					SELECT p.*
					      ,c.CustomerID
					      ,c.CompanyName
					FROM 
						tProject p,
						tCompany c
					WHERE 
						     p.ClientKey  *=c.CompanyKey
						AND  p.Active  = 1 -- @Active
						AND  p.Deleted  = 0
						AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
						AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber))) + '%'
					ORDER BY 
						ProjectNumber ASC
			
			END
				
	ELSE
		    */
		    
		-- New stuff
		
		SELECT  
			@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
		FROM    
			tUser (NOLOCK)
		WHERE 
			UserKey = @UserKey
			
		IF @ProjectNumber IS NULL

			SELECT p.*
			      ,c.CustomerID
				  ,c.CompanyName
			FROM 
				tAssignment a (NOLOCK)
				INNER JOIN tProject p (NOLOCK) ON a.ProjectKey =p.ProjectKey
				LEFT OUTER JOIN tCompany c (NOLOCK) ON p.ClientKey =c.CompanyKey
			WHERE 
				a.UserKey  =@UserKey
				AND  p.Active  = 1 -- @Active
				AND  p.Deleted  = 0
				AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
			ORDER BY 
				ProjectNumber ASC			
	   
	   ELSE
	   BEGIN
	  
			SELECT @Count = count(p.ProjectKey)
			FROM tAssignment a (NOLOCK) 
				INNER JOIN tProject p (NOLOCK) ON a.ProjectKey =p.ProjectKey
			WHERE 
				a.UserKey  =@UserKey
				AND  p.Active  = 1 -- @Active
				AND  p.Deleted  = 0
				AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
				AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber))) + '%'
			
			IF @Count = 1
				SELECT p.*
				      ,c.CustomerID
					,c.CompanyName
				FROM 
					tAssignment a (NOLOCK)
					INNER JOIN tProject p (NOLOCK) ON a.ProjectKey =p.ProjectKey
					LEFT OUTER JOIN tCompany c (NOLOCK) ON p.ClientKey  =c.CompanyKey
				WHERE 
					a.UserKey  =@UserKey
					AND  p.Deleted  = 0
					AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
				ORDER BY 
					ProjectNumber ASC			

			ELSE
								     
				SELECT p.*
				      ,c.CustomerID
					,c.CompanyName
				FROM 
					tAssignment a (NOLOCK)
					INNER JOIN tProject p (NOLOCK) ON a.ProjectKey =p.ProjectKey
					LEFT OUTER JOIN tCompany c (NOLOCK) ON p.ClientKey  =c.CompanyKey
				WHERE 
					a.UserKey  =@UserKey
					AND  p.Active  = 1 -- @Active
					AND  p.Deleted  = 0
					AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
					AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber))) + '%'
				ORDER BY 
					ProjectNumber ASC			
	
		END
		
	/* set nocount on */
	return 1
GO
