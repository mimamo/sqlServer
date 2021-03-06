USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeUpdateVoucherKey]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeUpdateVoucherKey]
	@TimeKey uniqueidentifier,
	@VoucherKey int

AS --Encrypt

	/*
	|| When     Who Rel    What
	|| 09/14/11 MFT 10.548 Created for new Voucher
	*/

UPDATE
	tTime
SET
	VoucherKey = @VoucherKey
WHERE
	TimeKey = @TimeKey
GO
