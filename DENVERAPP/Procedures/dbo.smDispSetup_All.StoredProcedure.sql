USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smDispSetup_All]    Script Date: 12/21/2015 15:43:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smDispSetup_All]
AS
	SELECT *
	FROM smDispSetup
	WHERE DispSetupID = 'DISP-SETUP'
GO
