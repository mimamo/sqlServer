USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRPlanOrd_DelUnFirmed]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRPlanOrd_DelUnFirmed] AS
	Delete from IRPlanOrd where status in ('UF')
GO
