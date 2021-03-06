USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSCQGeo_All]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSCQGeo_All]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smSCQGeo
	left outer join smArea
		on smSCQGeo.GeographicID = smArea.AreaId
WHERE ConfigCode = @parm1
	AND GeographicID LIKE @parm2
ORDER BY ConfigCode
	,GeographicID
GO
