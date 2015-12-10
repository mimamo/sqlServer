USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyValidClient]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCompanyValidClient]

	(
		@CompanyKey int,
		@CustomerID varchar(50),
		@ActiveOnly tinyint = 1
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 10/15/09 GHL 10.512 (65539) Added check of BillableClient
  ||                      Issue was that 2 companies with same CustomerID are entered
  ||                      The first has BillableClient = 1
  ||                      The second has BillableClient = 0
  ||                      sptCompanyUpdateAccountingInfo lets you enter this situation
  ||                      This sp was picking up wrong second company
  */
  
declare @SearchCompanyKey int

if @ActiveOnly = 1
	Select @SearchCompanyKey = CompanyKey
	from tCompany c (nolock)
	Where
		c.OwnerCompanyKey = @CompanyKey and
		c.CustomerID = @CustomerID and
		c.BillableClient = 1 and
		c.Active = 1
else
	Select @SearchCompanyKey = CompanyKey
	from tCompany c (nolock)
	Where
		c.OwnerCompanyKey = @CompanyKey and
		c.CustomerID = @CustomerID and
		c.BillableClient = 1 
		
Return isnull(@SearchCompanyKey, 0)
GO
