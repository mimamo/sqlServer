USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpLicense_Emp]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smEmpLicense_Emp]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smEmpLicense
	left outer join smLicense
		on smemplicense.licenseid = smLicense.LicenseID
WHERE smEmpLicense.EmployeeId = @parm1
	AND smEmpLicense.LicenseID LIKE @parm2
ORDER BY smEmpLicense.EmployeeId
	,smEmpLicense.LicenseID
GO
