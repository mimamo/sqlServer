USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_BatNbr]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_BatNbr]
	@Module		varchar( 2 ),
	@FileType	varchar( 1 ),
	@BatNbr		varchar( 10 )
AS
  	Select 		*
  	FROM 		XDDBatch
  	WHERE 		Module = @Module
  			and FileType = @FileType
  			and BatNbr LIKE @BatNbr
  	ORDER BY	BatNbr DESC
GO
