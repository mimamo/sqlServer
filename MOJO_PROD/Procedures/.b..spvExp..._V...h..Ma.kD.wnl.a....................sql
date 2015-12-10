USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_VoucherMarkDownloaded]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_VoucherMarkDownloaded]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime
	)

AS --Encrypt


IF @StartDate IS NULL
 Select @StartDate = '1/1/1990'
 
 
IF @EndDate IS NULL
 Select @EndDate = GETDATE()

update tVoucher
set Downloaded = 1
where
	CompanyKey = @CompanyKey and
	InvoiceDate >= @StartDate and
	InvoiceDate <= @EndDate and
	Status = 4
GO
