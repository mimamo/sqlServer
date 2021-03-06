USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityEmailGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityEmailGetList]
	@ActivityKey int
AS

/*
|| When      Who Rel      What
|| 3/17/10   CRG 10.5.2.0 Created for use by CalDAV
|| 01/13/11  MFT 10.5.4.0 Added ClientVendorLogin
|| 01/26/11  MFT 10.5.4.0 Added TimeZoneIndex
|| 03/09/14 GWG 10.5.7.8 Added sorts by name
*/

	SELECT	u.UserKey, 0 AS UserLeadKey, u.UserName, u.Email, u.ClientVendorLogin, TimeZoneIndex
	FROM	tActivityEmail ae (nolock)
	INNER JOIN vUserName u (nolock) ON ae.UserKey = u.UserKey
	WHERE	ActivityKey = @ActivityKey
	
	UNION
	
	SELECT	0, u.UserLeadKey, RTRIM(LTRIM(ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, ''))), u.Email, 0, TimeZoneIndex
	FROM	tActivityEmail ae (nolock)
	INNER JOIN tUserLead u (nolock) ON ae.UserLeadKey = u.UserLeadKey
	WHERE	ActivityKey = @ActivityKey
	Order By u.UserName
GO
