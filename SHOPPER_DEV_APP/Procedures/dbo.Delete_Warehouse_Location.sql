USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_Warehouse_Location]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Delete_Warehouse_Location]
	@parm1 varchar(10),
	@parm2 varchar(10)
AS
	Delete
	FROM	LocTable
	WHERE	Siteid = @parm1
	  AND	WhseLoc = @parm2
GO
