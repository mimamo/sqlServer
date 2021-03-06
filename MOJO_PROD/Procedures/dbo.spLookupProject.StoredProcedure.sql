USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupProject]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spLookupProject]
	(
		@ProjectNumber VARCHAR(50),
		@CompanyKey INT,
		@UserKey int
	)
AS --Encrypt
			
		IF @ProjectNumber IS NULL

			SELECT p.*
			      ,c.CustomerID
				  ,c.CompanyName
				  ,ps.ProjectStatus
			FROM 
				tProject p (nolock) 
				inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
				left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
				inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			WHERE 
				a.UserKey = @UserKey
				AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
			ORDER BY 
				ProjectNumber ASC			
	   
	   ELSE
								     
			SELECT p.*
				    ,c.CustomerID
					,c.CompanyName
					,ps.ProjectStatus
			FROM 
				tProject p (nolock) 
				inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
				left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
				inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			WHERE 
				a.UserKey = @UserKey
				AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
				AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber))) + '%'
			ORDER BY 
				ProjectNumber ASC			
	
		
	/* set nocount on */
	return 1
GO
