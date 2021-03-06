USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xPJTran_BillMax_Reversal0]    Script Date: 12/21/2015 15:43:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[xPJTran_BillMax_Reversal0]
 @batnbr varchar(10), 
 @project varchar(16), 
 @maxacct varchar(16), 
 @addlacct varchar(16)

as 

select * from pjtran b

join pjtranex c
on c.fiscalno		= b.fiscalno
and c.system_cd		= b.system_cd
and c.batch_id		= b.batch_id
and c.detail_num	= b.detail_num

join batch d
on d.batnbr = b.batch_id
and d.module = 'PA'

where b.batch_id = @batnbr
and b.project = @project
and (b.acct = @maxacct or b.acct = @addlacct)
and b.amount < 0.0

order by b.detail_num
GO
