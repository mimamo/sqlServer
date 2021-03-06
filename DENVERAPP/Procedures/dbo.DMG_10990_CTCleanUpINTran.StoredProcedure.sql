USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_CTCleanUpINTran]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_CTCleanUpINTran]
	@InvtIDParm		VARCHAR (30)
As
/*
	This procedure will clean up erroneous CT records created during the batch release
	due to S4Future10 = 1 on Service Series and Baseline transactions that had COGS batch
	process against them.
*/
	Set	NoCount On

	Delete	From INTran
		Where	TranDesc Like '%Ovrsld%'
			And TranType = 'CT'
			AND InvtID LIKE @InvtIDParm
GO
