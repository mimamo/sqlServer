USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOVoidInvc_UpdtShipRegID]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOVoidInvc_UpdtShipRegID]
	@RegisterID varchar( 10 ),
	@CpnyID varchar(10)
AS
	UPDATE 	SOVoidInvc
	SET 	ShipRegisterID = @RegisterID
	WHERE 	ShipRegisterID = ''
	  AND	CpnyID like @CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
