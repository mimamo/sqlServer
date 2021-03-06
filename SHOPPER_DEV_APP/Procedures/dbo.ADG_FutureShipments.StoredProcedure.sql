USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_FutureShipments]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_FutureShipments]
	@CpnyID varchar(10),
	@OrdNbr varchar(15)
AS

	SELECT 	SOPlan.*, SOLine.UnitDesc, SOHeader.ShipName,
		SOLine.SiteID, SOLine.AlternateID, SOLine.Descr,
		SOLine.CnvFact, SOLine.UnitMultDiv
	FROM 	(SOHeader (nolock)
		INNER JOIN SOLine  (nolock)
		ON (SOHeader.OrdNbr = SOLine.OrdNbr)
		AND (SOHeader.CpnyID = SOLine.CpnyID))
		INNER JOIN SOPlan   (nolock)
		ON (SOLine.CpnyID = SOPlan.CpnyID)
		AND (SOLine.OrdNbr = SOPlan.SOOrdNbr)
		AND (SOLine.LineRef = SOPlan.SOLineRef)
	WHERE 	SOHeader.CpnyID = @CpnyID AND
		SOHeader.OrdNbr LIKE @OrdNbr AND
		SOPlan.PlanType in ('50', '52', '54', '60', '62', '64')
		ORDER BY SOHeader.OrdNbr, SOHeader.CustID, SOPlan.InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
