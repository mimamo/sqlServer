USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOSUBH_SSTATUS]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOSUBH_SSTATUS]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (1)   as
select * from PJCOSUBH
where
PJCOSUBH.project            =    @parm1 and
PJCOSUBH.subcontract        =    @parm2 and
PJCOSUBH.status1            =    @parm3
order by PJCOSUBH.project,
PJCOSUBH.subcontract,
PJCOSUBH.change_order_num
GO
