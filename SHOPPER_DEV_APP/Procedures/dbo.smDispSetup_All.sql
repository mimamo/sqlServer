USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smDispSetup_All]    Script Date: 12/16/2015 15:55:34 ******/
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
