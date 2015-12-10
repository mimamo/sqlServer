USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSessionGetCompanyStyle]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSessionGetCompanyStyle]
AS --Encrypt

/* This SP is specifically used by the TaskManager to get the Company Style data for only active companies*/

	SELECT	s.EntityKey, s.Data
	FROM	tSession s (NOLOCK)
	INNER JOIN tCompany c (NOLOCK) ON s.EntityKey = c.CompanyKey
	WHERE	s.Entity = 'style'
	AND		c.Locked = 0
GO
