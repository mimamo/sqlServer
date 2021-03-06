USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DEL_Batch_PRTran_TimeSheet]    Script Date: 12/21/2015 16:13:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[DEL_Batch_PRTran_TimeSheet] @parm1 varchar ( 6), @parm2 varchar ( 6) as
       Delete batch
			from Batch
				left outer join PRTran
					on Batch.BatNbr = PRTran.BatNbr
			where Batch.EditScrnNbr IN ('02010', '02020')
				and Batch.Status  in ('V', 'D', 'C')
				and Batch.PerPost <= @parm1
				and Batch.PerEnt  <  @parm2
GO
