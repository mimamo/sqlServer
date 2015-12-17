USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_ClearSRegID]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipHeader_ClearSRegID]
	@RegisterID varchar( 10 )
AS
	UPDATE 	SOShipHeader
	SET 	ShipRegisterID = ''
	WHERE 	ShipRegisterID = @RegisterID

	UPDATE	SOVoidInvc
	SET	ShipRegisterID = ''
	WHERE 	ShipRegisterID = @RegisterID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
