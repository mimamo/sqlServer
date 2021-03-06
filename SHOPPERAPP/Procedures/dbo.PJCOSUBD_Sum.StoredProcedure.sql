USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOSUBD_Sum]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOSUBD_Sum]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (16)   as
select sum(change_amt), sum(change_units), PJCOSUBD.project, PJCOSUBD.subcontract, PJCOSUBD.change_order_num
from PJCOSUBD
where
PJCOSUBD.project            =    @parm1 and
PJCOSUBD.subcontract        =    @parm2 and
PJCOSUBD.change_order_num   =    @parm3
GROUP by PJCOSUBD.project,
PJCOSUBD.subcontract,
PJCOSUBD.change_order_num
GO
