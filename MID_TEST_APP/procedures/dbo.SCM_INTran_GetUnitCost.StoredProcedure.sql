USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_INTran_GetUnitCost]    Script Date: 12/21/2015 15:49:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[SCM_INTran_GetUnitCost]

	@CpnyID		varchar(10),
	@BatNbr		VARCHAR(10),
	@InvcNbr	VARCHAR(15),
	@LineRef	VARCHAR(5),
	@SpecificCostID	VarChar(25)

as

	Declare @DecPlPrcCst as	SmallInt
	SELECT 	@DecPlPrcCst = COALESCE(DecPlPrcCst, 0) From vp_DecPl

	Select	UnitCost = COALESCE(Round(Sum(ExtCost) / Sum(Case When UnitMultDiv = 'D' Then Qty / CnvFact Else Qty * CnvFact End), @DECPLPRCCST), 0)
	FROM	INTRAN
	WHERE	BATNBR = @BatNbr
	  AND 	CPNYID = @CpnyID
	  AND 	REFNBR = @InvcNbr
	  AND 	ARLINEREF = @LineRef
	  AND	SpecificCostID = @SpecificCostID
	  AND 	TRANTYPE NOT IN ('CT', 'CG')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
