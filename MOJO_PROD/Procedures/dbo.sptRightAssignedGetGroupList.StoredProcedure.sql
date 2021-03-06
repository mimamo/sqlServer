USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightAssignedGetGroupList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptRightAssignedGetGroupList]
 (
  @EntityType varchar(35),
  @EntityKey  int,
  @SetGroup varchar(50)
 )
AS --Encrypt

SELECT 
	 r.*
    ,CASE WHEN ra.EntityKey IS NULL THEN 0 ELSE 1 END AS Allowed
	,Case r.RightGroup
		When 'admin' then 'System Administration'
		When 'project' then 'Project Administration'
		When 'cm' then 'Contact Management'
		When 'time' then 'Time and Expenses'
		When 'acct' then 'Accounting'
		When 'billing' then 'Billing'
		When 'purch' then 'Purchasing'
		When 'media' then 'Media'
		When 'traffic' then 'Traffic'
		When 'calendar' then 'Calendar'
		When 'form' then 'Tracking Forms'
		When 'forum' then 'Discussion Forums'
		When 'file' then 'Digital Assets'
		When 'approval' then 'Project Approvals'
		When 'dashboard' then 'Dashboard'
		When 'reports' then 'Reports'
		When 'client' then 'Client / Vendor Login Options'
		When 'requests' then 'Project Requests'
	end as GroupHeading
	,Case r.RightGroup
		When 'admin' then 1
		When 'project' then 2
		When 'requests' then 3
		When 'cm' then 4
		When 'time' then 5
		When 'acct' then 6
		When 'billing' then 7
		When 'purch' then 8
		when 'media' then 9
		When 'traffic' then 10
		When 'calendar' then 11
		When 'form' then 12
		When 'forum' then 13
		When 'file' then 14
		When 'approval' then 15
		When 'dashboard' then 16
		When 'reports' then 17
		When 'client' then 18
	end as GroupOrder
 FROM    
	tRight r (NOLOCK) 
	left outer join 
	(Select * from tRightAssigned (NOLOCK) Where EntityType = @EntityType and EntityKey = @EntityKey) as ra
	on r.RightKey = ra.RightKey
Where
	UPPER(r.SetGroup) = UPPER(@SetGroup)
 ORDER BY GroupOrder, r.DisplayOrder
 
 /* set nocount on */
 return 1
GO
