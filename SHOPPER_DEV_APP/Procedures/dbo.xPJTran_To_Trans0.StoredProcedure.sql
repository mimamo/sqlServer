USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJTran_To_Trans0]    Script Date: 12/21/2015 14:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[xPJTran_To_Trans0]
 @batnbr varchar(10)

as 

select 	
	*
from 
	 PJTfrDet a join pjtran b
on 
	 a.Origfiscalno = b.fiscalno and
     a.Origsystem_cd = b.system_cd and
     a.Origbatch_id = b.batch_id and
     a.Origdetail_num = b.detail_num
join
	Batch c 
on
	a.batch_id = c.batnbr and 
	c.module = 'PA'
join 
	PJTrnsfr d 
on
    a.Origfiscalno = d.Origfiscalno and
    a.Origsystem_cd = d.Origsystem_cd and
    a.Origbatch_id = d.Origbatch_id and
    a.Origdetail_num = d.Origdetail_num
join
	pjtranex e
on
	b.fiscalno		= e.fiscalno and
    b.system_cd		= e.system_cd and
    b.batch_id		= e.batch_id and
    b.detail_num	= e.detail_num
where
	c.batnbr = @batnbr and
	c.module = 'PA' and
	a.TfrType IN ('S', 'M')
GO
