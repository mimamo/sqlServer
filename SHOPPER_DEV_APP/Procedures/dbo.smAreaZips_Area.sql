USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smAreaZips_Area]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smAreaZips_Area]
	@parm1 varchar(10),
	@parm2 varchar(10)
AS
SELECT *
FROM smAreaZips
	left outer join smZipCode
		on smAreaZips.AreaZipCode = smZipCode.ZipId
WHERE AreaZipId = @parm1
	AND AreaZipCode LIKE @parm2
ORDER BY AreaZipId, AreaZipCode
GO
