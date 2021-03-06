USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCodeLicense_Fault_Id]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smCodeLicense_Fault_Id]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smCodeLicense
	left outer join smLicense
		on smCodeLicense.LicenseID = smLicense.LicenseID
WHERE Fault_Id = @parm1
	AND smCodeLicense.LicenseID LIKE @parm2
ORDER BY smCodeLicense.Fault_Id, smCodeLicense.LicenseID
GO
