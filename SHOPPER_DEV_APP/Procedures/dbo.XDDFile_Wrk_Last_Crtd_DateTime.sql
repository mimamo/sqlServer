USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Last_Crtd_DateTime]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Last_Crtd_DateTime]
   @ComputerName	varchar(21)
AS
 	SELECT TOP 1	FileType, EBFileNbr
 	FROM		XDDFile_Wrk (nolock)
 	WHERE		ComputerName = @ComputerName
 	ORDER BY	Crtd_DateTime DESC
GO
