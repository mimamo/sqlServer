USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[BPv_RQUserSubAct_AcctSub]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_RQUserSubAct_AcctSub] as

select x.Acct, x.CpnyID, x.Descr, x.Sub, u.UserID
from vs_AcctSub x 
join RQUserSubAct u on x.Sub = u.Sub
where
x.Active = 1
GO
