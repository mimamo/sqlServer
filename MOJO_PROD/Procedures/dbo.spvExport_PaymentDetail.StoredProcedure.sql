USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_PaymentDetail]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_PaymentDetail]

	(
		@CompanyKey int,
		@IncludeDownloaded tinyint = 0
	)

AS --Encrypt

select 
	* 
from 
	vExport_PaymentDetail (NOLOCK)
where
	CompanyKey = @CompanyKey and
	Downloaded <= @IncludeDownloaded
GO
