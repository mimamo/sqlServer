USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTRAN_utran]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARTRAN_utran] @parm1 varchar (1) , @parm2 varchar (15) , @parm3 varchar (2) , @parm4 varchar (10) , @parm5 smallint , @parm6 int, @parm7 varchar (8), @parm8 varchar (10), @parm9 smalldatetime      as
update ARTRAN
set pc_status = @parm1, lupd_prog = @parm7, lupd_user = @parm8, lupd_datetime = @parm9
where     ARTRAN.custid =  @parm2 and
ARTRAN.trantype = @parm3 and
ARTRAN.refnbr =  @parm4 and
ARTRAN.linenbr = @parm5 and
ARTRAN.recordid = @parm6
GO
