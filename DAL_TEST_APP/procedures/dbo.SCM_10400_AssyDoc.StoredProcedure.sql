USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_AssyDoc]    Script Date: 12/21/2015 13:57:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_AssyDoc]
	@BatNbr	VarChar(10),
	@CpnyID	VarChar(10),
	@KitID	VarChar(30),
	@RefNbr	VarChar(15)
As
	Select	*
		From	AssyDoc (NoLock)
		Where	KitID = @KitID
			And RefNbr = @RefNbr
			And BatNbr = @BatNbr
			And CpnyID = @CpnyID
GO
