USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smWrkExpire_All]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smWrkExpire_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smWrkExpire
	WHERE
		ContractId LIKE @parm1
	ORDER BY
		ContractId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
