USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[CustCarriers_all]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustCarriers_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM CustCarriers
	WHERE CustID LIKE @parm1
	   AND CarrierID LIKE @parm2
	ORDER BY CustID,
	   CarrierID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
