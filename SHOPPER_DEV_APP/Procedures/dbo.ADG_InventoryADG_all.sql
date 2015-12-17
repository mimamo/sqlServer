USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_InventoryADG_all]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_InventoryADG_all]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM InventoryADG
	WHERE InvtID LIKE @parm1
	ORDER BY InvtID
GO
