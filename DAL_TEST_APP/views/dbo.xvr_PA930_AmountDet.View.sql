USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA930_AmountDet]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA930_AmountDet]

as
select 
--20070412:rf:remove reference to pjtranex, tr_id11 now stored in PJTRAN.tr_id23
--tr_id11			=	b.tr_id11,		--Record Tran ID
tr_id11			= a.tr_id23,
--20070412:rf:remove reference to pjtranex, tr_id12 now stored in PJTRAN.user2
--tr_id12			=	b.tr_id12,  	--Originating Tran ID
tr_id12			= a.user2,
Acct_Group_cd		=	c.acct_group_cd,
Acct			=	a.acct,
Amount			=   	a.amount,
Trans_date		=	a.trans_date

from 

pjtran a	join 
--20070412:rf:remove reference to pjtranex
--pjtranex b on 	a.fiscalno = b.fiscalno and
--                a.system_cd = b.system_cd and
--                a.batch_id = b.batch_id and
--                a.detail_num = b.detail_num join
pjacct c on  	c.acct = a.acct and c.acct_group_cd IN ('WA','WP') -- Indicates a Billable account cat

--20070412:rf:remove reference to pjtranex, tr_id12 now stored in PJTRAN.user2
--where b.tr_id12 <> ''	--do not want to pull in any transactions that can't be tied back to an originating transaction
where a.user2 <> ''
GO
