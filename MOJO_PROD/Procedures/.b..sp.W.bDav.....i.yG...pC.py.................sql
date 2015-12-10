USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityGroupCopy]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityGroupCopy]
	 @CompanyKey int
	,@UserKey int
	,@CopySecurityGroupKey int
	,@NewSecurityGroupKey int

AS

/*
|| When       Who Rel       What
|| 03/02/15   WDF 10.5.9.0  Created - (240165) Generate WebDav Group rights when a new Security Group is created via a Copy
*/

	DECLARE	@WebDavSecurityKey int, @NewWebDavSecurityKey int
	DECLARE	@GroupName varchar(100), @CopyGroupName varchar(100)
	DECLARE @UserName varchar(201), @CurDate smalldatetime, @Comments varchar(4000)

	SET @CurDate = GETUTCDATE()
	SELECT @UserName = FirstName + ' ' + LastName FROM tUser (NOLOCK) WHERE UserKey = @UserKey

	IF NOT EXISTS(SELECT GroupName FROM tSecurityGroup (nolock) WHERE CompanyKey = @CompanyKey AND SecurityGroupKey = @NewSecurityGroupKey)
		Return -1

	SELECT @GroupName = GroupName FROM tSecurityGroup (nolock) WHERE CompanyKey = @CompanyKey AND SecurityGroupKey = @NewSecurityGroupKey
	SELECT @CopyGroupName = GroupName FROM tSecurityGroup (nolock) WHERE CompanyKey = @CompanyKey AND SecurityGroupKey = @CopySecurityGroupKey
	
	SELECT	@WebDavSecurityKey = ISNULL(MIN(WebDavSecurityKey), 0)
	  FROM	tWebDavSecurity 
	 WHERE	CompanyKey = @CompanyKey
	   AND  Entity = 'tSecurityGroup'
	   AND  EntityKey = @NewSecurityGroupKey

	IF @WebDavSecurityKey = 0
	BEGIN
	
		SELECT @WebDavSecurityKey = -1
	 
		WHILE (1=1)
		BEGIN
			SELECT @WebDavSecurityKey = MIN(WebDavSecurityKey)
			  FROM tWebDavSecurity (nolock)
			 WHERE CompanyKey = @CompanyKey
			   AND Entity = 'tSecurityGroup'
			   AND EntityKey = @CopySecurityGroupKey
			   AND WebDavSecurityKey > @WebDavSecurityKey

			IF @WebDavSecurityKey IS NULL
				BREAK
			
			INSERT	tWebDavSecurity
					(CompanyKey
					,ProjectKey
					,Entity
					,EntityKey
					,Path
					,AddFolder
					,DeleteFolder
					,RenameMoveFolder
					,ViewFolder
					,ModifyFolderSecurity
					,AddFile
					,UpdateFile
					,DeleteFile
					,RenameMoveFile)
			SELECT CompanyKey
				  ,ProjectKey
				  ,Entity
				  ,@NewSecurityGroupKey
				  ,Path
				  ,AddFolder
				  ,DeleteFolder
				  ,RenameMoveFolder
				  ,ViewFolder
				  ,ModifyFolderSecurity
				  ,AddFile
				  ,UpdateFile
				  ,DeleteFile
				  ,RenameMoveFile 
			  FROM tWebDavSecurity (nolock)
			 WHERE CompanyKey = @CompanyKey
			   AND Entity = 'tSecurityGroup' 
			   AND EntityKey = @CopySecurityGroupKey
			   AND WebDavSecurityKey = @WebDavSecurityKey
		   			   
		   	SELECT	@NewWebDavSecurityKey = @@IDENTITY
		   	
			SET @Comments = 'Security Group ''' + @GroupName + ''' was added using ''' + @CopyGroupName + ''' with key ''' +  LTRIM(STR(@WebDavSecurityKey,5)) + ''' as a template'
			exec sptActionLogInsert 'WebDav', @NewWebDavSecurityKey, @CompanyKey, 0, 'Security Group Added', @CurDate, @UserName, @Comments, '', null, @UserKey

		END
	END
	
	Return 1
GO
