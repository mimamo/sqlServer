USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ShipVia_Descr]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ShipVia_Descr]
	@parm1 varchar(10),
	@parm2 varchar(15)
AS
	Select	Descr
	from	ShipVia
	where	CpnyID = @parm1
	  and 	ShipViaID = @parm2

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
