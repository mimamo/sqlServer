USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_BlanketOrder_UpdateQtys]    Script Date: 12/21/2015 15:49:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_BlanketOrder_UpdateQtys]
	@CpnyID		varchar(10),	-- Company ID
	@OrdNbr		varchar(15),	-- Child Sales Order Number
	@BlktOrdNbr	varchar(15)	-- Blanket Order Number
as
	set nocount on

	-- Update Blanket Order SOSched.QtyShip
	-- BO = Blanket Order; CSO = Child Sales Order
	update	BO
	set	BO.QtyShip = Case When CSo.Status = 'C' Then (BO.QtyShip
						- round(convert(decimal(25,9), case when BOL.UnitMultDiv = 'D' then CSO.S4Future03 * BOL.CnvFact when BOL.CnvFact <> 0 then CSO.S4Future03 / BOL.CnvFact else 0 end), DecPlNonStdQty)
						+ round(convert(decimal(25,9), case
						when CSOL.UnitMultDiv = 'M' and BOL.UnitMultDiv = 'D' then CSO.QtyShip * CSOL.CnvFact * BOL.CnvFact
						when CSOL.UnitMultDiv = 'M' and BOL.CnvFact <> 0 then CSO.QtyShip * CSOL.CnvFact / BOL.CnvFact
						when CSOL.CnvFact <> 0 and BOL.UnitMultDiv = 'D'  then CSO.QtyShip / CSOL.CnvFact * BOL.CnvFact
						when CSOL.CnvFact <> 0 and BOL.CnvFact <> 0 then CSO.QtyShip / CSOL.CnvFact / BOL.CnvFact
						else 0 end), DecPlNonStdQty))
				Else (BO.QtyShip
						+ round(convert(decimal(25,9), case
						when CSOL.UnitMultDiv = 'M' and BOL.UnitMultDiv = 'D' then CSO.QtyOrd * CSOL.CnvFact * BOL.CnvFact
						when CSOL.UnitMultDiv = 'M' and BOL.CnvFact <> 0 then CSO.QtyOrd * CSOL.CnvFact / BOL.CnvFact
						when CSOL.CnvFact <> 0 and BOL.UnitMultDiv = 'D'  then CSO.QtyOrd / CSOL.CnvFact * BOL.CnvFact
						when CSOL.CnvFact <> 0 and BOL.CnvFact <> 0 then CSO.QtyOrd / CSOL.CnvFact / BOL.CnvFact
						else 0 end), DecPlNonStdQty)
						- round(convert(decimal(25,9), case when BOL.UnitMultDiv = 'D' then CSO.S4Future03 * BOL.CnvFact when BOL.CnvFact <> 0 then CSO.S4Future03 / BOL.CnvFact else 0 end), DecPlNonStdQty))
				End

	from	SOSched BO
	inner	join SOLine BOL on BOL.CpnyID = BO.CpnyID and BOL.OrdNbr = BO.OrdNbr and BOL.LineRef = BO.LineRef
	inner	join SOLine CSOL on CSOL.CpnyID = BO.CpnyID and CSOL.OrdNbr = @OrdNbr and CSOL.S4Future11 = BO.LineRef
	inner	join SOSched CSO on
		BO.CpnyID = CSO.CpnyID
	cross	join SOSetup (nolock)
	where	BO.CpnyID = @CpnyID
	and	BO.OrdNbr = @BlktOrdNbr
	and	CSO.OrdNbr = @OrdNBr
	and	rtrim(CSO.LineRef) = rtrim(CSOL.LineRef)
	and	rtrim(BO.SchedRef) = rtrim(CSO.S4Future02)
	and	len(CSO.S4Future02) > 0		-- excluded added lines

	-- Update Blanket Order SOLine.QtyShip and SOLine.qtycloseship
	-- BO = Blanket Order; CSO = Child Sales Order
	update	BO
	set	BO.QtyShip = Case When CSo.Status = 'C' Then (BO.QtyShip
						- round(convert(decimal(25,9), case when BO.UnitMultDiv = 'D' then CSO.S4Future04 * BO.CnvFact when BO.CnvFact <> 0 then CSO.S4Future04 / BO.CnvFact else 0 end), DecPlNonStdQty)
						+ round(convert(decimal(25,9), case
						when CSO.UnitMultDiv = 'M' and BO.UnitMultDiv = 'D' then CSO.QtyShip * CSO.CnvFact * BO.CnvFact
						when CSO.UnitMultDiv = 'M' and BO.CnvFact <> 0 then CSO.QtyShip * CSO.CnvFact / BO.CnvFact
						when CSO.CnvFact <> 0 and BO.UnitMultDiv = 'D'  then CSO.QtyShip / CSO.CnvFact * BO.CnvFact
						when CSO.CnvFact <> 0 and BO.CnvFact <> 0 then CSO.QtyShip / CSO.CnvFact / BO.CnvFact
						else 0 end), DecPlNonStdQty))
				Else (BO.QtyShip
						+ round(convert(decimal(25,9), case
						when CSO.UnitMultDiv = 'M' and BO.UnitMultDiv = 'D' then CSO.QtyOrd * CSO.CnvFact * BO.CnvFact
						when CSO.UnitMultDiv = 'M' and BO.CnvFact <> 0 then CSO.QtyOrd * CSO.CnvFact / BO.CnvFact
						when CSO.CnvFact <> 0 and BO.UnitMultDiv = 'D'  then CSO.QtyOrd / CSO.CnvFact * BO.CnvFact
						when CSO.CnvFact <> 0 and BO.CnvFact <> 0 then CSO.QtyOrd / CSO.CnvFact / BO.CnvFact
						else 0 end), DecPlNonStdQty)
						- round(convert(decimal(25,9), case when BO.UnitMultDiv = 'D' then CSO.S4Future04 * BO.CnvFact when BO.CnvFact <> 0 then CSO.S4Future04 / BO.CnvFact else 0 end), DecPlNonStdQty))
				End,
		BO.QtyCloseShip = Case When CSo.Status = 'C' Then (BO.QtyShip
						- round(convert(decimal(25,9), case when BO.UnitMultDiv = 'D' then CSO.S4Future04 * BO.CnvFact when BO.CnvFact <> 0 then CSO.S4Future04 / BO.CnvFact else 0 end), DecPlNonStdQty)
						+ round(convert(decimal(25,9), case
						when CSO.UnitMultDiv = 'M' and BO.UnitMultDiv = 'D' then CSO.QtyCloseShip * CSO.CnvFact * BO.CnvFact
						when CSO.UnitMultDiv = 'M' and BO.CnvFact <> 0 then CSO.QtyCloseShip * CSO.CnvFact / BO.CnvFact
						when CSO.CnvFact <> 0 and BO.UnitMultDiv = 'D'  then CSO.QtyCloseShip / CSO.CnvFact * BO.CnvFact
						when CSO.CnvFact <> 0 and BO.CnvFact <> 0 then CSO.QtyCloseShip / CSO.CnvFact / BO.CnvFact
						else 0 end), DecPlNonStdQty))
				Else (BO.QtyCloseShip
						+ round(convert(decimal(25,9), case
						when CSO.UnitMultDiv = 'M' and BO.UnitMultDiv = 'D' then CSO.QtyOrd * CSO.CnvFact * BO.CnvFact
						when CSO.UnitMultDiv = 'M' and BO.CnvFact <> 0 then CSO.QtyOrd * CSO.CnvFact / BO.CnvFact
						when CSO.CnvFact <> 0 and BO.UnitMultDiv = 'D'  then CSO.QtyOrd / CSO.CnvFact * BO.CnvFact
						when CSO.CnvFact <> 0 and BO.CnvFact <> 0 then CSO.QtyOrd / CSO.CnvFact / BO.CnvFact
						else 0 end), DecPlNonStdQty)
						- round(convert(decimal(25,9), case when BO.UnitMultDiv = 'D' then CSO.S4Future04 * BO.CnvFact when BO.CnvFact <> 0 then CSO.S4Future04 / BO.CnvFact else 0 end), DecPlNonStdQty))
				End
	from	SOLine BO
			join SOLine CSO on BO.CpnyID = CSO.CpnyID
	cross	join SOSetup (nolock)
	where	BO.CpnyID = @CpnyID
	and	BO.OrdNbr = @BlktOrdNbr
	and	CSO.OrdNbr = @OrdNBr
	and	rtrim(BO.LineRef) = rtrim(CSO.S4Future11)
	and	len(CSO.S4Future11) > 0		-- excluded added lines

	-- Update Child Sales Order SOSched.QtyOrd
	update	CSO
	set	S4Future03 = case when CSOL.UnitMultDiv = 'M' then CSO.QtyOrd * CSOL.CnvFact when CSOL.CnvFact <> 0 then CSO.QtyOrd / CSOL.CnvFact else 0 end
	from 	SOSched CSO
	inner 	join SOLine CSOL on CSOL.CpnyID = CSO.CpnyID and CSOL.OrdNbr = CSO.OrdNbr and CSOL.LineRef = CSO.LineRef
	where	CSO.CpnyID = @CpnyID
	and	CSO.OrdNbr = @OrdNbr
	and	len(CSO.S4Future02) > 0		-- exclude added lines

	-- Update Child Sales Order SOLine.QtyOrd
	update	SOLine
	set	S4Future04 = case when UnitMultDiv = 'M' then QtyOrd * CnvFact when CnvFact <> 0 then QtyOrd / CnvFact else 0 end
	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	and	len(S4Future11) > 0		-- exclude added lines
GO
