USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTRAN_uuser4]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PRTRAN_uuser4] @parm1 varchar (10) , @parm2 varchar (10) , @parm3 varchar (24) , @parm4 varchar (10) , @parm5 varchar (2) , @parm6 smallint     as
update PRTRAN
set user4 = 1
where
PRTRAN.batnbr = @parm1 and
PRTRAN.chkacct = @parm2 and
PRTRAN.chksub = @parm3 and
PRTRAN.refnbr =  @parm4 and
PRTRAN.trantype = @parm5 and
PRTRAN.linenbr =  @parm6
GO
