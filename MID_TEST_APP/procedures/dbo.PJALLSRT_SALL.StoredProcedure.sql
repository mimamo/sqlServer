USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLSRT_SALL]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLSRT_SALL]  @parm1 varchar (10), @parm2 varchar (16)  as
select * from PJALLSRT
where alloc_batch = @parm1 and
      src_project = @parm2
order by alloc_batch, src_project, project, pjt_entity, acct, cpnyid, employee, gl_subacct
GO
