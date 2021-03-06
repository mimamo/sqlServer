USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadStandardExpenseType]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadStandardExpenseType]
 @CompanyKey int,
 @Description varchar(100),      -- ItemName after tItem conversion
 @ExpenseID varchar(50),         -- ItemID after tItem conversion
 @ExpenseGLAccount varchar(100), 
 @SalesGLAccount varchar(100),    
 @ClassID varchar(50),
 @BillingItemID varchar(100)
 
AS --Encrypt

/*
|| When     Who Rel   What
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem
|| 03/28/08 GHL 8.507 Set ItemType to 3
|| 10/13/09 GHL 10.512 (65248) Clone of spImmportExpenseType for load standard
*/

Declare @ExpenseGLAccountKey int,  -- ExpenseAccountKey after tItem conversion
        @WorkTypeKey int,          
        @SalesGLAccountKey int,    -- SalesAccountKey after tItem conversion
        @ClassKey int

If exists(select 1 from tItem (nolock) Where CompanyKey = @CompanyKey and ItemID = @ExpenseID)
	Return -1

Select @ExpenseGLAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey and Rollup = 0 and AccountNumber = @ExpenseGLAccount
Select @SalesGLAccountKey = GLAccountKey from tGLAccount (nolock) Where AccountNumber = @SalesGLAccount and CompanyKey = @CompanyKey
Select @WorkTypeKey = WorkTypeKey from tWorkType (nolock) Where CompanyKey = @CompanyKey and WorkTypeID = @BillingItemID

if @ClassID is not null
begin
	Select @ClassKey = ClassKey from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey
	if @ClassKey is null
		return -2

end

if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		return -2

 INSERT tItem
  (
  CompanyKey,
  ItemName,
  ItemID,
  ItemType,
  ExpenseAccountKey,
  SalesAccountKey,
  ClassKey,
  WorkTypeKey,
  Active
  )
 VALUES
  (
  @CompanyKey,
  @Description,
  @ExpenseID,
  3,
  @ExpenseGLAccountKey,
  @SalesGLAccountKey,
  @ClassKey,
  @WorkTypeKey,
  1
  )
 
 RETURN 1
GO
