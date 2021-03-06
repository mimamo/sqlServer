USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCCEntryLoadAttachments]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCCEntryLoadAttachments]
	@GLAccountKey int
AS

/*
|| When      Who Rel      What
|| 01/15/15  MAS 10.5.8.8 Created for Platinum
*/

	SELECT	a.*
	FROM	tAttachment a (nolock)
	INNER JOIN tCCEntry cc (nolock) ON a.EntityKey = cc.CCEntryKey
	WHERE  a.AssociatedEntity = 'tCCEntry' 
	AND cc.GLAccountKey =  @GLAccountKey
	AND ISNULL(cc.CCVoucherKey, 0) = 0 -- exclude all processed records
GO
