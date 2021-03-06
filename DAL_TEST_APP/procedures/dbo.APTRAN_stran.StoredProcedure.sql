USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_stran]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_stran] @parm1 varchar (6)   as
select *
from  APTRAN apt, APDOC apd, PJ_ACCOUNT pac
where     apt.perpost =  @parm1 and
apt.rlsed =  1 and
apt.pc_status =  '1' and
apt.refnbr =  apd.refnbr and
apt.batnbr =  apd.batnbr and
apt.acct =  pac.gl_acct
GO
