USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCCEntryUpdateMatch]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCCEntryUpdateMatch]
	@CCEntryKey int,
	@VoucherKey int

AS --Encrypt

/*
|| When      Who Rel		What
|| 02/06/12  MAS 10.5.5.3	Created
*/

If ISNULL(@CCEntryKey, 0) = 0
	RETURN - 1
	
If ISNULL(@VoucherKey, 0) = 0
	RETURN - 2	

Update tVoucher Set CCEntryKey = @CCEntryKey Where VoucherKey = @VoucherKey
Update tCCEntry Set CCVoucherKey = @VoucherKey Where CCEntryKey = @CCEntryKey
GO
