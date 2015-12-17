USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBHSROL_sSum]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBHSROL_sSum]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (6)   as
select sum(total_budget_amount), sum (total_budget_units), sum (eac_amount), sum (eac_units), sum (fac_amount), sum (fac_units)
from pjbhsrol
where project =  @parm1 and
acct = @parm2 and
fiscalno <= @parm3
GO
