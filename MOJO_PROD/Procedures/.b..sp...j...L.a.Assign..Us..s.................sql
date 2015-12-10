USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadAssignedUsers]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadAssignedUsers]
	(
	@ProjectKey int
	)
AS

/*
|| When      Who Rel      What
|| 4/17/08   CRG 1.0.0.0  Added ClientVendorLogin
|| 6/1/10    CRG 10.5.3.0 Added DefaultServiceKey
|| 9/24/10   GHL 10.5.3.5 Added NoUnassign for delete function of users in ScheduleEdit.mxml
|| 9/30/10   GHL 10.5.3.5 Added IconID for editing on grid with a balloon
|| 12/21/10  GHL 10.5.3.9 Added subscription flags to diary todo
*/

select a.*
	,ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') AS UserName
	,SUBSTRING(ISNULL(FirstName, ''),1,1) + SUBSTRING(ISNULL(MiddleName, ''),1,1) + SUBSTRING(ISNULL(LastName, ''),1,1) AS Initials
	,u.Phone1
	,u.Email
	,u.ClientVendorLogin
	,u.DefaultServiceKey
	,isnull(u.NoUnassign, 0) as NoUnassign 
	,'edit' as IconID
	,isnull(u.SubscribeDiary, 0) as SubscribeDiary
    ,isnull(u.SubscribeToDo, 0) as SubscribeToDo
	,isnull(u.DeliverableReviewer, 0) as DeliverableReviewer
    ,isnull(u.DeliverableNotify, 0) as DeliverableNotify
 from tAssignment a (nolock) 
inner join tUser u on a.UserKey = u.UserKey
Where ProjectKey = @ProjectKey
Order By u.FirstName, u.LastName
GO
