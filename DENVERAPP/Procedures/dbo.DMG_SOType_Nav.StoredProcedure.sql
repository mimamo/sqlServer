USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_Nav]    Script Date: 12/21/2015 15:42:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOType_Nav]
	@CpnyID varchar(10),
	@SOTypeID varchar(4)
AS
	SELECT *
	FROM SOType
	WHERE CpnyID LIKE @CpnyID
	   AND SOTypeID LIKE @SOTypeID
	ORDER BY SOTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
