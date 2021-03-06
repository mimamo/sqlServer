USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOPlan_SOBoundToWO]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOPlan_SOBoundToWO]
   	@CpnyID           varchar(10),
	@WONbr            Varchar(16),
	@WOBTLineRef      varchar(5)
AS
	IF PATINDEX('%[%]%', @WOBTLineRef) > 0
		SELECT            CpnyID, SOOrdNbr, SOLineRef, SOSchedRef
		FROM              SOPlan
		WHERE             Cpnyid = @CpnyID and
		                  WONbr = @WONbr and
		                  WOBTLineRef + '' LIKE @WOBTLineRef and
		                  SOOrdNbr <> '' and
		                  SOLineRef <> '' and
		                  PlanType IN ('54')		-- SO Bound to WO
		ORDER BY          CpnyID, WONbr, WOBTLineRef
	ELSE
		SELECT            CpnyID, SOOrdNbr, SOLineRef, SOSchedRef
		FROM              SOPlan
		WHERE             Cpnyid = @CpnyID and
		                  WONbr = @WONbr and
		                  WOBTLineRef = @WOBTLineRef and
		                  SOOrdNbr <> '' and
		                  SOLineRef <> '' and
		                  PlanType IN ('54')		-- SO Bound to WO
		ORDER BY          CpnyID, WONbr, WOBTLineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
