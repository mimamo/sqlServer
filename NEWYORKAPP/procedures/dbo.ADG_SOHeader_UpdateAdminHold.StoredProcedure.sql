USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOHeader_UpdateAdminHold]    Script Date: 12/21/2015 16:00:47 ******/
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
