USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteDetailInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteDetailInsert]
	@QuoteKey int,
	@ProjectKey int,
	@TaskKey int,
	@ItemKey int,
	@ClassKey int,
	@ShortDescription varchar(200),
	@LongDescription varchar(6000),
	@Quantity decimal(15,3),
	@UnitDescription varchar(30),	
	@Quantity2 decimal(24,4),
	@UnitDescription2 varchar(30),
	@Quantity3 decimal(24,4),
	@UnitDescription3 varchar(30),
	@Quantity4 decimal(24,4),
	@UnitDescription4 varchar(30),
	@Quantity5 decimal(24,4),
	@UnitDescription5 varchar(30),
	@Quantity6 decimal(24,4),
	@UnitDescription6 varchar(30),
	@CustomFieldKey int,
	@OfficeKey int,
	@DepartmentKey int,
	@DisplayOrder int = 0,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/06/07 BSH 8.5     (9659)Insert OfficeKey, DepartmentKey
|| 08/12/11 RLB 10.547 (116589) Added some logic in for Display Order getting passed into Quote
*/
Declare @LineNumber int

If @DisplayOrder > 0
 
	Select @LineNumber = @DisplayOrder

else

	Select @LineNumber = ISNULL(Max(LineNumber) + 1, 1) from tQuoteDetail (NOLOCK) Where QuoteKey = @QuoteKey

	INSERT tQuoteDetail
		(
		QuoteKey,
		ProjectKey,
		LineNumber,
		TaskKey,
		ItemKey,
		ClassKey,
		ShortDescription,
		LongDescription,
		Quantity,
		UnitDescription,
		Quantity2,
		UnitDescription2,
		Quantity3,
		UnitDescription3,
		Quantity4,
		UnitDescription4,
		Quantity5,
		UnitDescription5,
		Quantity6,
		UnitDescription6,
		CustomFieldKey,
		OfficeKey,
		DepartmentKey
		)

	VALUES
		(
		@QuoteKey,
		@ProjectKey,
		@LineNumber,
		@TaskKey,
		@ItemKey,
		@ClassKey,
		@ShortDescription,
		@LongDescription,
		@Quantity,
		@UnitDescription,
		@Quantity2,
		@UnitDescription2,
		@Quantity3,
		@UnitDescription3,
		@Quantity4,
		@UnitDescription4,
		@Quantity5,
		@UnitDescription5,
		@Quantity6,
		@UnitDescription6,
		@CustomFieldKey,
		@OfficeKey,
		@DepartmentKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	
	exec sptQuoteUpdateStatus @QuoteKey, 1

	RETURN 1
GO
