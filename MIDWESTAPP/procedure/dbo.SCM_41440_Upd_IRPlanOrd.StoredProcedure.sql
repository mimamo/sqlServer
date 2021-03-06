USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_41440_Upd_IRPlanOrd]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_41440_Upd_IRPlanOrd]
	@PlanOrdNbr	VarChar(15),
	@SolDocID	VarChar(15),
	@Status		VarChar(2),
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10)
As
	Update	IRPlanOrd
		Set	SolDocID = @SolDocID,
			Status = @Status,
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User,
			LUpd_DateTime = GetDate()
		Where	PlanOrdNbr = @PlanOrdNbr
GO
