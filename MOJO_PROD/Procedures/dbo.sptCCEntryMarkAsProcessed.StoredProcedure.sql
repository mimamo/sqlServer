USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCCEntryMarkAsProcessed]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCCEntryMarkAsProcessed]
	@CCEntryKey int

AS --Encrypt

/*
|| When      Who Rel		What
|| 05/07/12  MAS 10.5.5.6	Created
*/

If ISNULL(@CCEntryKey, 0) = 0
	RETURN -1

If exists (Select CCEntryKey From tCCEntry (nolock) Where CCEntryKey = @CCEntryKey and ISNULL(CCVoucherKey,0) > 0)
	RETURN -2

Update tCCEntry Set CCVoucherKey = -1 Where CCEntryKey = @CCEntryKey
GO
