USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_utran]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_utran] @parm1 varchar (1) , @parm2 varchar (10) , @parm3 varchar (10) , @parm4 varchar (24) , @parm5 varchar (10) , @parm6 int   as
update APTRAN
set pc_status = @parm1
where APTRAN.batnbr =  @parm2 and
APTRAN.acct = @parm3 and
APTRAN.sub = @parm4 and
APTRAN.refnbr = @parm5 and
APTRAN.recordid =  @parm6
GO
