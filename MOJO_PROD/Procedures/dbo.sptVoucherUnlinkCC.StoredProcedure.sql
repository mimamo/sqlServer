USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUnlinkCC]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUnlinkCC]
	@VoucherKey int
AS

/*
|| When      Who Rel      What
|| 7/3/12    CRG 10.5.5.7 Created
*/

	UPDATE	tCCEntry
	SET		CCVoucherKey = NULL
	WHERE	CCVoucherKey = @VoucherKey

	UPDATE	tVoucher
	SET		CCEntryKey = NULL
	WHERE	VoucherKey = @VoucherKey
GO
