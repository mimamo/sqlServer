USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJTran_Alloc_Reversal_Post0]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[xPJTran_Alloc_Reversal_Post0]
	@batnbr varchar(10)
as 

select 
	*
from
	PJTrnsfr a join PJTran b 
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
Join
	PJAllAud d 
on
	a.Origfiscalno = d.fiscalno and
	a.Origsystem_cd = d.system_cd and
	a.Origbatch_id = d.batch_id and
	a.Origdetail_num = d.detail_num and
	d.post_project <> '' and
	d.recalc_flag = ''
join
	pjtranex e
on
	b.fiscalno		= e.fiscalno and
    b.system_cd		= e.system_cd and
    b.batch_id		= e.batch_id and
    b.detail_num	= e.detail_num
where
	c.batnbr = @batnbr and
	c.module = 'PA'
GO
