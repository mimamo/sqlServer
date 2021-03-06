USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOLine_Update_Cancel]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WOSOLine_Update_Cancel]
	@CpnyID			varchar( 10 ),
	@OrdNbr			varchar( 15 ),
	@LineRef		varchar( 5 ),
	@WOPendingProject	varchar( 16 ),
	@UserID			varchar ( 10 ),
	@ProgID			varchar ( 8 )
AS

	DECLARE			@CustID	varchar( 15 )
	DECLARE			@InvtID	varchar( 30 )

	-- Retrieve CustID and InvtID from SOLine
	SELECT			@CustID = SOHeader.CustID, @InvtID = SOLine.InvtID
	FROM			SOLine Left Outer Join SOHeader
				On SOLine.CpnyID = SOHeader.CpnyID
				and SOLine.OrdNbr = SOHeader.OrdNbr
	WHERE			SOLine.CpnyID = @CpnyID
				and SOLine.OrdNbr = @OrdNbr
				and SOLine.LineRef = @LineRef
		-- Update SOLine with WO Request 'Project'
	UPDATE			SOLINE
	SET			ProjectID = @WOPendingProject,
				TaskID = '',
				BoundToWO = 1,
				LUpd_Prog = @ProgID,
				LUpd_User = @UserID
	WHERE			CpnyID = @CpnyID and
				OrdNbr = @OrdNbr and
				LineRef = @LineRef

	-- Re-instate the WORequest record
	EXEC SCM_WORequest_Insert @CpnyID, @OrdNbr, @LineRef, @CustID, @InvtID, @UserID, @ProgID
GO
