USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_ExpensesMarkDownloaded]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spvExport_ExpensesMarkDownloaded]

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

update tExpenseEnvelope
set Downloaded = 1
where
	CompanyKey = @CompanyKey and
	DateApproved >= @StartDate and
	DateApproved <= @EndDate and
	Status = 4
GO
