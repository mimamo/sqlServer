USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Insert_Item2Hist]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_Insert_Item2Hist]
	@InvtID		VarChar(30),	/*  INTran.InvtID  */
	@SiteID		VarChar(10),	/*  INTran.SiteID  */
	@MinFiscYr	Integer,
	@INPerNbr	Char(6),	/*  INSetup.PerNbr  */
	@MaxFiscYr	Integer,
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@BaseDecPl	SmallInt,
	@BMIDecPl	SmallInt,
	@DecPlPrcCst	SmallInt,
	@DecPlQty	SmallInt

As

	Set	NoCount On

	Declare	@INFiscYr	Integer

	Set	@INFiscYr = Cast(Left(@INPerNbr, 4) As Integer)

	If	@MaxFiscYr < @INFiscYr
	Begin
		If	Exists(Select	InvtID
					From	ItemSite (NoLock)
					Where	InvtID = @InvtID
						And SiteID = @SiteID
						And Round(QtyOnHand, @DecPlQty) <> 0)
		Begin
			Set	@MaxFiscYr = @INFiscYr
		End
	End

	While	(@MinFiscYr <= @MaxFiscYr)
	Begin
		If Not Exists(Select InvtID
					From	Item2Hist (NoLock)
					Where	InvtID = @InvtID
						And SiteID = @SiteID
						And FiscYr = Cast(@MinFiscYr As Char(4)))
		Begin

			Insert 	Into Item2Hist
					(Crtd_DateTime, Crtd_Prog, Crtd_User, FiscYr, InvtID,
					LUpd_DateTime, LUpd_Prog, LUpd_User, SiteID)
				Values
					(GetDate(), @LUpd_Prog, @LUpd_User, @MinFiscYr, @InvtID,
					GetDate(),  @LUpd_Prog, @LUpd_User, @SiteID)
		End

		Set	@MinFiscYr = @MinFiscYr + 1
	End
GO
