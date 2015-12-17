USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcType_All]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcType_All]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smSvcType
	WHERE
		EquipmentTypeId LIKE @parm1
	ORDER BY
		EquipmentTypeId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
