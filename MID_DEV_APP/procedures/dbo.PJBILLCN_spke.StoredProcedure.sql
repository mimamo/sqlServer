USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILLCN_spke]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBILLCN_spke] @parm1 varchar (16) , @parm2 varchar (6) , @parm3 varchar (6) , @parm4 varchar (16)   as
select * from PJBILLCN
where project =  @parm1 and
appnbr  =  @parm2 and
itemnbr  =  @parm3 and
change_order_num  =  @parm4
order by project, appnbr, itemnbr, change_order_num
GO
