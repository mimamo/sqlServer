USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_Batch_All]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_Batch_All]
  	@FileType	varchar( 1 ),
  	@EBFileNbr	varchar( 6 ),
  	@BatNbr		varchar( 10 )
AS

	SELECT		*
	FROM		XDDBatch X (nolock) LEFT OUTER JOIN Batch B (nolock)
  			ON X.Module = B.Module and X.BatNbr = B.BatNbr
	WHERE		X.FileType = @FileType
			and X.EBFileNbr = @EBFileNbr
			and X.BatNbr LIKE @BatNbr
	ORDER BY	X.BatNbr DESC
GO
