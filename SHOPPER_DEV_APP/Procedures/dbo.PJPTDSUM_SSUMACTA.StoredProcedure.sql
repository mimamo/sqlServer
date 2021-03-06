USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_SSUMACTA]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJPTDSUM_SSUMACTA] @parm1 varchar (16), @parm2 varchar (32), @parm3 varchar (16), @parm4 varchar (16) as
select sum(MX.act_amount)
  from (Select act_amount from pjptdsum
	  where project = @parm1 and pjt_entity = @parm2 and acct = @parm3
    union all
        Select act_amount from pjptdsum
	  where project = @parm1 and pjt_entity = @parm2 and acct = @parm4) as MX
GO
