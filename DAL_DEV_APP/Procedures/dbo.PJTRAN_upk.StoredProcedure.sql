USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_upk]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_upk] @parm1 varchar (6) , @parm2 varchar (2) , @parm3 varchar (10) , @parm4 int    as
update PJTRAN
set alloc_flag = 'A'
where fiscalno       = @parm1  and
          system_cd  = @parm2  and
          batch_id      = @parm3  and
          detail_num = @parm4
GO
