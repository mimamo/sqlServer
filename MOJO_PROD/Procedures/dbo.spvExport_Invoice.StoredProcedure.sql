USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_Invoice]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_Invoice]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@IncludeDownloaded tinyint = 0
	)

AS --Encrypt

Declare @AdvBillItemID varchar(100)
Declare @AdvBillGLAccount varchar(100)

IF @StartDate IS NULL
 Select @StartDate = '1/1/1990'
 
 
IF @EndDate IS NULL
 Select @EndDate = GETDATE()

Select @AdvBillItemID = WorkTypeID, @AdvBillGLAccount = AccountNumber
From tPreference p (nolock) 
Left Outer Join tWorkType wt (nolock) 
	Left Outer Join tGLAccount gl (nolock) on wt.GLAccountKey = gl.GLAccountKey
on p.AdvBillItemKey = wt.WorkTypeKey
Where p.CompanyKey = @CompanyKey

select 
	vExport_Invoice.*,
	@AdvBillItemID as AdvBillItemID,
	@AdvBillGLAccount as AdvBillGLAccount
from 
	vExport_Invoice (NOLOCK)
where
	CompanyKey = @CompanyKey and
	InvoiceDate >= @StartDate and
	InvoiceDate <= @EndDate and
	Downloaded <= @IncludeDownloaded and
	InvoiceStatus = 4
GO
