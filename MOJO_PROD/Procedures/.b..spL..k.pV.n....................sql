USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupVendor]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLookupVendor]

	(
		@CompanyKey int,
		@SearchOption int,
		@SearchPhrase varchar(200)
	)

AS

/*
|| When      Who Rel     What
|| 8/8/07    CRG 8.5     (9833) Added code to ensure @SearchPhrase is not null. Also fixed the sort to VendorID.
*/

SELECT	@SearchPhrase = ISNULL(@SearchPhrase, '')

if @SearchOption = 1
	Select 
		CompanyKey,
		VendorID,
		CompanyName
	From
		tCompany (nolock)
	Where
		OwnerCompanyKey = @CompanyKey and
		Active = 1 and
		Vendor = 1 and
		VendorID like @SearchPhrase+'%'
	Order By VendorID
else
	Select 
		CompanyKey,
		VendorID,
		CompanyName
	From
		tCompany (nolock)
	Where
		OwnerCompanyKey = @CompanyKey and
		Active = 1 and
		Vendor = 1 and
		CompanyName like @SearchPhrase+'%'
	Order By CompanyName
GO
