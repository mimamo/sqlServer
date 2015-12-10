USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPRepost]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPRepost]
	(
		@CompanyKey INT
	)
AS --Encrypt

	DECLARE @WIPPostingKey INT
	,@PostingDate SMALLDATETIME 
	,@SelectThroughDate SMALLDATETIME 
	,@Comment VARCHAR(300)
	,@GLCompanyKey int
	,@GLClosedDate SMALLDATETIME
	
	-- to be able to unpost/post
	SELECT @GLClosedDate = GLClosedDate
	from tPreference  (nolock)
	Where CompanyKey = @CompanyKey

	UPDATE tPreference 
	SET GLClosedDate = '1/1/1990'
	Where CompanyKey = @CompanyKey

	SELECT *
	INTO #tWIPPosting 
	FROM tWIPPosting (NOLOCK)
	WHERE CompanyKey = @GLCompanyKey
	
	/*
	UPDATE tVoucherDetail
	SET    tVoucherDetail.WIPPostingInKey = 0
	FROM   tVoucher v (NOLOCK)
	WHERE  tVoucherDetail.VoucherKey = v.VoucherKey
	AND    v.CompanyKey = @CompanyKey
	AND    tVoucherDetail.WIPPostingInKey = -1 
	*/
	
	SELECT @PostingDate = '1/1/1960'
	WHILE (1=1)
	BEGIN
		SELECT @PostingDate = MIN(PostingDate)
		FROM   #tWIPPosting 
		WHERE  PostingDate > @PostingDate
		
		IF @PostingDate IS NULL
			BREAK
			
		SELECT @WIPPostingKey = WIPPostingKey  
			,@SelectThroughDate = SelectThroughDate  
			,@Comment = Comment
 			,@GLCompanyKey = GLCompanyKey
 		FROM #tWIPPosting 
		WHERE  PostingDate = @PostingDate
		
		SELECT @Comment
		
		EXEC spGLUnpostWIP @WIPPostingKey
		EXEC spGLPostWIP @CompanyKey, @PostingDate, @SelectThroughDate, @Comment, @GLCompanyKey
		
	END	
				
	UPDATE tPreference 
	SET GLClosedDate = @GLClosedDate
	Where CompanyKey = @CompanyKey
		
	RETURN 1
GO
