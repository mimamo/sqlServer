USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopesGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopesGet]
	@UserKey int   -- for my expenses
   ,@CompanyKey int   -- for all expenses
   ,@Name    varchar(50) -- for all submitted expenses
   ,@Mode    int 
AS --Encrypt

 DECLARE @kModeMyOpenExpenses int
        ,@kModeMyApproved int
		,@kModeAllOpenExpenses int
        ,@kModeAllUnpaidExpenses int
        ,@kModeAllPaidExpenses int
        
 SELECT @kModeMyOpenExpenses = 1
        ,@kModeMyApproved = 2
		,@kModeAllOpenExpenses = 3
        ,@kModeAllUnpaidExpenses = 4
        ,@kModeAllPaidExpenses = 5
 
 DECLARE @kStatusNew int
        ,@kStatusSubmitted int
		,@kStatusRejected int
        ,@kStatusApproved int
        
 SELECT @kStatusNew = 1
        ,@kStatusSubmitted = 2
		,@kStatusRejected = 3
        ,@kStatusApproved = 4

 IF @Mode = @kModeMyOpenExpenses
	SELECT	env.*
			,isnull(
				(select sum(ActualCost) 
				from tExpenseReceipt cst (nolock)
				where env.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as TotalCost
	FROM	tExpenseEnvelope env (nolock)
	WHERE	env.UserKey = @UserKey
    AND		env.Status in (@kStatusNew, @kStatusRejected)
	ORDER BY env.Status DESC, env.StartDate

IF @Mode = @kModeMyApproved
	SELECT	env.*
			,isnull(
				(select sum(ActualCost) 
				from tExpenseReceipt cst (nolock)
				where env.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as TotalCost
	FROM	tExpenseEnvelope env (nolock)
	WHERE	env.UserKey = @UserKey
    AND		(env.Status = @kStatusApproved
			OR env.Paid = 1)
	ORDER BY env.Status DESC, env.StartDate

IF @Mode = @kModeAllOpenExpenses
	SELECT	env.*
			,isnull(
				(select sum(ActualCost) 
				from tExpenseReceipt cst (nolock)
				where env.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as TotalCost
			,'FullName' = ISNULL(u.LastName,'') + ', ' + ISNULL(u.FirstName,'')
	FROM	tExpenseEnvelope env (nolock)
			,tUser u   (NOLOCK)
  WHERE		env.UserKey = u.UserKey
  AND		(u.CompanyKey = @CompanyKey
			OR u.OwnerCompanyKey = @CompanyKey)
  AND		env.Status in (@kStatusNew, @kStatusSubmitted, @kStatusRejected)
  ORDER BY	u.LastName, u.FirstName, env.StartDate DESC

IF @Mode = @kModeAllUnpaidExpenses
	SELECT	env.*
			,isnull(
				(select sum(ActualCost) 
				from tExpenseReceipt cst (nolock)
				where env.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as TotalCost
			,'FullName' = ISNULL(u.LastName,'') + ', ' + ISNULL(u.FirstName,'')
	FROM	tExpenseEnvelope env (nolock)
			,tUser u   (NOLOCK)
  WHERE		env.UserKey = u.UserKey
  AND		(u.CompanyKey = @CompanyKey
			OR u.OwnerCompanyKey = @CompanyKey)
  AND		env.Status = @kStatusApproved
  AND		env.Paid = 0
  ORDER BY	u.LastName, u.FirstName, env.StartDate DESC

IF @Mode = @kModeAllPaidExpenses
	if @Name is null
		SELECT	env.*
				,isnull(
					(select sum(ActualCost) 
					from tExpenseReceipt cst (nolock)
					where env.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as TotalCost
				,'FullName' = ISNULL(u.LastName,'') + ', ' + ISNULL(u.FirstName,'')
		FROM	tExpenseEnvelope env (nolock)
				,tUser u   (NOLOCK)
		WHERE		env.UserKey = u.UserKey
		AND		(u.CompanyKey = @CompanyKey
					OR u.OwnerCompanyKey = @CompanyKey)
		AND		env.Paid = 1
		ORDER BY	u.LastName, u.FirstName, env.StartDate DESC
	else
		SELECT	env.*
				,isnull(
					(select sum(ActualCost) 
					from tExpenseReceipt cst (nolock)
					where env.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as TotalCost
				,'FullName' = ISNULL(u.LastName,'') + ', ' + ISNULL(u.FirstName,'')
		FROM	tExpenseEnvelope env (nolock)
				,tUser u   (NOLOCK)
		WHERE		env.UserKey = u.UserKey
		AND		(u.CompanyKey = @CompanyKey
					OR u.OwnerCompanyKey = @CompanyKey)
		AND		u.LastName like @Name +'%'
		AND		env.Paid = 1
		ORDER BY	u.LastName, u.FirstName, env.StartDate DESC
  

 return 1
GO
