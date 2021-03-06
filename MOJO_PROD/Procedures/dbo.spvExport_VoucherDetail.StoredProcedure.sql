USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_VoucherDetail]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_VoucherDetail]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@IncludeDownloaded tinyint = 0
	)

AS --Encrypt


IF @StartDate IS NULL
 Select @StartDate = '1/1/1990'
 
 
IF @EndDate IS NULL
 Select @EndDate = GETDATE()


select 
	* 
from 
	vExport_VoucherDetail (NOLOCK)
where
	CompanyKey = @CompanyKey and
	InvoiceDate >= @StartDate and
	InvoiceDate <= @EndDate and
	Downloaded <= @IncludeDownloaded and
	Status = 4
GO
