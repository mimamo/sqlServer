USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOHeader_UpdateAdminHold]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOHeader_UpdateAdminHold]
	@CpnyID		varchar (10),
	@OrdNbr 	varchar (15)

AS

	UPDATE	SOHeader
	  SET	AdminHold = 1
	WHERE	CpnyID = @CpnyID
 	  AND	OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
