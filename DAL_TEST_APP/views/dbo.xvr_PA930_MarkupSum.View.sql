USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA930_MarkupSum]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_PA930_MarkupSum]

as

select 

tr_id12			=	a.tr_id12,  	--Originating Tran ID
Amount			=   	sum(a.amount),
Trans_date		=	min(a.trans_date)

from 

xvr_PA930_MarkupDet a

group by tr_id12
GO
