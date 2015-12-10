USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountCheckHasTrans]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountCheckHasTrans]

	(
		@GLAccountKey int
	)

AS --Encrypt
SELECT count(*) FROM tTransaction (nolock) WHERE GLAccountKey = @GLAccountKey
GO
