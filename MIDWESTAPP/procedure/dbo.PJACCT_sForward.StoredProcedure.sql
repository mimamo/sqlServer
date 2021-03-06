USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJACCT_sForward]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACCT_sForward] @parm1 varchar (16)  as
select PJACCT.* from PJACCT, PJPTDROL
where
PJPTDROL.project = @parm1 and
(PJPTDROL.act_amount <> 0 or PJPTDROL.act_units <> 0) and
PJACCT.acct = PJPTDROL.acct and
(PJACCT.acct_type = 'AS' or PJACCT.acct_type = 'LB')
GO
