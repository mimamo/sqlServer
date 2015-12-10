USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleGetAllDetails]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleGetAllDetails]
	@CompanyKey int

AS --Encrypt

/*
  || When       Who Rel      What
  || 09/23/2014 WDF 10.5.8.4 New
*/

	SELECT	tTitle.*
	       ,d.DepartmentName
	       ,wt.WorkTypeID, wt.WorkTypeName
	       ,gla.AccountNumber AS SalesAccountNumber, gla.AccountName AS SalesAccountName
	FROM tTitle (NOLOCK) left outer Join tDepartment d (nolock) on tTitle.DepartmentKey = d.DepartmentKey
						 left outer join tWorkType wt on tTitle.WorkTypeKey =  wt.WorkTypeKey 
						 left outer join tGLAccount gla on tTitle.GLAccountKey = gla.GLAccountKey
	WHERE tTitle.CompanyKey = @CompanyKey
	Order By tTitle.TitleID, tTitle.TitleName

		
-- services
	Select t.TitleKey, 
	       s.*,
		   ISNULL(s.ServiceCode, '') + ' - ' + ISNULL(s.Description, '') as FullDescription  
	From tTitle t (nolock)
	Inner join tTitleService ts (nolock) on t.TitleKey = ts.TitleKey
	Inner Join tService s (nolock) on  s.ServiceKey = ts.ServiceKey
	Where t.CompanyKey = @CompanyKey
	Order By s.Description
GO
