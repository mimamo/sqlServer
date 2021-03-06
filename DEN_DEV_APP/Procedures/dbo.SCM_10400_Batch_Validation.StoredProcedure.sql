USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Batch_Validation]    Script Date: 12/21/2015 14:06:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_10400_Batch_Validation]
	@BatNbr			Varchar(10)
As
		-- Validate the batch for duplicate lineref in INTran records
	SELECT  COUNT(*) FROM INTran (nolock)
				WHERE BatNbr = @BatNbr
					AND INTran.TranType Not In ('CG', 'CT')
				GROUP BY LineRef HAVING  COUNT(*) > 1
GO
