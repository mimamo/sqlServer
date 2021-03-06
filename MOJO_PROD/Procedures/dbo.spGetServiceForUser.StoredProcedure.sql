USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetServiceForUser]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetServiceForUser]
	@UserKey int,
	@ServiceKey int = NULL
 
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 1/22/15   GHL 10.588  Made correction to show service when = @ServiceKey
*/

	SELECT	s.ServiceKey,
			CompanyKey,
			ServiceCode,
			Description,
			ISNULL(Description1, Description) as Description1,
			ISNULL(Description2, Description) as Description2,
			ISNULL(Description3, Description) as Description3,
			ISNULL(Description4, Description) as Description4,
			ISNULL(Description5, Description) as Description5
	FROM	tService s (nolock) 
	WHERE
		(	
		s.ServiceKey in (
		select  us.ServiceKey
		from    tUserService us (nolock)
		where   us.UserKey = @UserKey
			)
		and	 s.Active = 1
		) 
	OR s.ServiceKey = @ServiceKey
	Order By Description
 
 RETURN 1
GO
