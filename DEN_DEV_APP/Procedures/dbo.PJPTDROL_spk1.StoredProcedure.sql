USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_spk1]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_spk1] @parm1 varchar (16)   as
select * from  PJPTDROL, PJACCT
where PJPTDROL.project =  @parm1 and
PJPTDROL.acct = PJACCT.acct
order by PJACCT.sort_num, PJACCT.acct
GO
