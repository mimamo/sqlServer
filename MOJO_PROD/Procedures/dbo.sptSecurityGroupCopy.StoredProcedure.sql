USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupCopy]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupCopy]
  @SecurityGroupKey int,
  @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/20/09   GWG 10.5     Added in folder security for CM
|| 7/10/09   MAS 10.5     (53166) added tWidgetSecurity settings
*/

 DECLARE @GroupName varchar(100)
		,@CompanyKey int
				
 SELECT @GroupName = 'Copy of '+GroupName
		,@CompanyKey= CompanyKey
 FROM   tSecurityGroup (NOLOCK)
 WHERE  SecurityGroupKey = @SecurityGroupKey
 

IF EXISTS (SELECT 1
           FROM   tSecurityGroup (NOLOCK)
           WHERE  UPPER(LTRIM(RTRIM(GroupName))) = UPPER(LTRIM(RTRIM(@GroupName))) 
					 AND    CompanyKey = @CompanyKey
					 AND    Active = 1)
	RETURN -1
		
 INSERT tSecurityGroup
  (
  GroupName,
  CompanyKey,
  Active
  )
 VALUES
  (
  @GroupName,
  @CompanyKey,
  1
  )	 

 SELECT @oIdentity = @@IDENTITY

 INSERT tRightAssigned (RightKey, EntityType, EntityKey)  
 SELECT RightKey  
       ,EntityType
       ,@oIdentity
 FROM   tRightAssigned
 WHERE EntityType = 'Security Group'
 AND   EntityKey = @SecurityGroupKey

 INSERT tDashboardGroup (SecurityGroupKey, DashboardKey, DisplayOrder)
 SELECT @oIdentity, DashboardKey, DisplayOrder
 FROM   tDashboardGroup (NOLOCK)
 WHERE  SecurityGroupKey = @SecurityGroupKey 

 INSERT tWidgetSecurity (SecurityGroupKey, WidgetKey, CanEdit, CanView)
 SELECT @oIdentity, WidgetKey, CanEdit, CanView
 FROM   tWidgetSecurity (NOLOCK)
 WHERE  SecurityGroupKey = @SecurityGroupKey 
	        		  
 INSERT tRptSecurityGroup (ReportKey, SecurityGroupKey)
 SELECT ReportKey, @oIdentity
 FROM   tRptSecurityGroup (NOLOCK)
 WHERE  SecurityGroupKey = @SecurityGroupKey
      	
 INSERT tDAFileRight (FileKey, Entity, EntityKey, AllowRead, AllowUpdate, AllowChange, AllowDelete)    	
 SELECT FileKey, Entity, @oIdentity, AllowRead, AllowUpdate, AllowChange, AllowDelete
 FROM   tDAFileRight (NOLOCK)
 WHERE  Entity = 'SecurityGroup'
 AND    EntityKey = @SecurityGroupKey

 INSERT tDAFolderRight (FolderKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete )
 SELECT FolderKey, Entity, @oIdentity, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete 
 FROM   tDAFolderRight (NOLOCK)
 WHERE  Entity = 'SecurityGroup'
 AND    EntityKey = @SecurityGroupKey
 
 INSERT tCMFolderSecurity (CMFolderKey, Entity, EntityKey, CanView, CanAdd )
 SELECT CMFolderKey, Entity, @oIdentity, CanView, CanAdd 
 FROM   tCMFolderSecurity (NOLOCK)
 WHERE  Entity = 'tSecurityGroup'
 AND    EntityKey = @SecurityGroupKey
 	        	
 RETURN 1
GO
