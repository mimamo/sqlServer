USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDMsg_Employee]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDMsg_Employee]
		@DBName  varchar(30),	-- Database Name
		@EmpID	 varchar(10)	-- Employee ID

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS

	DECLARE @szSelect	varchar(500)
	DECLARE @szFrom		varchar(500)
	DECLARE @szWhere	varchar(500)

	SELECT @szSelect = "SELECT * FROM "

	SELECT @szFrom = @DBName + "..Employee"

	SELECT @szWhere = " WHERE EmpId = '" + @EmpID + "'"
 

--PRINT (@szSelect + @szFrom + @szWhere) 
EXEC (@szSelect + @szFrom + @szWhere)
GO
