USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcEquipment_Custid_EXE]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcEquipment_Custid_EXE]
		@parm1	varchar(15)
		,@parm2	varchar(10)
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smSvcEquipment With(INDEX (smSvcEquipment1))
	WHERE
		Status = 'A'
			AND
		CustId = @parm1
			AND
		SiteId = @parm2
			AND
		EquipID LIKE @parm3
	ORDER BY
		CustID, SiteID, EquipID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
