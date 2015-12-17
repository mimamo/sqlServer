USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smBRZone_Branch]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smBRZone_Branch]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smBRZone
	left outer join smArea
		on ZoneID = AreaId
WHERE BranchID = @parm1
	AND ZoneID LIKE @parm2
ORDER BY BranchID, ZoneID
GO
