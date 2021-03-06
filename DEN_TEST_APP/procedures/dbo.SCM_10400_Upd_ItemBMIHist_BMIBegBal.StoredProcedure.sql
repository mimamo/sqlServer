USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Upd_ItemBMIHist_BMIBegBal]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_Upd_ItemBMIHist_BMIBegBal]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@Period		SmallInt,
	@FiscYr		Char(4),
	@Cost		Float,
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@BaseDecPl	SmallInt,
	@BMIDecPl 	SmallInt,
	@DecPlPrcCst 	SmallInt,
	@DecPlQty 	SmallInt
As
	Set	NoCount On

	Declare	@BMIBegBal		Float,
		@PrevFiscYr		Char(4)

	Select	@PrevFiscYr = Cast(Cast(@FiscYr As SmallInt) - 1 As Char(4))

	Select	@BMIBegBal = Round(BMIBegBal - BMIYTDCOGS + BMIYTDCostAdjd - BMIYTDCostIssd + BMIYTDCostRcvd, @BMIDecPl)
		From	ItemBMIHist (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And FiscYr = @PrevFiscYr
	Update	ItemBMIHist
		Set	BMIBegBal = Round(BMIBegBal + Round(Coalesce(@BMIBegBal, 0) + @Cost, @BMIDecPl), @BMIDecPl)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And FiscYr = @FiscYr
GO
