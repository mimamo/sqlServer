USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactActivityDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactActivityDelete]
	@ContactActivityKey int

AS --Encrypt

	DELETE
	FROM tContactActivity
	WHERE
		ContactActivityKey = @ContactActivityKey 

	RETURN 1
GO
