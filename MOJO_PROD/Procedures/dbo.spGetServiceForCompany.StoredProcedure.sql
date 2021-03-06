USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetServiceForCompany]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetServiceForCompany]
	@CompanyKey int,
	@ServiceKey int = NULL
AS --Encrypt

/*
|| When      Who Rel      What
|| 5/16/07   CRG 8.4.3    (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 9/25/08   RTC 10.0.0.9 (35212) Added Assigned flag used by Timesheet Edit 
*/

	SELECT	ServiceKey,
			CompanyKey,
			ServiceCode,
			Description,
			ISNULL(Description1, Description) as Description1,
			ISNULL(Description2, Description) as Description2,
			ISNULL(Description3, Description) as Description3,
			ISNULL(Description4, Description) as Description4,
			ISNULL(Description5, Description) as Description5,
			ISNULL(ServiceCode, '') + ' - ' + ISNULL(Description, '') as FullDescription  ,
			1 as Assigned
	FROM	tService (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		(Active = 1 OR ServiceKey = @ServiceKey)
	Order By Description
	 
 RETURN 1
GO
