USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRDemDetail_4145000]    Script Date: 12/21/2015 14:34:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRDemDetail_4145000]
	@DemandFormulaID VarChar(10)
As
Select
	*
From
	 IRDemDetail
Where
	DemandID Like @DemandFormulaID

Order By
	DemandID,
	PriorPeriodNbr
GO
