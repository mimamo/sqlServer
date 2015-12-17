USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_CleanUpINTran_LayerType]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_CleanUpINTran_LayerType]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will clean up INTran records with a blank LayerType
*/
	Set	NoCount On

	Update	INTran
		Set	LayerType = 'S'
		Where	RTrim(LayerType) = ''
			AND InvtID LIKE @InvtIDParm
GO
