USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOSUBD_SPK0]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOSUBD_SPK0]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (16) , @parm4 varchar (4)   as
select * from PJCOSUBD
where
PJCOSUBD.project            =    @parm1 and
PJCOSUBD.subcontract        =    @parm2 and
PJCOSUBD.change_order_num   =    @parm3 and
PJCOSUBD.sub_line_item      =    @parm4
order by PJCOSUBD.project,
PJCOSUBD.subcontract,
PJCOSUBD.change_order_num,
PJCOSUBD.sub_line_item
GO
