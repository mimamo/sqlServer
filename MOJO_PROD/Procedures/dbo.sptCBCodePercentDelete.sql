USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodePercentDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodePercentDelete]
	@CBCodePercentKey int

AS --Encrypt

	DELETE
	FROM tCBCodePercent
	WHERE
		CBCodePercentKey = @CBCodePercentKey 

	RETURN 1
GO
