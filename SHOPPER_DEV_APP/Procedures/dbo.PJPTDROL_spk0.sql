USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_spk0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_spk0] @parm1 varchar (16)   as
select * from  PJPTDROL, PJACCT
where PJPTDROL.project =  @parm1 and
PJPTDROL.acct = PJACCT.acct and
(PJACCT.acct_type = 'RV' or
	  PJACCT.acct_type = 'EX')
order by PJACCT.sort_num, PJACCT.acct
GO
