USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJTran_BillMax_GetCreatedTrans0]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[xPJTran_BillMax_GetCreatedTrans0]
 @batnbr varchar(10) 

as 

select * from pjtran b

join pjtranex c
on c.fiscalno		= b.fiscalno
and c.system_cd		= b.system_cd
and c.batch_id		= b.batch_id
and c.detail_num	= b.detail_num

join batch d
on d.batnbr = b.batch_id
and d.module = b.system_cd
and d.module = 'PA'

where b.batch_id = @batnbr
and (b.tr_status = 'M1' or b.tr_status = 'M2')

order by b.detail_num
GO
