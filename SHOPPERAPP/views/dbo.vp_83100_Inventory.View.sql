USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vp_83100_Inventory]    Script Date: 12/21/2015 16:12:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_83100_Inventory]
AS
	-- This view lists only products that can be placed on a Sales Order.
	SELECT *
	FROM Inventory (NOLOCK)
	WHERE TranStatusCode IN ('AC', 'NP', 'OH')
GO
