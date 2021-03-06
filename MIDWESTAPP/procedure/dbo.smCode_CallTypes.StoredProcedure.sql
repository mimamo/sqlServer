USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smCode_CallTypes]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCode_CallTypes]
		@parm1	varchar(10)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smCodeType
		,smCode
	WHERE
		smCodeType.CallTypeId = @parm1
			AND
		smCodeType.Fault_Id = smCode.Fault_Id
			AND
		smCodeType.Fault_Id LIKE @parm2
	ORDER BY
		smCodeType.Fault_Id

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
