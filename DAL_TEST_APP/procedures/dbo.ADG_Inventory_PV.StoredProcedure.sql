USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inventory_PV]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Inventory_PV]
	@parm1 varchar(30)
AS
	SELECT InvtId, Descr
	FROM Inventory
	WHERE InvtID like @parm1
	ORDER BY InvtId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
