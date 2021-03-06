USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA930_AmountSum]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_PA930_AmountSum]

as

select 

tr_id12			=	a.tr_id12,  	--Originating Tran ID
acct			=	min(a.acct),
acct_group_cd	=	min(a.Acct_Group_cd),
Amount			=   	sum(a.amount),
Trans_date		=	min(a.trans_date)

from 

xvr_PA930_AmountDet a

group by tr_id12
GO
