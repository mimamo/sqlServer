USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEBFile_Last_Test]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEBFile_Last_Test]
  	@FileType	varchar( 1 ),
  	@EBFileNbr	varchar( 6 )

AS

	SELECT		*
	FROM		XDDEBFile (nolock)
	WHERE		FileType = @FileType
			and Batch_PreNote = 'T'
			and KeepDelete <> 'C'
			and EBFileNbr LIKE @EBFileNbr
	ORDER BY	EBFileNbr DESC
GO
