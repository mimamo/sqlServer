USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Demand_Descr]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_Demand_Descr]
	@DemandID	VarChar(10)
As
	Select	Descr
		From	IRDemHeader (NoLock)
		Where	DemandID = @DemandID
GO
