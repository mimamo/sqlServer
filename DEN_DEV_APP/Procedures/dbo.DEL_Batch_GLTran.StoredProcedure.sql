USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DEL_Batch_GLTran]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[DEL_Batch_GLTran] @parm1 varchar ( 6), @parm2 varchar ( 6) as
       Delete batch
			from Batch
				left outer join GLTran
					on Batch.Module = GLTran.Module
					and Batch.BatNbr = GLTran.BatNbr
			where Batch.Module  =  'GL'
				and Batch.Status  in ('V', 'D', 'P')
				and Batch.PerPost <= @parm1
				and Batch.PerEnt  <  @parm2
GO
