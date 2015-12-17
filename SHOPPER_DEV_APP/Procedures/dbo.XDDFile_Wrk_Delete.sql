USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Delete]    Script Date: 12/16/2015 15:55:38 ******/
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
