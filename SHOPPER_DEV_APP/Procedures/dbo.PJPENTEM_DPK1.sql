USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_DPK1]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_DPK1]  @parm1 varchar (16) as
    delete from PJPENTEM
        where Project = @parm1
		and Actual_amt = 0
		and Actual_units = 0
		and Revadj_amt = 0
		and Revenue_amt = 0
GO
