USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[BPv_RQUserAcct_AcctSub]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_RQUserAcct_AcctSub] as

select x.Acct, x.CpnyID, x.Descr, x.Sub, u.UserID, ISNULL(j.gl_acct,'~@~') PJAcct
from vs_AcctSub x 
join RQUserAcct u on x.Acct = u.Acct
left join pj_account j on x.Acct = j.gl_acct
where
x.Active = 1
GO
