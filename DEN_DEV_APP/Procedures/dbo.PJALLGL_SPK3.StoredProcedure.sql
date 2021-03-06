USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLGL_SPK3]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLGL_SPK3]  @parm1 varchar (10), @parm2 varchar (16)  as
select   sum(amount), cpnyid, gl_acct, gl_subacct, sum(units)
from    PJALLGL
where alloc_batch = @parm1 and
      source_project = @parm2
group by cpnyid, gl_acct, gl_subacct
order by cpnyid, gl_acct, gl_subacct
GO
