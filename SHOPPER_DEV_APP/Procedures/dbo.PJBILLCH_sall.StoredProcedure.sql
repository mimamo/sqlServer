USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILLCH_sall]    Script Date: 12/21/2015 14:34:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBILLCH_sall] @parm1 varchar (16) , @parm2 varchar (6)   as
select * from PJBILLCH
where project like  @parm1 and
appnbr  like  @parm2
order by project, appnbr
GO
