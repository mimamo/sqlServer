USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemGetLookupList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemGetLookupList]

	@CompanyKey int,
	@ItemType smallint,
	@ItemID varchar(50),
	@GLCompanyKey int = null,
	@VendorID varchar(50) = null


AS --Encrypt

  /*
  || When     Who Rel    What
  || 01/03/07 GHL 8.4    Added search of ItemName and StandardDescription 
  || 10/30/12 RLB 10.561 HMI changes
  || 11/26/14 GAR 10.586 (224898) Added code to accept a VendorID and use that to get a list of GL Companies that 
  ||					 vendor has access to, and use that to limit the list of items.
  || 12/16/14 QMD 10.586 Fixed default on declare @VendorKey
  */

  --GL Company restrictions
DECLARE @RestrictToGLCompany tinyint

SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey
  
DECLARE @VendorKey int 
SET @VendorKey = -1
IF NOT @VendorID IS NULL AND @RestrictToGLCompany <> 0
BEGIN
	SET @VendorKey = (SELECT CompanyKey FROM tCompany (nolock) WHERE VendorID = @VendorID AND OwnerCompanyKey = @CompanyKey)
END

if @RestrictToGLCompany = 0
BEGIN
	if @ItemType = -1
		SELECT i.*
		FROM tItem i (nolock)
		WHERE
		i.CompanyKey = @CompanyKey and
		Active = 1 and
		(
		 ItemID like @ItemID +'%'
		 OR
		 ItemName like '%' + @ItemID + '%'
		 OR
		 StandardDescription like '%' + @ItemID + '%'
		) 
		Order By ItemName
	else
		SELECT i.*
		FROM tItem i (nolock)
		WHERE
		i.CompanyKey = @CompanyKey and
		i.ItemType = @ItemType and 
		Active = 1 and
		(
		 ItemID like @ItemID +'%'
		 OR
		 ItemName like '%' + @ItemID + '%'
		 OR
		 StandardDescription like '%' + @ItemID + '%'
		) 
		Order By ItemName
END
ELSE
BEGIN
	if @ItemType = -1
		SELECT i.*
		FROM tItem i (nolock)
		INNER JOIN tGLCompanyAccess glca (nolock) on i.ItemKey = glca.EntityKey AND glca.Entity = 'tItem'
		WHERE
		i.CompanyKey = @CompanyKey and
		Active = 1 and
		(glca.GLCompanyKey = @GLCompanyKey 
			or (@VendorKey <> -1 and glca.CompanyKey in (SELECT GLCompanyKey FROM tGLCompanyAccess (nolock) WHERE Entity = 'tCompany' AND EntityKey = @VendorKey AND CompanyKey = @CompanyKey))) and
		(
		 ItemID like @ItemID +'%'
		 OR
		 ItemName like '%' + @ItemID + '%'
		 OR
		 StandardDescription like '%' + @ItemID + '%'
		) 
		Order By ItemName
	else
		SELECT i.*
		FROM tItem i (nolock)
		INNER JOIN tGLCompanyAccess glca (nolock) on i.ItemKey = glca.EntityKey AND glca.Entity = 'tItem'
		WHERE
		i.CompanyKey = @CompanyKey and
		i.ItemType = @ItemType and 
		Active = 1 and
		(glca.GLCompanyKey = @GLCompanyKey 
			or (@VendorKey <> -1 and glca.GLCompanyKey in (SELECT GLCompanyKey FROM tGLCompanyAccess (nolock) WHERE Entity = 'tCompany' AND EntityKey = @VendorKey AND CompanyKey = @CompanyKey))) and
		(
		 ItemID like @ItemID +'%'
		 OR
		 ItemName like '%' + @ItemID + '%'
		 OR
		 StandardDescription like '%' + @ItemID + '%'
		) 
		Order By ItemName
END




		

	RETURN 1
GO
