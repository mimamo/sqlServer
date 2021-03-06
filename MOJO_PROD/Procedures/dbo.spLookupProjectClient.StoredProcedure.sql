USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupProjectClient]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spLookupProjectClient]
	(
		@ProjectNumber VARCHAR(50),
		@UserKey INT,
		@ClientKey INT
	)
AS --Encrypt


if @ClientKey = 0  -- No Client Restriction
			
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
				AND p.Active  = 1 -- @Active
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
				AND  p.Active = 1 -- @Active
				AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber))) + '%'

ELSE
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
				AND p.Closed  = 0 
				AND p.ClientKey = @ClientKey
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
				AND p.Closed  = 0 
				AND p.ClientKey = @ClientKey
				AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber))) + '%'

		
	/* set nocount on */
	return 1
GO
