USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_InvtDescrXref_Populate]    Script Date: 12/21/2015 14:17:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_InvtDescrXref_Populate]
AS

	DECLARE @InvtID varchar(30)
	DECLARE @Descr varchar(60)

	TRUNCATE TABLE InvtDescrXref

	DECLARE InvCursor INSENSITIVE CURSOR FOR SELECT InvtID, Descr FROM Inventory

	OPEN InvCursor

	FETCH NEXT FROM InvCursor INTO @InvtID, @Descr

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXECUTE ADG_InvtDescrXref_Add @InvtID, @Descr

		FETCH NEXT FROM InvCursor INTO @InvtID, @Descr
	END

	CLOSE InvCursor
	DEALLOCATE InvCursor

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
