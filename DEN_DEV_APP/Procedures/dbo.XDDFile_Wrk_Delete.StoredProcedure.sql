USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Delete]    Script Date: 12/21/2015 14:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Delete]
   @FileType		varchar(1),
   @ComputerName	varchar(21)

AS
   DELETE
   FROM		XDDFile_Wrk
   WHERE	FileType = @FileType
   		and ComputerName = @ComputerName
GO
