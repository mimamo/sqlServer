USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_PaymentMarkDownloaded]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  Procedure [dbo].[spvExport_PaymentMarkDownloaded]

	(
		@CompanyKey int
	)

AS --Encrypt

update tCheck
set tCheck.Downloaded = 1
from tCompany
where
	tCheck.ClientKey = tCompany.CompanyKey and
	OwnerCompanyKey = @CompanyKey
GO
