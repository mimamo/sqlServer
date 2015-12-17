USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemUsage_DemandTran_Purge]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ItemUsage_DemandTran_Purge] @DeleteThruPeriod varchar (6)
   As
	-- Purge old records from IRItemUsage table
	DELETE
		FROM IRItemUsage
	WHERE
		Period <= @DeleteThruPeriod

	-- Purge old records from IRDemandTran
	DELETE
		FROM IRDemandTran
	WHERE
		PerPost <= @DeleteThruPeriod
GO
