USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CustNameXRef_Populate]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CustNameXRef_Populate]
AS
	DECLARE @CustID varchar(15)
	DECLARE @Name varchar(60)

	TRUNCATE TABLE CustNameXref

	DECLARE CusCursor INSENSITIVE CURSOR FOR SELECT CustID, Name FROM Customer

	OPEN CusCursor

	FETCH NEXT FROM CusCursor INTO @CustID, @Name

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXECUTE ADG_CustNameXref_Add @CustID, @Name

		FETCH NEXT FROM CusCursor INTO @CustID, @Name
	END

	CLOSE CusCursor
	DEALLOCATE CusCursor

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
