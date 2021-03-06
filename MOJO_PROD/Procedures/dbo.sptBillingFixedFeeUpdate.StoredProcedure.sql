USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingFixedFeeUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingFixedFeeUpdate]
	@BillingKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Percentage decimal(24,4),
	@Amount money,
	@Taxable1 tinyint,
	@Taxable2 tinyint

AS --Encrypt

if exists(Select 1 from tBillingFixedFee (nolock) Where BillingKey = @BillingKey and Entity = @Entity and EntityKey = @EntityKey)
	UPDATE
		tBillingFixedFee
	SET
		BillingKey = @BillingKey,
		Entity = @Entity,
		EntityKey = @EntityKey,
		Percentage = @Percentage,
		Amount = @Amount,
		Taxable1 = @Taxable1,
		Taxable2 = @Taxable2
	WHERE
		BillingKey = @BillingKey and Entity = @Entity and EntityKey = @EntityKey

ELSE

	INSERT tBillingFixedFee
		(
		BillingKey,
		Entity,
		EntityKey,
		Percentage,
		Amount,
		Taxable1,
		Taxable2
		)

	VALUES
		(
		@BillingKey,
		@Entity,
		@EntityKey,
		@Percentage,
		@Amount,
		@Taxable1,
		@Taxable2
		)

	RETURN 1
GO
