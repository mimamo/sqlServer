USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_PPApp_DBNav]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_PPApp_DBNav]
	@BatNbr varchar(10),
	@VORefNbr varchar(10)
AS

SELECT *
FROM	AP_PPApplicDet
WHERE	BatNbr LIKE @BatNbr AND VORefNbr LIKE @VORefNbr
ORDER	BY BatNbr,VORefNbr
GO
