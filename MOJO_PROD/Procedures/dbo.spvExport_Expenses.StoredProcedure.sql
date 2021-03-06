USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_Expenses]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_Expenses]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@IncludeDownloaded tinyint = 0
	)

AS --Encrypt

Declare @APAccount varchar(100)

IF @StartDate IS NULL
 Select @StartDate = '1/1/1990'
 
 
IF @EndDate IS NULL
 Select @EndDate = GETDATE()


select 
	@APAccount = gl.AccountNumber
from 
	tPreference p (NOLOCK),
	tGLAccount gl (NOLOCK)
where
	p.DefaultAPAccountKey = gl.GLAccountKey and
	p.CompanyKey = @CompanyKey

select 
	*,
	NEWID() as TicketNumber,
	@APAccount as APAccount
from 
	vExport_Expenses (NOLOCK)
where
	CompanyKey = @CompanyKey and
	DateApproved >= @StartDate and
	DateApproved <= @EndDate and
	Downloaded <= @IncludeDownloaded
order by 
	EnvelopeNumber
GO
