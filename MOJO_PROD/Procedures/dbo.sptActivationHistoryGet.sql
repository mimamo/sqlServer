USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivationHistoryGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptActivationHistoryGet]
	 @CompanyKey int
	
	
AS --Encrypt
	
/*
|| When     Who Rel       What
|| 04/27/11 RLB 10.5.4.3  Created for new Flex Activation History
|| 07/15/11 RLB 10.5.4.6 (116452) changed order by 
*/


	SELECT *
	FROM tUser
	WHERE (CompanyKey = @CompanyKey or OwnerCompanyKey = @CompanyKey) and Active = 1 and ClientVendorLogin = 0 and LEN(UserID) > 0
	ORDER BY LastName, FirstName
	
	SELECT u.FirstName,
			 u.LastName, 
			 u.UserID,
			 u.UserKey, 
			 a.DateActivated,
			 a.DateDeactivated,
			 ISNULL(u1.FirstName, '') + ' ' + ISNULL(u1.LastName, '') AS ActivatedByUserName,
			  ISNULL(u2.FirstName, '') + ' ' + ISNULL(u2.LastName, '') AS DeactivatedByUserName
	FROM tUser u (nolock)
	inner join tActivationLog a (nolock) on u.UserKey = a.UserKey
	left outer join tUser u1 (nolock) on a.ActivatedByKey = u1.UserKey
	left outer join tUser u2 (nolock) on a.DeactivatedByKey = u2.UserKey
	WHERE (u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey)
	ORDER BY a.DateDeactivated DESC, u.LastName
	
	
	RETURN 1
GO
