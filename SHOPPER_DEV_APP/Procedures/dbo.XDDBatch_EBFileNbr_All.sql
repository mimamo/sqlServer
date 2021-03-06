USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_EBFileNbr_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_EBFileNbr_All]
  	@FileType	varchar( 1 ),
  	@EBFileNbr	varchar( 6 ),
  	@BatNbr		varchar( 10 )
AS

	SELECT		*
	FROM		XDDBatch 
	WHERE		FileType = @FileType
			and EBFileNbr = @EBFileNbr
			and BatNbr LIKE @BatNbr
	ORDER BY	BatNbr DESC
GO
