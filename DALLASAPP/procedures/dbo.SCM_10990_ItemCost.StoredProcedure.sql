USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_ItemCost]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_ItemCost]
	@ValMthd	Char(1),
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@LayerType	VarChar(2),
	@SpecificCostID	VarChar(25),
	@RcptDate	SmallDateTime,
	@RcptNbr	VarChar(15)
As
	Set	NoCount On

	If	DataLength(RTrim(@RcptNbr)) = 0
	Begin
		If	@ValMthd = 'L'
		Begin
			Select	*
				From	ItemCost (NoLock)
				Where	InvtID = @InvtID
					And SiteID = @SiteID
					And LayerType = @LayerType
					And SpecificCostID = @SpecificCostID
					And RcptNbr <> 'OVRSLD'
				Order By RcptDate Desc, RcptNbr Desc
		End
		Else
		Begin
			Select	*
				From	ItemCost (NoLock)
				Where	InvtID = @InvtID
					And SiteID = @SiteID
					And LayerType = @LayerType
					And SpecificCostID = @SpecificCostID
					And RcptNbr <> 'OVRSLD'
				Order By RcptDate, RcptNbr
		End
	End
	Else
	Begin
		Select	*
			From	ItemCost (NoLock)
			Where	InvtID = @InvtID
				And SiteID = @SiteID
				And LayerType = @LayerType
				And SpecificCostID = @SpecificCostID
				And RcptDate = @RcptDate
				And RcptNbr = @RcptNbr
	End
GO
