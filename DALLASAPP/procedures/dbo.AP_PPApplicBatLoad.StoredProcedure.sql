USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[AP_PPApplicBatLoad]    Script Date: 12/21/2015 13:44:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_PPApplicBatLoad]
	@BatNbr varchar(10)
AS

SELECT	* FROM AP_PPApplicBat
WHERE	BatNbr LIKE @BatNbr
ORDER	BY BatNbr
GO
