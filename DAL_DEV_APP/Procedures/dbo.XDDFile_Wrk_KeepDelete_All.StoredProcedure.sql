USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_KeepDelete_All]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_KeepDelete_All]
   @FileType		varchar (1),
   @EBFileNbr		varchar (6),
   @KeepDelete		varchar (1)

AS
   UPDATE		XDDFile_Wrk
   SET			KeepDelete = @KeepDelete
   WHERE		FileType = @FileType
   			and EBFileNbr = @EBFileNbr
GO
