USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_UpdTStamp_LotSerMst]    Script Date: 12/21/2015 13:56:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_UpdTStamp_LotSerMst]
	@InvtIDParm	VARCHAR (30)
As
/*
	This procedure will update the LotSerMst comparison table by clearing the changed flag
	on all previous changed records, and updates the Master TimeStamp field from the TimeStamp
	from the LotSerMst table.
*/
	Set	NoCount On

	Update	IN10990_LotSerMst
		Set	MstStamp = LotSerMst.tStamp,
			Changed = 0
		From	LotSerMst Join IN10990_LotSerMst
			On LotSerMst.InvtID = IN10990_LotSerMst.InvtID
			And LotSerMst.SiteID = IN10990_LotSerMst.SiteID
			And LotSerMst.WhseLoc = IN10990_LotSerMst.WhseLoc
			And LotSerMst.LotSerNbr = IN10990_LotSerMst.LotSerNbr
		Where	LotSerMst.tStamp <> IN10990_LotSerMst.MstStamp
			AND IN10990_LotSerMst.InvtID LIKE @InvtIDParm
GO
