USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[wcpv_ShipVia]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[wcpv_ShipVia](
	@ShopperID VARCHAR(32) = '%',
	@ShipViaID VARCHAR(15) = '%'
)As

	SELECT	s.Descr, u.ShopperID, s.CpnyID, s.ShipViaID
	FROM	ShipVia s (NOLOCK)
	JOIN    WCUser u (NOLOCK) ON u.ShopperID LIKE @ShopperID
	JOIN    WCUserGroup ug  (NOLOCK) ON ug.UserGroupID = u.UserGroupID AND ug.CpnyID = s.CpnyID
	WHERE	s.ShipViaID LIKE @ShipViaID
	ORDER BY s.Descr
GO
