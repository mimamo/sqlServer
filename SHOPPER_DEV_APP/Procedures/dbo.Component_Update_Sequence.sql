USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Component_Update_Sequence]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[Component_Update_Sequence] @parm1 varchar (30),
	@parm2 varchar (10), @parm3 varchar (1), @parm4 integer,
	@parm5 varchar (30), @parm6 varchar (5) as
	Update component set sequence = @parm6
	where
		KitId = @parm1 and
		KitSiteid = @parm2 and
		KitStatus = @parm3 and
		LineNbr = @parm4 and
		Cmpnentid = @parm5
GO
