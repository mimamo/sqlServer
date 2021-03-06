USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBPostingGetBatchList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBPostingGetBatchList]
	(
		@CBBatchKey INT
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
*/

	SET NOCOUNT ON
	
	SELECT	cp.*
			,p.ProjectNumber	-- AS CMPProjectNumber
			,p.ProjectName
			,gla.AccountNumber
			,gla.AccountName
			,cbc.ProjectNumber	AS LLNLProjectNumber
			,cbc.TaskNumber		AS LLNLTaskNumber
			,CASE WHEN ISNULL(gla.AccountNumber, 0) = 0 THEN 2 ELSE 1 END
			AS PostingType 
			,pt.ProjectNumPrefix AS ExpenditureType
			,pt.ProjectTypeName AS NonLaborResource
	FROM	tCBPosting cp (NOLOCK)
		LEFT OUTER JOIN tGLAccount gla (NOLOCK) ON cp.GLAccountKey = gla.GLAccountKey
		LEFT OUTER JOIN tCBCode cbc (NOLOCK) ON cp.CBCodeKey = cbc.CBCodeKey 
		INNER JOIN tProject p (NOLOCK) ON cp.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tProjectType pt (NOLOCK) ON p.ProjectTypeKey = pt.ProjectTypeKey 
	WHERE	cp.CBBatchKey = @CBBatchKey
	AND     cp.CBCodeKey > 0
	
	RETURN 1
GO
