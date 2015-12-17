USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FCSetup_Options]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FCSetup_Options]
AS
	-- Use explicit values until FCSetup record is available
	select	Cast(1 as smallint), 'Y', 'Y', 'F', 'R', Cast(1 as smallint)

        --Select	DfltWIPIntegrity,
        --		DfltBackFlushMtl,
        --		DfltBackFlushLbr,
	--		DfltScheduleOption,
        --		DfltScheduleMaterials,
        --		DfltAdjustCmpQty
	--From		FCSetup (NoLock)
GO
