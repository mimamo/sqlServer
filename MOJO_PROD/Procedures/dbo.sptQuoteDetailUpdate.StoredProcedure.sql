USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteDetailUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteDetailUpdate]
	@QuoteDetailKey int,
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
	@DepartmentKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/06/07 BSH 8.5     (9659)Update OfficeKey, DepartmentKey
*/
/*
if exists(select 1 
		from 
			tPurchaseOrderDetail pod (nolock), 
			tQuoteReplyDetail qrd (nolock),
			tQuoteDetail qd (nolock)
		Where
			pod.QuoteReplyDetailKey = qrd.QuoteReplyDetailKey and
			qrd.QuoteDetailKey = qd.QuoteDetailKey and
			qd.QuoteDetailKey = @QuoteDetailKey)
		return -1
*/		
	UPDATE
		tQuoteDetail
	SET
		QuoteKey = @QuoteKey,
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		ItemKey = @ItemKey,
		ClassKey = @ClassKey,
		ShortDescription = @ShortDescription,
		LongDescription = @LongDescription,
		Quantity = @Quantity,
		UnitDescription = @UnitDescription,
		Quantity2 = @Quantity2,
		UnitDescription2 = @UnitDescription2,
		Quantity3 = @Quantity3,
		UnitDescription3 = @UnitDescription3,
		Quantity4 = @Quantity4,
		UnitDescription4 = @UnitDescription4,
		Quantity5 = @Quantity5,
		UnitDescription5 = @UnitDescription5,
		Quantity6 = @Quantity6,
		UnitDescription6 = @UnitDescription6,
		CustomFieldKey = @CustomFieldKey,
		OfficeKey = @OfficeKey,
		DepartmentKey = @DepartmentKey
	WHERE
		QuoteDetailKey = @QuoteDetailKey 

	RETURN 1

exec sptQuoteUpdateStatus @QuoteKey, 1
GO
