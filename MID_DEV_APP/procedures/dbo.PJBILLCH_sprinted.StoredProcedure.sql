USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILLCH_sprinted]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBILLCH_sprinted] @parm1 varchar (16) , @parm2 varchar (6)   as
select * from PJBILLCH
where project =     @parm1 and
appnbr  like  @parm2 and
status  =     'P'
order by project, appnbr
GO
