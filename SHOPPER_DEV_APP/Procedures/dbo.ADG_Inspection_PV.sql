USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inspection_PV]    Script Date: 12/16/2015 15:55:10 ******/
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
