USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILLCH_sappnbr]    Script Date: 12/21/2015 16:13:17 ******/
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
