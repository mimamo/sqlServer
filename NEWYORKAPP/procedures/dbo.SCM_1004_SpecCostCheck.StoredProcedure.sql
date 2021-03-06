USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_1004_SpecCostCheck]    Script Date: 12/21/2015 16:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[SCM_1004_SpecCostCheck]
	@site_id 		char(10),
	@invt_id 		char(30),
	@spec_cost_id	char (25)
AS
	SELECT	TOP 1 Qty
	FROM	ItemCost (NOLOCK)
	WHERE	InvtId = @invt_id
	AND	SiteID = @site_id
	AND	LayerType = 'S'
	AND	SpecificCostID = @spec_cost_id
	ORDER BY InvtID, SiteID, LayerType, SpecificCostID, RcptNbr, RcptDate
GO
