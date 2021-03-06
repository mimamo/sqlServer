USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_pa930_pjtran]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_pa930_pjtran]
as
SELECT TOP 100 PERCENT	--Select for non - 'WP', 'CM' and 'WA' transactions

Project		= a.project,
pjt_entity	= a.pjt_entity,
Acct		= a.acct,
tr_id03		= a.tr_id03,
vendor_num	= a.vendor_num,
employee	= a.employee,
trans_date	= a.trans_date,
Amount		= a.amount ,
Units		= a.units,
tr_id02		= a.tr_id02,
tr_id08		= a.tr_id08,
tr_comment	= a.tr_comment,

--20070412:rf:remove reference to pjtranex, tr_id11 now stored in PJTRAN.tr_id23
--tr_id11		= b.tr_id11
tr_id11		= a.tr_id23

From

pjtran a  join 
--20070412:rf:remove reference to pjtranex
--pjtranex b on 	a.fiscalno = b.fiscalno and
--                a.system_cd = b.system_cd and
--                a.batch_id = b.batch_id and
--                a.detail_num = b.detail_num join
pjacct c on  	a.acct = c.acct and c.acct_group_cd in ('FE', 'HR','PB')
GO
