USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleServiceExport]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTitleServiceExport]
	@CompanyKey int

AS --Encrypt

/*
  || When       Who Rel      What
  || 02/09/2015 WDF 10.5.8.4 New
*/

	Select t.TitleID, t.TitleName
	      ,s.ServiceKey, s.ServiceCode, s.Description
	From tTitle t (nolock)
	Inner join tTitleService ts (nolock) on t.TitleKey = ts.TitleKey
	Inner Join tService s (nolock) on  s.ServiceKey = ts.ServiceKey
	Where t.CompanyKey = @CompanyKey
	Order By t.TitleID, s.ServiceCode
GO
