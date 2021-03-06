USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_FixDate_ItemCost]    Script Date: 12/21/2015 13:44:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_FixDate_ItemCost]
	@InvtIDParm VARCHAR (30)
As
	Update	ItemCost
		Set	RcptDate = Cast(Cast(Month(RcptDate) As VarChar(4)) + '/'
					+ Cast(Day(RcptDate) As VarChar(4)) + '/'
					+ Cast(Year(RcptDate) As VarChar(4)) As SmallDateTime)
		Where	Cast(Cast(Month(RcptDate) As VarChar(4)) + '/'
				+ Cast(Day(RcptDate) As VarChar(4)) + '/'
				+ Cast(Year(RcptDate) As VarChar(4)) As SmallDateTime) <> RcptDate
			AND ItemCost.InvtID LIKE @InvtIDParm
GO
