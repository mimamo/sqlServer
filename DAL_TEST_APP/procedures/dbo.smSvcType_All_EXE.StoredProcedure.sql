USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcType_All_EXE]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcType_All_EXE]
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
