USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBBatchGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBBatchGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
				,(SELECT COUNT(*) FROM tCBPosting (NOLOCK) WHERE CBBatchKey = tCBBatch.CBBatchKey) AS PostingCount
			    ,(SELECT COUNT(*) FROM tCBPosting (NOLOCK) WHERE CBBatchKey = tCBBatch.CBBatchKey
				  AND ISNULL(CBCodeKey, 0) > 0 AND Validated = 0 ) AS InvalidCount			  
				,CASE 
					WHEN Type = 1 THEN 'Billing'
					ELSE 'Adjustment'
				 END AS TypeDescription 
		FROM tCBBatch (nolock)
		WHERE
		CompanyKey = @CompanyKey

	RETURN 1
GO
