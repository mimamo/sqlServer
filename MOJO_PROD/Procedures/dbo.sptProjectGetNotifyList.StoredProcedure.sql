USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetNotifyList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectGetNotifyList]
  @ProjectKey int,
  @ActivityKey int,
  @CompanyKey int = NULL
AS --Encrypt

/*
|| When     Who Rel      What
|| 10/13/06 CRG 8.35     Added Originator column so that reply emails can be sent to the originator.
|| 03/19/07 GHL 8.4      Added checking of 0 or null ProjectNoteKey
||                       Bug 8562. Records with ProjectNoteKey = 0 were inserted and users showing up assigned
||                       Also placed checking code in sptProjectNoteUserInsert
|| 01/12/09 GHL 10.5     Changed tProjectNote to tActivity
|| 07/02/09 MFT 10.5.0.1 Get entire active users when in AddMode
*/

if @ActivityKey = 0 AND @ProjectKey = 0
	select us.UserKey
		,us.FirstName + ' ' + us.LastName as UserName
		,us.LastName
		,us.FirstName
		,us.Email
		,ISNULL(us.ClientVendorLogin, 0) as ClientVendorLogin
		,0 as Assigned
		,0 as Originator
	from tUser us (nolock)
	       inner join tCompany    c  (nolock) on us.CompanyKey = c.CompanyKey
	where us.CompanyKey = @CompanyKey
	    and us.Active = 1
	order by UserName
else
	select us.UserKey
		,us.FirstName + ' ' + us.LastName as UserName
		,us.LastName
		,us.FirstName
		,us.Email
		,ISNULL(us.ClientVendorLogin, 0) as ClientVendorLogin
		,ag.HourlyRate
	       ,(Select 1 from tActivityEmail (NOLOCK) 
				Where ActivityKey = @ActivityKey
				AND   UserKey = us.UserKey) as Assigned
	       ,(SELECT 1 FROM tActivity (NOLOCK) 
			WHERE ActivityKey = @ActivityKey
			AND AddedByKey = us.UserKey) as Originator
	from tUser us (nolock)
	       inner join tAssignment ag (nolock) on ag.UserKey = us.UserKey
	       inner join tCompany    c  (nolock) on us.CompanyKey = c.CompanyKey
	where ag.ProjectKey = @ProjectKey
	    and us.Active = 1    
	order by UserName

return  1
GO
