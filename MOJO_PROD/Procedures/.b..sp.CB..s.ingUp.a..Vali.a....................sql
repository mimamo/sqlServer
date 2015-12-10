USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBPostingUpdateValidated]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBPostingUpdateValidated]
	(
		@CBBatchKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
*/
	/* Assume done in web page
	CREATE TABLE #tCBCode (CBCodeKey int null, ProjectTypeKey int null, ErrorMessage varchar(500) null, ErrorMessageCode varchar(250) null, Validated
	*/
	
	UPDATE tCBPosting 
	SET    tCBPosting.Validated = c.Validated
		  ,tCBPosting.ErrorMessage = c.ErrorMessage
		  ,tCBPosting.ErrorMessageCode = c.ErrorMessageCode
	FROM   #tCBCode c (NOLOCK) 
		   ,tProject p (NOLOCK) 
		   ,tProjectType pt (NOLOCK) 
	WHERE  tCBPosting.CBBatchKey = @CBBatchKey
	AND	   tCBPosting.CBCodeKey > 0 -- not GL Account
	AND	   tCBPosting.CBCodeKey = c.CBCodeKey
	AND	   pt.ProjectTypeKey = c.ProjectTypeKey 
	AND    tCBPosting.ProjectKey = p.ProjectKey
	AND    p.ProjectTypeKey = pt.ProjectTypeKey
	
	
	UPDATE tCBPosting 
	SET    tCBPosting.Validated = 0
		  ,tCBPosting.ErrorMessage = 'Missing Project Type on CMP Project'
		  ,tCBPosting.ErrorMessageCode = '-9999'
	FROM   #tCBCode c (NOLOCK) 
		   ,tProject p (NOLOCK) 
	WHERE  tCBPosting.CBBatchKey = @CBBatchKey
	AND	   tCBPosting.CBCodeKey > 0 -- not GL Account
	AND	   ISNULL(p.ProjectTypeKey, 0) = 0
	AND    tCBPosting.ProjectKey = p.ProjectKey
			
	
	RETURN 1
GO
