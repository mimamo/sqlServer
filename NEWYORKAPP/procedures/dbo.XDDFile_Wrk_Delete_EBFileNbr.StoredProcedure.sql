USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Delete_EBFileNbr]    Script Date: 12/21/2015 16:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Delete_EBFileNbr]
   @FileType		varchar(1),
   @EBFileNbr		varchar(6)

AS
   DELETE
   FROM		XDDFile_Wrk
   WHERE	FileType = @FileType
   		and EBFileNbr = @EBFileNbr
GO
