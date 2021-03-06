USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadGet]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadGet]
	(
	@UserLeadKey int
	,@AllDetails int = 1
	)
AS 

  /*
  || When     Who Rel       What
  || 07/28/08 QMD 10.5.0.0  Initial Release
  || 05/22/09 GHL 10.5      Added AllDetails to get basic info 
  || 07/24/12 GHL 10.558    Added GLCompany info
  */
  
	SET NOCOUNT ON

	--Lead Data
	SELECT	ul.*, 			
			u3.UserFullName AS CreatedBy,
			u4.UserFullName AS UpdatedBy,
			glc.GLCompanyID,
			glc.GLCompanyName
	FROM	tUserLead ul (NOLOCK) 
				LEFT OUTER JOIN vUserName u3 (NOLOCK) ON ul.AddedByKey = u3.UserKey
				LEFT OUTER JOIN vUserName u4 (NOLOCK) ON ul.UpdatedByKey = u4.UserKey
				LEFT OUTER JOIN tGLCompany glc (nolock) on ul.GLCompanyKey = glc.GLCompanyKey 	
	WHERE	ul.UserLeadKey = @UserLeadKey 

	-- no need to stress the database if all details are not required
	IF @AllDetails = 0
		RETURN 1
		
	--Addresses
	SELECT	* 
	FROM	tAddress (NOLOCK)
	WHERE	Entity = 'tUserLead'
			AND EntityKey = @UserLeadKey
	ORDER BY AddressName
	
	--Marketing Lists
	SELECT * FROM tMarketingListList (NOLOCK) WHERE Entity = 'tUserLead' and EntityKey = @UserLeadKey
	
	-- last activity
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tUserLead cont (nolock) on cont.LastActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		cont.UserLeadKey = @UserLeadKey

	-- next activity
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tUserLead cont (nolock) on cont.NextActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		cont.UserLeadKey = @UserLeadKey

	RETURN 1
GO
