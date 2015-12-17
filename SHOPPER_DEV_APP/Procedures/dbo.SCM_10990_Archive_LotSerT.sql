USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Archive_LotSerT]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_Archive_LotSerT]
As
	Set	NoCount On
	Declare	@ErrorNo	Integer
	Set	@ErrorNo = 0
	Begin	Transaction

	Insert	Into LotSerTArch
		(BatNbr, CpnyID, Crtd_DateTime, Crtd_Prog, Crtd_User,
		CustID, ExpDate, INTranLineID, INTranLineRef, InvtID,
		InvtMult, KitID, LineNbr, LotSerNbr, LotSerRef,
		LUpd_DateTime, LUpd_Prog, LUpd_User, MfgrLotSerNbr, NoQtyUpdate,
		NoteID, ParInvtID, ParLotSerNbr, Qty, RcptNbr,
		RecordID, RefNbr, Retired, Rlsed, S4Future01,
		S4Future02, S4Future03, S4Future04, S4Future05, S4Future06,
		S4Future07, S4Future08, S4Future09, S4Future10, S4Future11,
		S4Future12, ShipContCode, ShipmentNbr, SiteID, ToSiteID,
		ToWhseLoc, TranDate, TranSrc, TranTime, TranType,
		UnitCost, UnitPrice, User1, User2, User3,
		User4, User5, User6, User7, User8,
		WarrantyDate, WhseLoc)
	Select	BatNbr, CpnyID, Crtd_DateTime, Crtd_Prog, Crtd_User,
		CustID, ExpDate, INTranLineID, INTranLineRef, InvtID,
		InvtMult, KitID, LineNbr, LotSerNbr, LotSerRef,
		LUpd_DateTime, LUpd_Prog, LUpd_User, MfgrLotSerNbr, NoQtyUpdate,
		NoteID, ParInvtID, ParLotSerNbr, Qty, RcptNbr,
		RecordID, RefNbr, Retired, Rlsed, S4Future01,
		S4Future02, S4Future03, S4Future04, S4Future05, S4Future06,
		S4Future07, S4Future08, S4Future09, S4Future10, S4Future11,
		S4Future12, ShipContCode, ShipmentNbr, SiteID, ToSiteID,
		ToWhseLoc, TranDate, TranSrc, TranTime, TranType,
		UnitCost, UnitPrice, User1, User2, User3,
		User4, User5, User6, User7, User8,
		WarrantyDate, WhseLoc
		From	LotSerT
		Where	S4Future05 = 1
	Set	@ErrorNo = @@Error
	If	(@ErrorNo = 0)
		Commit Transaction
	Else
		Rollback Transaction
GO
