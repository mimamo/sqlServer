USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_Update_FileType]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_Update_FileType]
   @Module		varchar( 2 ),
   @BatNbr		varchar( 10 ),
   @FileType		varchar( 1 ),
   @BatSeq		smallint,
   @BatEFTGrp		smallint,
   @NewFileType		varchar( 1 )	

AS

   UPDATE	XDDBatch
   SET		FileType = @NewFileType
   WHERE	Module = @Module
   		and BatNbr = @BatNbr
   		and FileType = @FileType
   		and BatSeq = @BatSeq
   		and BatEFTGrp = @BatEFTGrp
GO
