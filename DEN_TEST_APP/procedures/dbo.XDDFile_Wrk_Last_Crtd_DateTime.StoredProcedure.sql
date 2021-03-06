USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Last_Crtd_DateTime]    Script Date: 12/21/2015 15:37:12 ******/
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
