USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_ustat]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJTRAN_ustat] @parm1 varchar (10) , @parm2 varchar (8) , @parm3 varchar (6) , @parm4 varchar (6) , @parm5 varchar (2) , @parm6 varchar (10) , @parm7 int   as
update PJTRAN
set tr_status = @parm1,
lupd_datetime = getdate(),
lupd_user = @parm2,
lupd_prog = @parm3
where PJTRAN.fiscalno =  @parm4 and
PJTRAN.system_cd = @parm5 and
PJTRAN.batch_id = @parm6 and
PJTRAN.detail_num =  @parm7
GO
