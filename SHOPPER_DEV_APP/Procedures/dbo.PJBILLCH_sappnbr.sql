USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILLCH_sappnbr]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBILLCH_sappnbr] @parm1 varchar (16) , @parm2 varchar (6)   as
select * from PJBILLCH
where project =  @parm1 and
appnbr  =  @parm2
order by project, appnbr
GO
