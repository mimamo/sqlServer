USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWIPPostingGet]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWIPPostingGet]
	@WIPPostingKey int

AS --Encrypt

		SELECT *
		FROM tWIPPosting (NOLOCK)
		WHERE
			WIPPostingKey = @WIPPostingKey

	RETURN 1
GO
