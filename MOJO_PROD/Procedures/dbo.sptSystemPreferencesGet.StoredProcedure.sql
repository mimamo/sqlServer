USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSystemPreferencesGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSystemPreferencesGet]	
AS --Encrypt

/*
	=========	======	=========	======================
	When		Who		Rel			What
	=========	======	=========	======================
	07/02/13	QMD		10.5.7.0	Created for weatherbug	
	
*/
	SELECT * FROM tSystemPreferences
GO
