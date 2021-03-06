USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetSubscribedUsers]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetSubscribedUsers]
	(
	@ProjectKey int,
	@SubscribeDiary int = null


	)
AS

/*
|| When      Who Rel      What
|| 12/16/13  RLB 10.5.7.5 (199866) Created for TM to send notifications when activies are added to project from projectnumber
|| 01/07/15  RLB 10.5.8.7 (241551) Only pull active uses
*/

select a.*
	,ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') AS UserName
	,SUBSTRING(ISNULL(FirstName, ''),1,1) + SUBSTRING(ISNULL(MiddleName, ''),1,1) + SUBSTRING(ISNULL(LastName, ''),1,1) AS Initials
	,u.Phone1
	,u.Email
	,u.ClientVendorLogin
	,u.DefaultServiceKey
	,u.TimeZoneIndex
 from tAssignment a (nolock) 
inner join tUser u on a.UserKey = u.UserKey
Where ProjectKey = @ProjectKey
and u.Active = 1
and  (ISNULL(@SubscribeDiary, -1) = -1 or a.SubscribeDiary = @SubscribeDiary)

Order By u.FirstName, u.LastName
GO
