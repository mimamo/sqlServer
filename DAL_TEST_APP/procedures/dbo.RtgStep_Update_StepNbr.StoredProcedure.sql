USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_Update_StepNbr]    Script Date: 12/21/2015 13:57:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--11260
create procedure [dbo].[RtgStep_Update_StepNbr] @parm1 varchar (30),
	@parm2 varchar (10), @parm3 varchar (1), @parm4 integer,
	@parm5 varchar (5) as
	Update RtgStep set StepNbr = @parm5
	where
		KitId = @parm1 and
		Siteid = @parm2 and
		RtgStatus = @parm3 and
		LineNbr = @parm4
GO
