USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjbillch_ustat]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjbillch_ustat] @parm1 varchar (16) , @parm2 varchar (6) , @parm3 varchar (1) , @parm4 varchar (1)   as
update PJBILLCH
set status = @parm4
where PJBILLCH.project =  @parm1 and
PJBILLCH.appnbr > @parm2 and
PJBILLCH.status =  @parm3
GO
