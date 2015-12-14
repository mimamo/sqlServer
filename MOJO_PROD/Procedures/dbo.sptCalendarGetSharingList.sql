USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetSharingList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetSharingList]

	(
		@UserKey int,
		@CompanyKey int,
		@Type int = 1 	

	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 7/23/08   CRG 10.5.0.0 Added Entity, EntityKey, and Sort columns
*/

if @Type = 1 

	Select 
		u.UserKey,
		u.UserKey AS EntityKey,
		u.FirstName + ' ' + u.LastName as UserName,
		'Personal' AS Entity,
		1 AS Sort		
	From
		tUser u (nolock) inner join
		tCalendarUser c (nolock) on u.UserKey = c.UserKey
	Where
		c.CalendarUserKey = @UserKey
		and u.Active = 1
		and c.AccessType > 0
	Order By u.LastName

if @Type= 2 
	Select 
		cr.CalendarResourceKey * -1 as UserKey,
		cr.CalendarResourceKey * -1 as EntityKey,
		cr.ResourceName as UserName ,
		'Resources' AS Entity,
		2 AS Sort
	from 
		tCalendarResource cr (nolock)		 			
	where CompanyKey = @CompanyKey 
	ORDER BY cr.ResourceName
GO
