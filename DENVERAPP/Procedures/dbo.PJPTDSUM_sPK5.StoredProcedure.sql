USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_sPK5]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_sPK5] @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (16)   as
select * from PJPTDSUM
where project =  @parm1 and
pjt_entity  =  @parm2 and
acct = @parm3
order by project, pjt_entity, acct
GO
