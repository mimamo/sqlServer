USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[BPv_RQUserSubAct_SubAcct]    Script Date: 12/21/2015 14:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_RQUserSubAct_SubAcct] as

select x.Descr, x.Sub, u.UserID
from Subacct x 
join RQUserSubAct u on x.Sub = u.Sub
where
x.Active = 1
GO
