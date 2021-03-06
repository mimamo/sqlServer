USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smZipLicense_LicID]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smZipLicense_LicID]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smZipLicense
	left outer join smZipCode
		on smZipLicense.ZipID = smZipCode.ZipId
WHERE smZipLicense.LicenseID = @parm1
	AND smZipLicense.ZipID LIKE @parm2
ORDER BY smZipLicense.LicenseID
	,smZipLicense.ZipID
GO
