USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[BPv_RQUserAcct_AcctXRef]    Script Date: 12/21/2015 16:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_RQUserAcct_AcctXRef] as

select x.Acct, x.AcctType, x.CpnyID, x.Descr, u.UserID, ISNULL(j.gl_acct,'~@~') PJAcct
from vs_AcctXref x 
join RQUserAcct u on x.Acct = u.Acct
left join pj_account j on x.Acct = j.gl_acct
where
x.Active = 1
GO
