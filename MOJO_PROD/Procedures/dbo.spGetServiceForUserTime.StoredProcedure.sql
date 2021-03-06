USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetServiceForUserTime]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetServiceForUserTime]
	
	 @CompanyKey int
	,@UserKey int
 
AS --Encrypt

/*
|| When      Who Rel        What
|| 9/25/08   RTC 10.0.0.9   (35212) Created.
*/

select ServiceKey
	  ,CompanyKey
	  ,ServiceCode
	  ,Description
	  ,isnull(Description1, Description) as Description1
	  ,isnull(Description2, Description) as Description2
	  ,isnull(Description3, Description) as Description3
	  ,isnull(Description4, Description) as Description4
	  ,isnull(Description5, Description) as Description5
	  ,isnull((select 1 from tUserService (nolock) where ServiceKey = tService.ServiceKey and UserKey = @UserKey), 0) as Assigned
from tService (nolock) 
where CompanyKey = @CompanyKey
and Active = 1
order by Description

 
 RETURN 1
GO
