USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecReOpen]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecReOpen]

	(
		@GLAccountRecKey int
	)

AS


  /*
  || When     Who Rel      What
  || 09/09/09 GWG 10.5.09  Added logic to prevent the reopening of a rec if the start date is prior to the gl close date
  || 10/15/09 GHL 10.512   (65626) Added nolock hints to improve perfomance
  || 4/12/11  GWG 10.543   Added in a clearing protection for uncleared transactions that do not get uncleared.
  || 09/28/12  RLB 10.560  Add MultiCompanyGLClosingDate preference check
  */
  
Declare @CompanyKey int, @GLClosedDate smalldatetime, @StartDate smalldatetime, @GLCompanyKey int, @UseMultiCompanyGLCloseDate tinyint

Select @CompanyKey = CompanyKey, @StartDate = StartDate, @GLCompanyKey = GLCompanyKey from tGLAccountRec (nolock) Where GLAccountRecKey = @GLAccountRecKey
Select @GLClosedDate = GLClosedDate,
	   @UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
From
	tPreference (nolock)
Where
	CompanyKey = @CompanyKey

if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			
	END

if @GLClosedDate is not null
	if @StartDate < @GLClosedDate
		return -1

Update tTransaction
	Set Cleared = 0
	from tGLAccountRecDetail ard (nolock)
	Where 
		tTransaction.TransactionKey = ard.TransactionKey and
		ard.GLAccountRecKey = @GLAccountRecKey
		

Update tDeposit
	Set Cleared = 0
	From tGLAccountRecDetail ard (nolock) , tTransaction t (nolock) 
	Where
		ard.TransactionKey = t.TransactionKey and
		t.DepositKey = tDeposit.DepositKey and
		ard.GLAccountRecKey = @GLAccountRecKey
	
Update tGLAccountRec
	Set Completed = 0
	Where GLAccountRecKey = @GLAccountRecKey


Update tTransaction Set Cleared = 0 Where TransactionKey in (
select TransactionKey from tTransaction (nolock) Where Cleared = 1 and TransactionKey not in (Select TransactionKey from tGLAccountRecDetail (nolock))
)
GO
