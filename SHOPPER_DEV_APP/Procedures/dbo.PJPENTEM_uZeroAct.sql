USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_uZeroAct]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_uZeroAct] @parm1 varchar (16)  as
Update PJPENTEM set
Actual_amt = 0,
Actual_units = 0,
Revadj_Amt = 0,
Revenue_Amt =0
WHERE project like @parm1
GO
