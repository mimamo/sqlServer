USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBUDROL_sPK5]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBUDROL_sPK5] @parm1 varchar (4) , @parm2 varchar (16) , @parm3 varchar (16)   as
select * from PJBUDROL
where
	fsyear_num = @parm1 and
	project =  @parm2 and
acct = @parm3  and
planNbr = '  '
order by  fsyear_num, project, acct
GO
