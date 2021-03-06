USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjptdrol_sSumActA]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjptdrol_sSumActA] @parm1 varchar (16), @parm2 varchar (16), @parm3 varchar (16) as
select sum(MX.act_amount)
  from (Select act_amount from pjptdrol
	  where project = @parm1 and acct = @parm2
    union all
        Select act_amount from pjptdrol
	  where project = @parm1 and acct = @parm3) as MX
GO
