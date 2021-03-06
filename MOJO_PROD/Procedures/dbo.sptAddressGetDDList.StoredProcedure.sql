USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAddressGetDDList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAddressGetDDList]
	(
	@AddressKey int
	,@CompanyKey int
	,@Entity varchar(50) 
	,@EntityName varchar(250) 
	,@EntityKey int
	)
AS -- Encrypt
	SET NOCOUNT ON

  /*
  || When       Who Rel      What
  || 11/23/09   GHL 10.5.1.4 Get all info instead of AddressKey, AddressName for flex edit buttons
  || 03/20/13   MFT 10.5.6.7 (172336) Separated the ParentCompany query/label into its own query for clarity
  */

	-- Should return
	-- Current address if any
	-- All addresses for parent company and sibling companies
	-- All addresses for contact/entity
	
	-- Inits
	
	DECLARE @ParentCompanyKey int
			,@AddressEntityName VARCHAR(250)
					
	SELECT @ParentCompanyKey = ParentCompanyKey
	FROM   tCompany (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	
	SELECT @ParentCompanyKey = ISNULL(@ParentCompanyKey, 0)
	SELECT @AddressKey = ISNULL(@AddressKey, 0) -- will simplify the queries below
	
	-- Need to display correct enity for AddressKey
	SELECT @AddressEntityName = Entity
	FROM   tAddress (NOLOCK)
	WHERE  AddressKey = @AddressKey 
	
	IF @AddressEntityName = @Entity
		SELECT @AddressEntityName = '['+@EntityName+']'
	ELSE
		SELECT @AddressEntityName = '[Company]'
	
	-- Now main queries
	
	SELECT *, CAST(@AddressEntityName + '/' +AddressName AS VARCHAR(250)) AS DDAddressName
		   ,0 as DisplayOrder	
	FROM   tAddress (NOLOCK)
	WHERE  AddressKey = @AddressKey
	
	UNION ALL
	
	SELECT a.*, CAST('[Company]/' + a.AddressName AS VARCHAR(250)) AS DDAddressName
		   ,1 as DisplayOrder	
	FROM   tAddress a (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON a.CompanyKey = c.CompanyKey
	WHERE c.CompanyKey = @CompanyKey 
	AND   a.Entity IS NULL
	AND   a.AddressKey <> @AddressKey 
	AND   a.Active = 1
	
	UNION ALL
	
	SELECT a.*, CAST('[Parent Company]/' + a.AddressName AS VARCHAR(250)) AS DDAddressName
		   ,1 as DisplayOrder	
	FROM   tAddress a (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON a.CompanyKey = c.CompanyKey
	WHERE @ParentCompanyKey <> 0
	AND   c.CompanyKey = @ParentCompanyKey
	AND   a.Entity IS NULL
	AND   a.AddressKey <> @AddressKey 
	AND   a.Active = 1
			
	UNION ALL
	
	SELECT *, CAST('['+@EntityName +']/' + AddressName AS VARCHAR(250)) AS DDAddressName
		   ,2 as DisplayOrder				
	FROM   tAddress (NOLOCK) 
	WHERE  Entity = ISNULL(@Entity, 0)
	AND    Entity IS NOT NULL
	AND    EntityKey = @EntityKey
	AND    AddressKey <> @AddressKey 
	AND    Active = 1
	
	ORDER BY DisplayOrder, DDAddressName
		
	RETURN 1
GO
