USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServLicense_ServCallId]    Script Date: 12/21/2015 13:35:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smServLicense_ServCallId]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smServLicense
	left outer join smLicense
		on smServLicense.LicenseID = smLicense.LicenseID
WHERE ServiceCallId = @parm1
	AND smServLicense.LicenseID LIKE @parm2
ORDER BY ServiceCallId
	,smServLicense.LicenseID
GO
