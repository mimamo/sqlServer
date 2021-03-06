USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemInsert]
	@CompanyKey int,
	@ItemType smallint,
	@ItemID varchar(50),
	@ItemName varchar(200),
	@UnitCost money,
	@UnitRate money,
	@Markup decimal(24,4),
	@UnitDescription varchar(30),
	@StandardDescription varchar(1000),
	@WorkTypeKey int,
	@DepartmentKey int,
	@ExpenseAccountKey int,
	@SalesAccountKey int,
	@ClassKey int,
	@QuantityOnHand decimal(24,4),
	@Active tinyint,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@UseUnitRate tinyint,
	@CalcAsArea tinyint,
	@ConversionMultiplier decimal(24,4),
	@MinAmount money,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel   What
  || 06/14/07 GWG 8.5   Added the departmentKey
  || 08/28/07 CRG 8.5   Added UseUnitRate  
  || 10/19/07 CRG 8.5   (11376) Added CalcAsArea, ConversionMultiplier, MinAmount (for paid enhancement).  
  */
  
if exists(select 1 from tItem (nolock) Where CompanyKey = @CompanyKey and ItemID = @ItemID)
	return -1

	INSERT tItem
		(
		CompanyKey,
		ItemType,
		ItemID,
		ItemName,
		UnitCost,
		UnitRate,
		Markup,
		UnitDescription,
		StandardDescription,
		WorkTypeKey,
		DepartmentKey,
		ExpenseAccountKey,
		SalesAccountKey,
		ClassKey,
		QuantityOnHand,
		Active,
		Taxable,
		Taxable2,
		UseUnitRate,
		CalcAsArea,
		ConversionMultiplier,
		MinAmount
		)

	VALUES
		(
		@CompanyKey,
		@ItemType,
		@ItemID,
		@ItemName,
		@UnitCost,
		@UnitRate,
		@Markup,
		@UnitDescription,
		@StandardDescription,
		@WorkTypeKey,
		@DepartmentKey,
		@ExpenseAccountKey,
		@SalesAccountKey,
		@ClassKey,
		@QuantityOnHand,
		@Active,
		@Taxable,
		@Taxable2,
		@UseUnitRate,
		@CalcAsArea,
		@ConversionMultiplier,
		@MinAmount
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
