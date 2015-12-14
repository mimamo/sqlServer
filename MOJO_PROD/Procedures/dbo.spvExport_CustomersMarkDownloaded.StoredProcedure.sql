USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_CustomersMarkDownloaded]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spvExport_CustomersMarkDownloaded]

	(
		@CompanyKey int
	)

AS --Encrypt


Update tCompany
Set ClientDownloaded = 1
Where
	OwnerCompanyKey = @CompanyKey and
	BillableClient = 1 and
	(ClientDownloaded is null or ClientDownloaded = 0)
GO
