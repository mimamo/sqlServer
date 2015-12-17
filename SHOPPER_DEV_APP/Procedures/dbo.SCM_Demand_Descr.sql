USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Demand_Descr]    Script Date: 12/16/2015 15:55:32 ******/
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
