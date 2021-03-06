USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Create_AB_Tran]    Script Date: 12/21/2015 14:34:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_Create_AB_Tran]
	@Acct		VarChar(10),
	@BMICuryID	VarChar(4),
	@BMIEffDate	SmallDateTime,
	@BMIExtCost	Float,
	@BMIMultDiv	Char(1),
	@BMIRate	Float,
	@BMIRtTp	VarChar(6),
	@BMITranAmt	Float,
	@BMIUnitPrice	Float,
	@CpnyID		VarChar(10),
	@DrCr		Char(1),
	@ExtCost	Float,
        @FiscYr 	VarChar(4),
	@InvtAcct	VarChar(10),
	@InvtID		VarChar(30),
	@InvtMult	SmallInt,
	@InvtSub	VarChar(24),
	@LayerType	Char(1),
	@LineNbr	SmallInt,
	@LineID		Integer,
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@PerPost	VarChar(6),
	@Qty		Float,
	@QtyUnCosted	Float,
	@RcptDate	SmallDateTime,
	@RcptNbr	VarChar(15),
	@SiteID		VarChar(10),
	@SpecificCostID	VarChar(25),
	@Sub		VarChar(24),
	@TranAmt	Float,
	@TranDesc	VarChar(30),
	@UpdInvQty	Integer,
	@UnitDesc	VarChar(6),
	@UnitMultDiv	Char(1),
	@UnitPrice	Float,
	@WhseLoc	VarChar(10)
As
	Insert 	Into	INTran
			(Acct, BMICuryID, BMIEffDate, BMIExtCost, BMIMultDiv, BMIRate,
			BMIRtTp, BMITranAmt, BMIUnitPrice, CnvFact, CpnyID, Crtd_Prog, Crtd_User, DrCr,
			ExtCost, FiscYr, InSuffQty, InvtAcct, InvtID,
			InvtMult, InvtSub, JrnlType, LayerType, LineNbr,
			LineID, LineRef, LUpd_DateTime, LUpd_Prog, LUpd_User,
			PerPost, PerEnt, Qty, QtyUnCosted, RcptDate,
			RcptNbr, Rlsed, S4Future09, S4Future10, SiteID, SpecificCostID,
			Sub, TranAmt, TranDesc, TranDate, TranType,
			UnitDesc, UnitMultDiv, UnitPrice, WhseLoc)
		Values
			(@Acct, @BMICuryID, @BMIEffDate, @BMIExtCost, @BMIMultDiv, @BMIRate,
			@BMIRtTp, @BMITranAmt, @BMIUnitPrice, 1, @CpnyID, @LUpd_Prog, @LUpd_User, @DrCr, @ExtCost,
			@FiscYr, Case When @QtyUnCosted > 0 Then 1 Else 0 End, @InvtAcct, @InvtID, @InvtMult,
			@InvtSub, 'IN', @LayerType, @LineNbr, @LineID,
			Right('00000' + Cast(@LineID As VarChar(5)), 5), GetDate(), @LUpd_Prog, @LUpd_User, @PerPost,
			@PerPost, @Qty, @QtyUnCosted, @RcptDate, @RcptNbr,
			1, @UpdInvQty, 0, @SiteID,  @SpecificCostID, @Sub,
			@TranAmt, @TranDesc, GetDate(), 'AB',
			@UnitDesc, 'M', @UnitPrice, @WhseLoc)
GO
