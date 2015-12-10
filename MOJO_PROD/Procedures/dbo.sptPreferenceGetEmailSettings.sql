USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceGetEmailSettings]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceGetEmailSettings]
AS --Encrypt

	SELECT	p.CompanyKey, SystemEmail, ForceSystemAsFrom
	FROM	tPreference p (NOLOCK)
	INNER JOIN tCompany c (NOLOCK) ON p.CompanyKey = c.CompanyKey
GO
