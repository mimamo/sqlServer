USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_ClearSRegID]    Script Date: 12/21/2015 15:49:08 ******/
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
