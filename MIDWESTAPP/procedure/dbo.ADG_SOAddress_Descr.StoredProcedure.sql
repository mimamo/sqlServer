USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOAddress_Descr]    Script Date: 12/21/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOAddress_Descr]
	@CustID 	varchar(15),
	@ShipToID	varchar(10)
AS
	SELECT	Descr
	FROM	SOAddress
	WHERE	CustID = @CustID
	  AND	ShipToID = @ShipToID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
