USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILLCN_sProj]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBILLCN_sProj] @parm1 varchar (16)   as
select * from PJBILLCN
where project =  @parm1
order by project, appnbr, itemnbr, change_order_num
GO
