USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBUDSUM_sPK5]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBUDSUM_sPK5] @parm1 varchar (4) , @parm2 varchar (16) , @parm3 varchar (32) , @parm4 varchar (16)   as
select * from PJBUDSUM
where
	fsyear_num = @parm1 and
	project =  @parm2 and
pjt_entity  =  @parm3 and
acct = @parm4
order by project, pjt_entity, acct
GO
