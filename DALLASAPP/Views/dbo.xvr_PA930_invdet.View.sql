USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA930_invdet]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA930_invdet]
as
SELECT 

in_id12			= d.in_id12,	--transaction id of allocated transaction that created billing record

--20070412:rf:remove reference to pjtranex, tr_id12 now stored in PJTRAN.user2
--tr_id12			= COALESCE(b.tr_id12,''),	--transaction id of originating cost transaction
tr_id12			= b.user2,

bill_status		= d.bill_status,
Amount			= COALESCE(d.amount,0),
invoice_num		= e.invoice_num,
ih_id12			= e.ih_id12,
invoice_type	= e.invoice_type,
draft_num		= d.draft_num,
invoice_date	= e.invoice_date

From

pjinvdet d join pjinvhdr e on	d.draft_num = e.draft_num left join

--20070412:rf:remove reference to pjtranex, tr_id11 now stored in PJTRAN.tr_id23
--pjtranex b on d.in_id12 = b .tr_id11
pjtran b on d.in_id12 = b.tr_id23

where d.bill_status = 'B'
GO
