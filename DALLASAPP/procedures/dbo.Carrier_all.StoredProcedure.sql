USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Carrier_all]    Script Date: 12/21/2015 13:44:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Carrier_all] @parm1 varchar( 10 )
AS
	SELECT *
	FROM Carrier
	WHERE CarrierID LIKE @parm1
	ORDER BY CarrierID
GO
