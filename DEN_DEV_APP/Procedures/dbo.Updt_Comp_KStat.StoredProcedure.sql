USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Updt_Comp_KStat]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--bkb 7/20/99 #129
--11500
Create Procedure [dbo].[Updt_Comp_KStat] @parm1 varchar ( 1), @parm2 varchar ( 30), @parm3 varchar ( 10), @parm4 varchar ( 1),
	@parm5 smalldatetime, @parm6 varchar (8), @parm7 varchar (10) as
		Update component set
			kitstatus = @parm1,
			LUpd_DateTime = @parm5,
			LUpd_Prog = @parm6,
			LUpd_User = @parm7
		where kitid = @parm2
			and kitsiteid = @parm3
			and kitstatus = @parm4
GO
