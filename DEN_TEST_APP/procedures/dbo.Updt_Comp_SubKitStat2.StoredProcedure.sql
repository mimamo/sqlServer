USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Updt_Comp_SubKitStat2]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--bkb 7/20/99 4.2
--11500
Create Procedure [dbo].[Updt_Comp_SubKitStat2] @parm1 varchar ( 1), @parm2 varchar ( 30), @parm3 varchar ( 10), @parm4 varchar ( 1),
	@parm5 smalldatetime, @parm6 varchar (8), @parm7 varchar (10) as
		Update Component set
			subkitstatus = @parm1,
			LUpd_DateTime = @parm5,
			LUpd_Prog = @parm6,
			LUpd_User = @parm7
		where cmpnentid = @parm2
			and siteid = @parm3
			and status = @parm4
GO
