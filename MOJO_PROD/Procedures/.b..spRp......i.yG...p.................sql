USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSecurityGroup]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptSecurityGroup]
	(
		@SecurityGroupKey int,
		@CompanyKey int		
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 07/12/13  RLB 10.5.7.0 (181873) created for report
*/

	select sg.GroupName,
		   sg.ChangeLayout,
		   sg.ChangeDesktop,
		   sg.ChangeWindow,
		   sg.SecurityLevel,
		   r.RightKey,
		   r.RightID,
		   r.Description,
		   r.RightGroup,
		   CASE r.RightGroup
			   WHEN 'acct' THEN 'Accounting'
			   WHEN 'admin' THEN 'System Administration'
			   WHEN 'billing' THEN 'Billing'
			   WHEN 'calendar' THEN 'Calendar'
			   WHEN 'client' THEN 'Client Vendor Login Options'
			   WHEN 'cm' THEN 'Contact Management'
			   WHEN 'dashboard' THEN 'Dashboard'
			   WHEN 'desktop' THEN 'Edit Company Settings For Desktop'
			   WHEN 'file' THEN 'Digital Assets'
			   WHEN 'form' THEN 'Tracking Forms'
			   WHEN 'legacy' THEN 'Legacy Item Rights'
			   WHEN 'media' THEN 'Media'
			   WHEN 'project' THEN 'Project Administration'
			   WHEN 'purch' THEN 'Purchasing'
			   WHEN 'reports' THEN 'Reports'
			   WHEN 'requests' THEN 'Project Requests'
			   WHEN 'time' THEN 'Time and Expenses'
			   WHEN 'traffic' THEN 'Traffic'
			END as RightGroupName,
		   r.DisplayOrder,
		   'Yes' as HasRight	   
	from tSecurityGroup sg (nolock)
	inner join tRightAssigned ra (nolock) On sg.SecurityGroupKey = ra.EntityKey and ra.EntityType = 'Security Group'
	inner join tRight r (nolock) on ra.RightKey = r.RightKey
	where sg.CompanyKey = @CompanyKey and sg.SecurityGroupKey = @SecurityGroupKey

	Union ALL

	select '' as GroupName,
		   0 as ChangeLayout,
		   0 as ChangeDesktop,
		   0 as ChangeWindow,
		   0 as SecurityLevel,
		   r.RightKey,
		   r.RightID,
		   r.Description,
		   r.RightGroup,
			  CASE r.RightGroup
			   WHEN 'acct' THEN 'Accounting'
			   WHEN 'admin' THEN 'System Administration'
			   WHEN 'billing' THEN 'Billing'
			   WHEN 'calendar' THEN 'Calendar'
			   WHEN 'client' THEN 'Client Vendor Login Options'
			   WHEN 'cm' THEN 'Contact Management'
			   WHEN 'dashboard' THEN 'Dashboard'
			   WHEN 'desktop' THEN 'Edit Company Settings For Desktop'
			   WHEN 'file' THEN 'Digital Assets'
			   WHEN 'form' THEN 'Tracking Forms'
			   WHEN 'legacy' THEN 'Legacy Item Rights'
			   WHEN 'media' THEN 'Media'
			   WHEN 'project' THEN 'Project Administration'
			   WHEN 'purch' THEN 'Purchasing'
			   WHEN 'reports' THEN 'Reports'
			   WHEN 'requests' THEN 'Project Requests'
			   WHEN 'time' THEN 'Time and Expenses'
			   WHEN 'traffic' THEN 'Traffic'
			END as RightGroupName,
		   r.DisplayOrder,
		   'No' as HasRight	   
	from tRight r (nolock)
	where RightKey NOT IN(
		select ra.RightKey from tSecurityGroup sg (nolock) 
		inner join tRightAssigned ra (nolock) On sg.SecurityGroupKey = ra.EntityKey and ra.EntityType = 'Security Group'
		where sg.CompanyKey = @CompanyKey and sg.SecurityGroupKey = @SecurityGroupKey
	)

	Order By RightGroup, DisplayOrder
GO
