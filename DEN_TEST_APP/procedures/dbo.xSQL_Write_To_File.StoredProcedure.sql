USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xSQL_Write_To_File]    Script Date: 12/21/2015 15:37:14 ******/
CREATE PROCEDURE [dbo].[xSQL_Write_To_File]
	@content [nvarchar](max),
	@filename [nvarchar](255)
AS
EXTERNAL NAME [xSQL_Write_To_File].[SQL_Write_To_File.clsSQLWriteToFile].[WriteToFile]
GO
