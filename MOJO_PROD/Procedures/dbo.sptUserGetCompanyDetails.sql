USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetCompanyDetails]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetCompanyDetails]
  @UserKey int,
  @CompanyKey int
  
  
AS --Encrypt

Declare @ClientProductKey int, @ClientDivisionKey int, @ReportsToKey int

if ISNULL(@UserKey, 0) > 0
	Select @CompanyKey = CompanyKey, @ClientProductKey = ClientProductKey, @ClientDivisionKey = ClientDivisionKey, @ReportsToKey = ReportsToKey from tUser (nolock) Where UserKey = @UserKey


Select * from tCompany (nolock) Where CompanyKey = @CompanyKey

-- products
Select ClientProductKey, ProductName
From tClientProduct (nolock) 
Where
	ClientKey = @CompanyKey 
	and (Active = 1 OR ClientProductKey = @ClientProductKey)
Order By ProductName

-- divisions
Select ClientDivisionKey, DivisionName
From tClientDivision (nolock) 
Where
	ClientKey = @CompanyKey 
	and (Active = 1 OR ClientDivisionKey = @ClientDivisionKey)
Order By DivisionName

-- Reports To
Select UserKey, FirstName + ' ' + LastName as UserName
From tUser (nolock) 
Where
	CompanyKey = @CompanyKey 
	and UserKey <> isnull(@UserKey,0)
	and (Active = 1 OR UserKey = @ReportsToKey)	
Order By FirstName, LastName


-- Address List
Select *, 'Company' as AddressType from tAddress (nolock)
	Where CompanyKey = @CompanyKey and Entity is null
Order By AddressName
GO
