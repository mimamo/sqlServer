USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRPlanOrd_DelUnFirmed]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRPlanOrd_DelUnFirmed] AS
	Delete from IRPlanOrd where status in ('UF')
GO
