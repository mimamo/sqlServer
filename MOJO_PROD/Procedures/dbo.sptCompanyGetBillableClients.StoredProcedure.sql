USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetBillableClients]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCompanyGetBillableClients]
 (
  @CompanyKey int,
  @ClientKey int = NULL
 )
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	Select	CompanyName,
			CompanyKey
	From	tCompany (nolock)
	Where	OwnerCompanyKey = @CompanyKey 
	AND		((Active = 1 AND BillableClient = 1) OR CompanyKey = @ClientKey)
	Order By CustomerID
  
	return 1
GO
