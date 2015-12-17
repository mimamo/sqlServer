USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10400_TrnsfrDocResetStatus]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[DMG_10400_TrnsfrDocResetStatus]
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10)
As

	Declare @OldStatus	char (1),
		@InvtMult	smallint

	Select	@OldStatus = status
	From 	TrnsfrDoc
	Where	BatNbr = @BatNbr
		And CpnyID = @CpnyID

	If @OldStatus = 'P' Begin
		Select	Top 1 	@InvtMult = InvtMult
		From	INTran (NoLock)
		Where	BatNbr = @BatNbr
			And CpnyID = @CpnyID
			And TranType = 'TR'
		Order by LineId Desc

		If @InvtMult = 1
			Update	TrnsfrDoc
			Set	status = 'R'
			Where	BatNbr = @BatNbr
				And CpnyID = @CpnyID

		If @InvtMult = -1
			Update	TrnsfrDoc
			Set	status = 'I'
			Where	BatNbr = @BatNbr
				And CpnyID = @CpnyID
	End
GO
