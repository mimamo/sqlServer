USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_BOMDoc]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_BOMDoc]
	@BatNbr	VarChar(10)
As
	Select	*
		From	BOMDoc (NoLock)
		Where	BatNbr = @BatNbr
GO
