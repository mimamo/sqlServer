USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inspection_PV]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Inspection_PV]
	@InvtID varchar(30),
	@InspID	varchar(2)
AS
	SELECT 	InspID, Descr
	FROM 	Inspection
	WHERE 	InvtID like @InvtID
	  AND	InspID like @InspID
	ORDER BY InspID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
