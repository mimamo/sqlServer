USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupDelete]
  @UserKey int
 ,@SecurityGroupKey int
 ,@SetActive tinyint
AS --Encrypt

  /*
  || When     Who Rel		What
  || 04/22/07 GWG 8.42		Changed the check to only look at active, nulls any inactive
  || 02/18/09 MAS 10.0.1.9	Changed the EntityKey in the tDAFolderRight and tDAFileRight to use SecurityGroup
  || 07/10/09 MAS 10.5  	(53166) added tWidgetSecurity settings
  || 11/11/09 GHL 10.513    (67967) Setting now tUser.SecurityGroupKey to null
  ||                         before deleting tSecurityGroup record to avoid FK violation
  || 07/10/09 MAS 10.5.1.8 	 Added delete for tCMFolderSecurity settings
  || 08/22/12 KMC 10.5.5.9	 (148856) Added delete of tSecurityAccess records
  || 03/25/14 WDF 10.5.7.8	(202059) Added Logging for Security changes

  */
DECLARE @UserName varchar(201)
DECLARE @CompanyKey int
DECLARE @CurDate smalldatetime
DECLARE @Comments varchar(4000)
	
SET @CurDate = GETUTCDATE()
SELECT @UserName = FirstName + ' ' + LastName, @CompanyKey = CompanyKey from tUser where UserKey = @UserKey

	IF EXISTS (SELECT 1 
	           FROM   tUser (NOLOCK)
	           WHERE  SecurityGroupKey = @SecurityGroupKey and Active = 1)
		RETURN -1

-- Insert to Log
SET @Comments = 'Group ''' + (SELECT GroupName FROM tSecurityGroup WHERE SecurityGroupKey = @SecurityGroupKey) + ''' was Removed'
exec sptActionLogInsert 'Security', @SecurityGroupKey, @CompanyKey, 0, 'Security Group Removed', @CurDate, @UserName, @Comments, '', null, @UserKey

-- Begin Deletes
DELETE
FROM tRightAssigned
WHERE
	EntityType = 'Security Group' and
	EntityKey = @SecurityGroupKey 

DELETE
FROM tDashboardGroup
WHERE
	SecurityGroupKey = @SecurityGroupKey 

DELETE
FROM tWidgetSecurity
WHERE
	SecurityGroupKey = @SecurityGroupKey 
	
Delete
From tRptSecurityGroup
Where
	SecurityGroupKey = @SecurityGroupKey

Delete 
FROM   tDAFolderRight
WHERE  
	tDAFolderRight.Entity = 'SecurityGroup' AND
	tDAFolderRight.EntityKey = @SecurityGroupKey

Delete
FROM	  tDAFileRight
WHERE  
	tDAFileRight.Entity = 'SecurityGroup' AND
	tDAFileRight.EntityKey = @SecurityGroupKey
	
Update tUser Set SecurityGroupKey = NULL 
Where SecurityGroupKey = @SecurityGroupKey

DELETE
FROM tSecurityGroup
WHERE
	SecurityGroupKey = @SecurityGroupKey 

DELETE
FROM tCMFolderSecurity
WHERE
	tCMFolderSecurity.Entity = 'tSecurityGroup' AND 
	tCMFolderSecurity.EntityKey = @SecurityGroupKey 

DELETE
FROM tSecurityAccess
WHERE
	SecurityGroupKey = @SecurityGroupKey


 RETURN 1
GO
