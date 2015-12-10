USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBBatchGet]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBBatchGet]
	@CBBatchKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
||                       Only take Project/Task, i.e. no GL accounts
*/

		SELECT *
			  ,(SELECT COUNT(*) FROM tCBPosting (NOLOCK) WHERE CBBatchKey = @CBBatchKey
				AND ISNULL(CBCodeKey, 0) > 0) AS PostingCount
			  ,(SELECT COUNT(*) FROM tCBPosting (NOLOCK) WHERE CBBatchKey = @CBBatchKey
				AND ISNULL(CBCodeKey, 0) > 0 AND Validated = 0 ) AS InvalidCount			  
		FROM tCBBatch (nolock)
		WHERE
			CBBatchKey = @CBBatchKey

	RETURN 1
GO
