USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Remove_EM_Sample]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Remove_EM_Sample]
  	@EBFileNbr	varchar( 6 )
AS

	DELETE	FROM    XDDFile_Wrk
	WHERE		EBFileNbr = @EBFileNbr
GO
