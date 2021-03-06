USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_GLTran_NextLineID]    Script Date: 12/21/2015 14:06:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_GLTran_NextLineID]
	@Module	Char(2),
	@BatNbr	VarChar(10),
	@CpnyID	VarChar(10),
	@LineID	Integer OutPut
As
	Set	NoCount On
	Select	@LineID = Max(LineID)
		From	GLTran (NoLock)
		Where	Module = @Module
			And BatNbr = @BatNbr
			And CpnyID = @CpnyID
	Select	@LineID = Coalesce(@LineID, 0) + 1
GO
