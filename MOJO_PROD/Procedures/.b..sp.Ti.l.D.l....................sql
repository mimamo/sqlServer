USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleDelete]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleDelete]
	@TitleKey int,
	@CompanyKey int

AS --Encrypt

/*
|| When       Who Rel      What
|| 09/12/14   WDF 10.5.8.4 New
|| 10/10/14   GHL 10.5.8.5 Fixed 100 
*/

	if exists(select 1 from tUser (nolock) where CompanyKey = @CompanyKey and TitleKey = @TitleKey)
		return -1

	if exists(select 1 
	            from tProjectEstByTitle pet (nolock) INNER JOIN tProject p (nolock) ON (p.ProjectKey = pet.ProjectKey)
	           where p.CompanyKey = @CompanyKey 
	             and pet.TitleKey = @TitleKey)
		return -2
		
	if exists(select 1
               from tTime t (nolock) INNER JOIN tTimeSheet ts (nolock) ON (ts.TimeSheetKey = t.TimeSheetKey)
              where ts.CompanyKey = @CompanyKey -- Not 100
                and t.TitleKey = @TitleKey)
		return -3
		

    DELETE
      FROM tTitleRateSheetDetail
     WHERE TitleKey = @TitleKey
 
     DELETE
      FROM tTitleService
     WHERE TitleKey = @TitleKey

     DELETE
      FROM tTitle
     WHERE CompanyKey = @CompanyKey
       AND TitleKey = @TitleKey

	RETURN 1
GO
