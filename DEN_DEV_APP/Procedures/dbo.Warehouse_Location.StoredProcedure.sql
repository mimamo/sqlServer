USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Warehouse_Location]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Warehouse_Location]
	@parm1 varchar(30),
	@parm2 varchar(10),
        @parm3 varchar(10)
AS
	Select *
	FROM	Location
	WHERE	Invtid = @parm1
	  AND	Siteid = @parm2
          AND   Whseloc Like @Parm3
        Order By Invtid,Siteid,WhseLoc
GO
