USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_FileType_L]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_FileType_L]
	@BatNbr		varchar(10)
	
AS
	SELECT		*
	FROM		XDDBatch
	WHERE		FileType = 'L'
			and BatNbr LIKE @BatNbr
	ORDER BY	BatNbr Desc
GO
