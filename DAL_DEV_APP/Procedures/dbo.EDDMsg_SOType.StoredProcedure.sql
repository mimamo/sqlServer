USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDMsg_SOType]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDMsg_SOType]
		@DBName  varchar(30),	-- Database Name
		@SOType	 varchar(4)	-- SOType ID

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS

	DECLARE @szSelect	varchar(500)
	DECLARE @szFrom		varchar(500)
	DECLARE @szWhere	varchar(500)

	SELECT @szSelect = "SELECT * FROM "

	SELECT @szFrom = @DBName + "..SOType"

	SELECT @szWhere = " WHERE SOTypeID = '" + @SOType + "'"
 

--PRINT (@szSelect + @szFrom + @szWhere) 
EXEC (@szSelect + @szFrom + @szWhere)
GO
