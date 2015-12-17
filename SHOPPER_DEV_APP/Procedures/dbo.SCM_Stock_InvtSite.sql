USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Stock_InvtSite]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_Stock_InvtSite]
	@ComputerName 	VARCHAR(21)
AS
		SELECT 	InvtID, SiteID

	FROM	INUpdateQty_Wrk

	WHERE 	ComputerName  = @ComputerName
GO
