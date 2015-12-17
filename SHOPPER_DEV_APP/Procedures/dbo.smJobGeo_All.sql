USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smJobGeo_All]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smJobGeo_All]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smJobGeo
	left outer join smArea
		on smJobGeo.GeographicID = smArea.AreaId
WHERE ConfigCode = @parm1
	AND GeographicID LIKE @parm2
ORDER BY ConfigCode
	 ,GeographicID
GO
