USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOPlan_SOBoundToPO]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOPlan_SOBoundToPO]
   	@CpnyID           varchar(10),
	@PONbr            Varchar(10),
	@POLineRef        varchar(5)
AS
	IF PATINDEX('%[%]%', @POLineRef) > 0
		SELECT            CpnyID, SOOrdNbr, SOLineRef, SOSchedRef
		FROM              SOPlan
		WHERE             Cpnyid = @CpnyID and
		                  PONbr = @PONbr and
	        	          POLineRef + '' LIKE @POLineRef and
		                  SOOrdNbr <> '' and
		                  SOLineRef <> '' and
	        	          PlanType IN ('50','52')
		ORDER BY          CpnyID, PONbr, POLineRef
	ELSE
		SELECT            CpnyID, SOOrdNbr, SOLineRef, SOSchedRef
		FROM              SOPlan
		WHERE             Cpnyid = @CpnyID and
		                  PONbr = @PONbr and
	        	          POLineRef = @POLineRef and
		                  SOOrdNbr <> '' and
		                  SOLineRef <> '' and
	        	          PlanType IN ('50','52')
		ORDER BY          CpnyID, PONbr, POLineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
