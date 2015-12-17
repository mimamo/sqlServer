USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBHSROL_sPK0]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBHSROL_sPK0] @parm1 varchar (16) , @parm2 varchar (16)  , @parm3 varchar (6) as
select * from PJBHSROL
where project =  @parm1 and
acct = @parm2 and
fiscalno = @parm3
order by project, acct
GO
