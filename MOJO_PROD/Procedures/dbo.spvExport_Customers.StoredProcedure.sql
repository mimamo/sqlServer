USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_Customers]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_Customers]
	(
		@CompanyKey int,
		@IncludeDownloaded tinyint = 0
	)

AS --Encrypt


if @IncludeDownloaded = 1
	Select * from vExport_Contact (NOLOCK)
	Where
		OwnerCompanyKey = @CompanyKey and
		BillableClient = 1
else
	Select * from vExport_Contact (NOLOCK)
	Where
		OwnerCompanyKey = @CompanyKey and
		BillableClient = 1 and
		ClientDownloadFlag = 0
GO
