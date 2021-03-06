USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContractDetailUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContractDetailUpdate]
	@CompanyMediaContractDetailKey int = NULL,
	@CompanyMediaContractKey int,
	@MediaSpaceKey int,
	@MediaPositionKey int,
	@ShortQty decimal(24,4),
	@TargetQty decimal(24,4),
	@DiscountQty decimal(24,4),
	@ShortRate money,
	@TargetRate money,
	@DiscountRate money
	
	AS --Encrypt
	
	/*
	|| When     Who Rel     What
	|| 06/21/13 MFT 10.569  Created
*/

IF ISNULL(@CompanyMediaContractDetailKey, 0) > 0
	UPDATE tCompanyMediaContractDetail
	SET
		CompanyMediaContractKey = @CompanyMediaContractKey,
		MediaSpaceKey = @MediaSpaceKey,
		MediaPositionKey = @MediaPositionKey,
		ShortQty = @ShortQty,
		TargetQty = @TargetQty,
		DiscountQty = @DiscountQty,
		ShortRate = @ShortRate,
		TargetRate = @TargetRate,
		DiscountRate = @DiscountRate
	WHERE
		CompanyMediaContractDetailKey = @CompanyMediaContractDetailKey
ELSE
	BEGIN
		INSERT tCompanyMediaContractDetail
		(
			CompanyMediaContractKey,
			MediaSpaceKey,
			MediaPositionKey,
			ShortQty,
			TargetQty,
			DiscountQty,
			ShortRate,
			TargetRate,
			DiscountRate
		)
		VALUES
		(
			@CompanyMediaContractKey,
			@MediaSpaceKey,
			@MediaPositionKey,
			@ShortQty,
			@TargetQty,
			@DiscountQty,
			@ShortRate,
			@TargetRate,
			@DiscountRate
		)
		
		SELECT @CompanyMediaContractDetailKey = SCOPE_IDENTITY()
	END

RETURN @CompanyMediaContractDetailKey
GO
