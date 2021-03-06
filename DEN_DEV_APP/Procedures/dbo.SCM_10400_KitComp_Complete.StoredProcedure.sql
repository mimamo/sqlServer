USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_KitComp_Complete]    Script Date: 12/21/2015 14:06:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_KitComp_Complete]
	@BatNbr	VarChar(10),
	@CpnyID	VarChar(10),
	@KitID	VarChar(30),
	@RefNbr	VarChar(15)
As

	If	Exists(	Select	*
				From	INTran (NoLock)
				Where	BatNbr = @BatNbr
					And KitID = @KitID
					And CpnyID = @CpnyID
					And RefNbr = @RefNbr
					And Rlsed = 0)
		Select	Result = Cast(0 As SmallInt)
	Else
		Select	Result = Cast(1 As SmallInt)
GO
