USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecDeleteDetail]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecDeleteDetail]

	(
		@GLAccountRecKey int
	)

AS

Delete from tGLAccountRecDetail Where GLAccountRecKey = @GLAccountRecKey
GO
