USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_SPK7]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_SPK7] @parm1 varchar (16)   as
SELECT
p.project,
p.acct,
p.act_amount,
p.eac_amount,
p.com_amount,
a.acct_type
FROM  pjptdrol p, pjacct a
WHERE
p.project = @parm1 and
p.acct = a.acct  and
a.acct_type = 'EX'
Order by
p.project,
p.acct
GO
