USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_spk0]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_spk0] @parm1 varchar (16)   as
select * from PJPTDSUM, PJACCT
where PJPTDSUM.project =  @parm1 and
PJPTDSUM.acct = PJACCT.acct and
(PJACCT.acct_type = 'RV' or
	  PJACCT.acct_type = 'EX')
order by PJPTDSUM.pjt_entity, PJACCT.sort_num, PJACCT.acct
GO
