USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_41440_PopulateDocID]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_41440_PopulateDocID]
	@SolDocID	VarChar(15),
	@UnAssignedID	varchar(15)
As
	Update	IRPlanOrd
		Set	SolDocID = @SolDocID,
			LUpd_DateTime = GetDate()
		Where	SolDocID = @UnAssignedID
			AND Status = 'CO'
GO
