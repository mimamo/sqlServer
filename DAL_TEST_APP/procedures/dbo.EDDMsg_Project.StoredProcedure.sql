USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDMsg_Project]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDMsg_Project]
		@DBName  varchar(30),	-- Database Name
		@project varchar(16)	-- Project ID

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS

	DECLARE @szSelect	varchar(500)
	DECLARE @szFrom		varchar(500)
	DECLARE @szWhere	varchar(500)

	SELECT @szSelect = "SELECT * FROM "

	SELECT @szFrom = @DBName + "..pjproj"

	SELECT @szWhere = " WHERE project = '" + @project + "'"
 

--PRINT (@szSelect + @szFrom + @szWhere) 
EXEC (@szSelect + @szFrom + @szWhere)
GO
