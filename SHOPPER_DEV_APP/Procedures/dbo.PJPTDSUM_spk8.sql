USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_spk8]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_spk8] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from PJPTDSUM, PJACCT
where PJPTDSUM.project =  @parm1 and
PJPTDSUM.pjt_entity like @parm2 and
PJPTDSUM.acct = PJACCT.acct and
(PJACCT.acct_type = 'RV' or
PJACCT.acct_type = 'EX')
order by PJPTDSUM.pjt_entity, PJACCT.sort_num, PJACCT.acct
GO
