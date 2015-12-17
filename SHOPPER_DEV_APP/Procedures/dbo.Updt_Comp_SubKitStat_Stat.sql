USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Updt_Comp_SubKitStat_Stat]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--bkb 6/29/99 4.2
--11500
Create Procedure [dbo].[Updt_Comp_SubKitStat_Stat] @parm1 varchar ( 1), @parm2 varchar ( 1), @parm3 varchar ( 30), @parm4 varchar ( 10),
	@parm5 smalldatetime, @parm6 varchar (8), @parm7 varchar (10) as
		Update Component set
			subkitstatus = @parm1,
			status = @parm2,
			LUpd_DateTime = @parm5,
			LUpd_Prog = @parm6,
			LUpd_User = @parm7
		where cmpnentid = @parm3
			and siteid = @parm4
GO
