USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBPostingGetBatchCodes]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBPostingGetBatchCodes]
	(
		@CBBatchKey INT
	)
AS	--Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
*/
 
	SET NOCOUNT ON
	
	SELECT	DISTINCT 
			ISNULL(pt.ProjectTypeKey, 0) AS ProjectTypeKey
			,cp.CBCodeKey
			,cbc.ProjectNumber
			,cbc.TaskNumber			  
			,pt.ProjectNumPrefix AS ExpenditureType
			,pt.ProjectTypeName AS NonLaborResource
	FROM	tCBPosting cp (NOLOCK)
		INNER JOIN tCBCode cbc (NOLOCK) ON cp.CBCodeKey = cbc.CBCodeKey
		INNER JOIN tProject p (NOLOCK) ON cp.ProjectKey = p.ProjectKey 
		LEFT OUTER JOIN tProjectType pt (NOLOCK) ON p.ProjectTypeKey = pt.ProjectTypeKey
	WHERE	cp.CBBatchKey = @CBBatchKey
	AND     ISNULL(cp.CBCodeKey, 0) > 0 
		
	RETURN 1
GO
