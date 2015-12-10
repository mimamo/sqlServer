USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupClient]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLookupClient]

	(
		@CompanyKey int,
		@SearchOption int,
		@SearchPhrase varchar(200)
	)

AS

/*
|| When      Who Rel     What
|| 10/15/07  CRG 8.5     (9833) Added code to ensure @SearchPhrase is not null.
*/

SELECT	@SearchPhrase = ISNULL(@SearchPhrase, '')

if @SearchOption = 1
	Select 
		CompanyKey,
		CustomerID,
		CompanyName
	From
		tCompany (nolock)
	Where
		OwnerCompanyKey = @CompanyKey and
		Active = 1 and
		BillableClient = 1 and
		CustomerID like @SearchPhrase+'%'
	Order By CustomerID
else
	Select 
		CompanyKey,
		CustomerID,
		CompanyName
	From
		tCompany (nolock)
	Where
		OwnerCompanyKey = @CompanyKey and
		Active = 1 and
		BillableClient = 1 and
		CompanyName like @SearchPhrase+'%'
	Order By CompanyName
GO
