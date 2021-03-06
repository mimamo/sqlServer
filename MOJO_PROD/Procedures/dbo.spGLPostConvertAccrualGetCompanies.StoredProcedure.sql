USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertAccrualGetCompanies]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertAccrualGetCompanies]
AS --Encrypt
	SET NOCOUNT ON
	
	SELECT c.CompanyKey, c.CompanyName
		   ,case when UPPER(pref.Customizations) like '%TRACKCASH%' Then 1 Else 0 End As TrackCash
		   ,(select COUNT(*) from tCashConvert conv (NOLOCK) where conv.CompanyKey = c.CompanyKey)
		   as CashConverted
		       
	FROM   tCompany c (NOLOCK)
	INNER JOIN tPreference pref (NOLOCK) ON c.CompanyKey = pref.CompanyKey
	WHERE c.Locked = 0
	AND   c.Active = 1
	Order By c.CompanyName
	
	RETURN 1
GO
