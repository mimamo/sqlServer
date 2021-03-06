USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTRAN_utran]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PRTRAN_utran] @parm1 varchar (1) , @parm2 varchar (10) , @parm3 varchar (10) , @parm4 varchar (24) , @parm5 smallint , @parm6 varchar (10) , @parm7 varchar (2)   as
update PRTRAN
set pc_status = @parm1
where
PRTRAN.batnbr = @parm2 and
PRTRAN.chkacct = @parm3 and
PRTRAN.chksub = @parm4 and
PRTRAN.linenbr =  @parm5 and
PRTRAN.refnbr =  @parm6 and
PRTRAN.trantype = @parm7
GO
