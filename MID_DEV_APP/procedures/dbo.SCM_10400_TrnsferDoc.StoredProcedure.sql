USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_TrnsferDoc]    Script Date: 12/21/2015 14:17:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_TrnsferDoc]
		@BatNbr		VarChar(10),
		@CpnyID		VarChar(10)
As
	Select	Distinct
		BatNbr, CpnyID, ShipperID, SiteID, Source, ToSiteID,
		TransferType, TrnsfrDocNbr
		From TrnsfrDoc (NoLock)
		Where 	BatNbr = @BatNbr
			And CpnyID = @CpnyID
Union
	Select	BatNbr, CpnyID, ShipperID, SiteID, Source, ToSiteID,
		TransferType, TrnsfrDocNbr
		From TrnsfrDoc (NoLock)
		Where	S4Future11 = @BatNbr
--			And CpnyID = @CpnyID
/*
Union
	Select	BatNbr = RcptBatNbr, CpnyID, ShipperID, SiteID, Source, ToSiteID,
		TransferType, TrnsfrDocNbr
		From TrnsfrDoc (NoLock)
		Where 	RcptBatNbr = @BatNbr
			And CpnyID = @CpnyID
Union
	Select	BatNbr = CostBatNbr, CpnyID, ShipperID, SiteID, Source, ToSiteID,
		TransferType, TrnsfrDocNbr
		From TrnsfrDoc (NoLock)
		Where 	CostBatNbr = @BatNbr
			And CpnyID = @CpnyID
*/
GO
