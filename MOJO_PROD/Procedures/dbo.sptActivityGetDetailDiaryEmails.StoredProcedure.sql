USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetDetailDiaryEmails]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetDetailDiaryEmails]
	(
		@ActivityKey int
	)

AS

/*
|| When      Who Rel      What
|| 11/12/14  GAR 10.5.8.6 Added new SP to just get email names for the diary without getting all of the other tables to speed it up.
*/

-- Email List
Select RTRIM(LTRIM(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
	from tActivityEmail ae (nolock)
	inner join tUser u (nolock) on ae.UserKey = u.UserKey
	Where ActivityKey = @ActivityKey
union
select rtrim(ltrim(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
	from tActivityEmail ae (nolock)
	inner join tUserLead u (nolock) on ae.UserLeadKey = u.UserLeadKey
	where ActivityKey = @ActivityKey
GO
