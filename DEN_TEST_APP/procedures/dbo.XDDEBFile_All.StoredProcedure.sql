USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEBFile_All]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEBFile_All]
  	@FileType1	varchar( 1 ),
  	@FileType2	varchar( 1 ),
  	@FileType3	varchar( 1 ),
  	@EBFileNbr	varchar( 6 )
AS

	SELECT		*
	FROM		XDDEBFile
	WHERE		(FileType = @FileType1
			or FileType = @FileType2
			or FileType = @FileType3)
			and EBFileNbr LIKE @EBFileNbr
	ORDER BY	EBFileNbr DESC
GO
