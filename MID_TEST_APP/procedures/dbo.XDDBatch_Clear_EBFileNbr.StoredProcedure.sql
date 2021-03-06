USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_Clear_EBFileNbr]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_Clear_EBFileNbr]
	@FileType 	varchar( 1 ),
	@EBFileNbr	varchar( 6 ),
  	@UpdUser	varchar( 10 ),
  	@UpdProg	varchar( 5 )

AS


	UPDATE		XDDBatch
	SET		EBFileNbr = '',
			LUpd_DateTime = GetDate(),
			LUpd_Prog = @UpdProg,
			LUpd_User = @UpdUser
	WHERE		FileType = @FileType
			and EBFileNbr = @EBFileNbr
GO
