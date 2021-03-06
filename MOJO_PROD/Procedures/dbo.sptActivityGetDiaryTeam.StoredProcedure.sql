USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetDiaryTeam]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetDiaryTeam]
	@ProjectKey int
AS

/*
|| When      Who Rel      What
|| 01/30/14	 QMD 10.5.7.6 Created for new app

*/

	-- Next get team members (Project team)
	-- Will be at the top of the email list 
	-- if you want to include any user (not an employee or company contact), put it in the team first          
	select v.UserKey,
			v.UserName,
			ISNULL(ClientVendorLogin, 0) AS ClientVendorLogin,
			v.Email
	from   vUserName v (nolock)
		inner join tAssignment a (nolock) on v.UserKey = a.UserKey 
	where a.ProjectKey = @ProjectKey and v.Active = 1
	order by v.UserName
GO
