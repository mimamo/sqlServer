USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupUpdate]
 @SecurityGroupKey int,
 @GroupName varchar(100),
 @UserKey int,
 @CompanyKey int,
 @Active tinyint,
 @ChangeLayout tinyint = null,
 @ChangeDesktop tinyint = null,
 @ChangeWindow tinyint = null,
 @CopySecurityGroupKey int = null,
 @SecurityLevel smallint = 1
AS --Encrypt

  /*
  || When     Who	Rel				What
  || 04/04/08 QMD	WMJ 1.0			Modified for initial Release of WMJ
  || 01/29/10 MAS	WMJ 10.5.1.8	Added insert logic as well as copy from logic
  || 11/08/11 GHL   WMJ 10.5.5.0    (114741) Added @SecurityLevel parameter
  || 05/15/12 GWG   WMJ 10.5.5.6	Added auto insert of security group to project request definitions
  || 08/22/12 KMC   WMJ 10.5.5.9    (148856) Removed automatic insert into tSecurityAccess for project requests
  ||                                and tracking forms.  Both are now their own section in the security group
  ||                                screens.
  || 03/25/14 WDF   WMJ 10.5.7.8	(202059) Added Logging for Security changes
  || 05/21/14 GHL   WMJ 10.5.8.0    Added NOLOCK when querying tUser
*/

DECLARE @chgLayout tinyint
DECLARE @chgDesktop tinyint
DECLARE @chgWindow tinyint
DECLARE @UserName varchar(201)
DECLARE @CurDate smalldatetime
DECLARE @Comments varchar(4000)
DECLARE @oldName varchar(100)
DECLARE @oldLayout tinyint
DECLARE @oldDesktop tinyint
DECLARE @oldWindow tinyint
DECLARE @oldLevel smallint

if @Active IS NULL
	SELECT @Active = 1
		
 IF @Active = 1
 BEGIN
	IF EXISTS (SELECT 1
	           FROM   tSecurityGroup (NOLOCK) 
	           WHERE  UPPER(LTRIM(RTRIM(GroupName))) = UPPER(LTRIM(RTRIM(@GroupName))) 
						 AND    CompanyKey = @CompanyKey
						 AND    Active = 1
						 AND    SecurityGroupKey <> @SecurityGroupKey)
		RETURN -1
		
 END 

SET @CurDate = GETUTCDATE()
SELECT @UserName = FirstName + ' ' + LastName from tUser (NOLOCK) where UserKey = @UserKey

IF @SecurityGroupKey < 1
	BEGIN
		INSERT tSecurityGroup(
			GroupName,
			CompanyKey,
			Active,
			ChangeLayout,
			ChangeDesktop,
			ChangeWindow,
			SecurityLevel
		)
		VALUES(
			@GroupName,
			@CompanyKey,
			@Active, 
			1,
			1,
			1,
			@SecurityLevel
		)
		 
		 SELECT @SecurityGroupKey = @@IDENTITY		 
		 
		 IF ISNULL(@CopySecurityGroupKey, 0) > 0
			 BEGIN
			 
				-- Log Insert of Group and Options
				SET @Comments = 'Group ''' + @GroupName + ''' was Added'
				exec sptActionLogInsert 'Security', @SecurityGroupKey, @CompanyKey, 0, 'Security Group Added', @CurDate, @UserName, @Comments, '', null, @UserKey

				SET @Comments = 'Desktop Layout Option for Group ''' + @GroupName + ''' was Enabled'
				exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Security Option Added', @CurDate, @UserName, @Comments, @SecurityGroupKey, null, @UserKey

				SET @Comments = 'Desktop Colors for Group ''' + @GroupName + ''' was Enabled'
				exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Security Option Added', @CurDate, @UserName, @Comments, @SecurityGroupKey, null, @UserKey

				SET @Comments = 'Window Colors for Group ''' + @GroupName + ''' was Enabled'
				exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Security Option Added', @CurDate, @UserName, @Comments, @SecurityGroupKey, null, @UserKey

				SET @Comments = 'Security Level for Group ''' + @GroupName + ''' is ' + CAST(@SecurityLevel as CHAR(1))
				exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Security Option Added', @CurDate, @UserName, @Comments, @SecurityGroupKey, null, @UserKey
				

				-- taken from sptSecurityGroupCopy
				 INSERT tDashboardGroup (SecurityGroupKey, DashboardKey, DisplayOrder)
				 SELECT @SecurityGroupKey, DashboardKey, DisplayOrder
				 FROM   tDashboardGroup (NOLOCK)
				 WHERE  SecurityGroupKey = @CopySecurityGroupKey 

				 INSERT tWidgetSecurity (SecurityGroupKey, WidgetKey, CanEdit, CanView)
				 SELECT @SecurityGroupKey, WidgetKey, CanEdit, CanView
				 FROM   tWidgetSecurity (NOLOCK)
				 WHERE  SecurityGroupKey = @CopySecurityGroupKey 
					        		  
				 INSERT tRptSecurityGroup (ReportKey, SecurityGroupKey)
				 SELECT ReportKey, @SecurityGroupKey
				 FROM   tRptSecurityGroup (NOLOCK)
				 WHERE  SecurityGroupKey = @CopySecurityGroupKey
				      	
				 INSERT tDAFileRight (FileKey, Entity, EntityKey, AllowRead, AllowUpdate, AllowChange, AllowDelete)    	
				 SELECT FileKey, Entity, @SecurityGroupKey, AllowRead, AllowUpdate, AllowChange, AllowDelete
				 FROM   tDAFileRight (NOLOCK)
				 WHERE  Entity = 'SecurityGroup'
				 AND    EntityKey = @CopySecurityGroupKey

				 INSERT tDAFolderRight (FolderKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete )
				 SELECT FolderKey, Entity, @SecurityGroupKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete 
				 FROM   tDAFolderRight (NOLOCK)
				 WHERE  Entity = 'SecurityGroup'
				 AND    EntityKey = @CopySecurityGroupKey
				 
				 INSERT tCMFolderSecurity (CMFolderKey, Entity, EntityKey, CanView, CanAdd )
				 SELECT CMFolderKey, Entity, @SecurityGroupKey, CanView, CanAdd 
				 FROM   tCMFolderSecurity (NOLOCK)
				 WHERE  Entity = 'tSecurityGroup'
				 AND    EntityKey = @CopySecurityGroupKey
			 END
	END
ELSE 
	BEGIN 
	
		-- Get settings ready for update	
		SELECT @chgLayout = ISNULL(@ChangeLayout, ChangeLayout), @chgDesktop = ISNULL(@ChangeDesktop, ChangeDesktop),
				@chgWindow = ISNULL(@ChangeWindow, ChangeWindow)
		FROM tSecurityGroup (NOLOCK) 
		WHERE SecurityGroupKey = @SecurityGroupKey
		
		
		-- Get current settings prior to update
		SELECT @oldName = GroupName, @oldLayout = ISNULL(ChangeLayout, 0), @oldDesktop = ISNULL(ChangeDesktop, 0)
			  ,@oldWindow = ISNULL(ChangeWindow, 0), @oldLevel = SecurityLevel
		FROM tSecurityGroup (NOLOCK) 
		WHERE SecurityGroupKey = @SecurityGroupKey

		-- Log Update of Group and Options
		IF @oldName <> @GroupName
		BEGIN
			SET @Comments = 'Group ''' + @oldName + ''' was changed to ''' + @GroupName + ''''
			exec sptActionLogInsert 'Security', @SecurityGroupKey, @CompanyKey, 0, 'Security Group Changed', @CurDate, @UserName, @Comments, '', null, @UserKey
		END

		IF @oldLayout <> ISNULL(@chgLayout, 0)
		BEGIN
			SET @Comments = 'Desktop Layout Option for Group ''' + @GroupName + ''' went from ' + CASE @oldLayout WHEN 0 THEN 'disabled' ELSE 'enabled' END + ' to ' + CASE ISNULL(@chgLayout, 0) WHEN 0 THEN 'disabled' ELSE 'enabled' END
			exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Security Option Changed', @CurDate, @UserName, @Comments, @SecurityGroupKey, null, @UserKey
		END

		IF @oldDesktop <> ISNULL(@chgDesktop, 0)
		BEGIN
			SET @Comments = 'Desktop Colors for Group ''' + @GroupName + ''' went from ' + CASE @oldDesktop WHEN 0 THEN 'disabled' ELSE 'enabled' END + ' to ' + CASE ISNULL(@chgDesktop, 0) WHEN 0 THEN 'disabled' ELSE 'enabled' END
			exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Security Option Changed', @CurDate, @UserName, @Comments, @SecurityGroupKey, null, @UserKey
		END

		IF @oldWindow <> ISNULL(@ChangeWindow, 0)
		BEGIN
			SET @Comments = 'Window Colors for Group ''' + @GroupName + ''' went from ' + CASE @oldWindow WHEN 0 THEN 'disabled' ELSE 'enabled' END + ' to ' + CASE ISNULL(@ChangeWindow, 0) WHEN 0 THEN 'disabled' ELSE 'enabled' END
			exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Security Option Changed', @CurDate, @UserName, @Comments, @SecurityGroupKey, null, @UserKey
		END

		IF @oldLevel <> @SecurityLevel
		BEGIN
			SET @Comments = 'Security Level for Group ''' + @GroupName + ''' went from ' + CAST(@oldLevel AS VARCHAR(1)) + ' to ' + CAST(@SecurityLevel AS VARCHAR(1))
			exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Security Option Changed', @CurDate, @UserName, @Comments, @SecurityGroupKey, null, @UserKey
		END

		-- Update tSecurityGroup
		 UPDATE
		  tSecurityGroup
		 SET
		  GroupName = @GroupName,
		  CompanyKey = @CompanyKey,
		  Active = @Active,
		  ChangeLayout = @chgLayout,
		  ChangeDesktop = @chgDesktop,
		  ChangeWindow = @chgWindow,
		  SecurityLevel = @SecurityLevel
		 WHERE
		  SecurityGroupKey = @SecurityGroupKey 		 
	END

RETURN @SecurityGroupKey
GO
