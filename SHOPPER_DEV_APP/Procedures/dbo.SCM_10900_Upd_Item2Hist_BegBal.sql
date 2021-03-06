USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10900_Upd_Item2Hist_BegBal]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10900_Upd_Item2Hist_BegBal]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@FiscYr		Char(4),
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@BaseDecPl	SmallInt,
	@BMIDecPl 	SmallInt,
	@DecPlPrcCst 	SmallInt,
	@DecPlQty 	SmallInt
As
	Set	NoCount On

	Declare	@PrevFiscYr	Char(4),
		@RowCntr	Int

	If Not Exists(Select * From Inventory Where InvtId = @InvtId And StkItem = 1) Return

	Select	@RowCntr = 1, @PrevFiscYr = ''

	Declare	@MinFiscYr	SmallInt,
		@MaxFiscYr	SmallInt

	Select	@MinFiscYr = 0,
		@MaxFiscYr = 0

	Select	@MinFiscYr = Cast(Min(FiscYr) As SmallInt),
		@MaxFiscYr = Cast(Max(FiscYr) As SmallInt)
		From	Item2Hist (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID

	While	(@MaxFiscYr > @MinFiscYr)
	Begin
			Set	@PrevFiscYr = Cast(@MinFiscYr As Char(4))
		Set	@FiscYr = Cast(@MinFiscYr + 1 As Char(4))

		Update	Item2Hist
			Set	Item2Hist.BegQty = Round(PrevYear.BegQty + PrevYear.YTDQtyAdjd
				- PrevYear.YTDQtyIssd + PrevYear.YTDQtyRcvd - PrevYear.YTDQtySls
				+ PrevYear.YTDQtyTrsfrIn - PrevYear.YTDQtyTrsfrOut, @DecPlQty),
				LUpd_Prog = @LUpd_Prog,
				LUpd_User = @LUpd_User,
				LUpd_DateTime = GetDate()
			From	Item2Hist Inner Join Item2Hist PrevYear
				On Item2Hist.InvtID = PrevYear.InvtID
				And Item2Hist.SiteID = PrevYear.SiteID
			Where	Item2Hist.FiscYr = @FiscYr
				And PrevYear.FiscYr = @PrevFiscYr
				And Item2Hist.InvtID = @InvtID
				And Item2Hist.SiteID = @SiteID

		Select	@MinFiscYr = @MinFiscYr + 1

	End
GO
