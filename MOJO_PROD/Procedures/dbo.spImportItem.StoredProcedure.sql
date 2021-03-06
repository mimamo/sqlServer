USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportItem]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportItem]
	@CompanyKey int,
	@ItemID varchar(50),
	@ItemName varchar(200),
	@UnitCost money,
	@UnitRate money,
	@UnitDescription varchar(30),
	@StandardDescription varchar(1000),
	@BillingItemID varchar(50),
	@ExpenseAccountNumber varchar(100),
	@SalesAccountNumber varchar(100),
	@ClassID varchar(50),	
	@QuantityOnHand decimal(9, 3),
	@ItemType int = 0	-- Optional parameter default to Purchase Item 
AS --Encrypt

Declare @ExpenseAccountKey int, @WorkTypeKey int, @Markup decimal(24,4), @SalesAccountKey int, @ClassKey int

if exists(select 1 from tItem (nolock) Where CompanyKey = @CompanyKey and ItemID = @ItemID)
	return -1
	
Select @ExpenseAccountKey = GLAccountKey from tGLAccount (nolock) Where AccountNumber = @ExpenseAccountNumber and CompanyKey = @CompanyKey
Select @SalesAccountKey = GLAccountKey from tGLAccount (nolock) Where AccountNumber = @SalesAccountNumber and CompanyKey = @CompanyKey
Select @WorkTypeKey = WorkTypeKey from tWorkType (nolock) Where WorkTypeID = @BillingItemID and CompanyKey = @CompanyKey
if @ClassID is not null
begin
	Select @ClassKey = ClassKey from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey
	if @ClassKey is null
		return -2

end

if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		return -2


if @UnitCost > 0
	Select @Markup = ((@UnitRate / @UnitCost) - 1) * 100
else
	Select @Markup = 0

	INSERT tItem
		(
		CompanyKey,
		ItemID,
		ItemName,
		UnitCost,
		UnitRate,
		Markup,
		UnitDescription,
		StandardDescription,
		WorkTypeKey,
		ExpenseAccountKey,
		SalesAccountKey,
		ClassKey,
		QuantityOnHand,
		ItemType
		)

	VALUES
		(
		@CompanyKey,
		@ItemID,
		@ItemName,
		@UnitCost,
		@UnitRate,
		@Markup,
		@UnitDescription,
		@StandardDescription,
		@WorkTypeKey,
		@ExpenseAccountKey,
		@SalesAccountKey,
		@ClassKey,
		@QuantityOnHand,
		@ItemType
		)

	RETURN 1
GO
