USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBHSSUM_sPK0]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBHSSUM_sPK0]  @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (16) , @parm4 varchar (6)  as
select * from PJBHSSUM
where project =  @parm1 and
pjt_entity  =  @parm2 and
acct = @parm3 and
fiscalno = @parm4
order by project, pjt_entity, acct
GO
