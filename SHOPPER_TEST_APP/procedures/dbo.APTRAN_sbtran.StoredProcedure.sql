USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_sbtran]    Script Date: 12/21/2015 16:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_sbtran] @parm1 varchar (6), @parm2 varchar (10)   as
select apt.*, apd.*, pac.acct
from  APTRAN apt, APDOC apd, PJ_ACCOUNT pac
where
apt.perpost =  @parm1 and
apd.batnbr = @parm2 and
apt.rlsed =  1 and
apt.pc_status =  '1' and
apt.refnbr =  apd.refnbr and
apt.batnbr =  apd.batnbr and
apt.acct =  pac.gl_acct
GO
