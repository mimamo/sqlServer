USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityGroupDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityGroupDelete]
	 @CompanyKey int
	,@UserKey int
	,@GroupName varchar(100)
	,@SecurityGroupKey int
AS

/*
|| When       Who Rel       What
|| 03/02/15   WDF 10.5.9.0  Created - (240165) Delete the WebDav Group rights when the corresponding Security Group is deleted
*/
	DECLARE	@WebDavSecurityKey int
	DECLARE @UserName varchar(201)
	DECLARE @CurDate smalldatetime
	DECLARE @Comments varchar(4000)
	DECLARE @RowCount int

	SET @CurDate = GETUTCDATE()
	SELECT @UserName = FirstName + ' ' + LastName from tUser (NOLOCK) where UserKey = @UserKey

	IF EXISTS(select 1 from tSecurityGroup (nolock) where CompanyKey = @CompanyKey and SecurityGroupKey = @SecurityGroupKey)
		Return -1

	SELECT @WebDavSecurityKey = -1
 
	WHILE (1=1)
	BEGIN
		SELECT @WebDavSecurityKey = MIN(WebDavSecurityKey)
		  FROM tWebDavSecurity (nolock)
		 WHERE CompanyKey = @CompanyKey
		   AND Entity = 'tSecurityGroup'
		   AND EntityKey = @SecurityGroupKey
		   AND WebDavSecurityKey > @WebDavSecurityKey

		IF @WebDavSecurityKey IS NULL
			BREAK
		
		DELETE	tWebDavSecurity
		 WHERE	CompanyKey = @CompanyKey
		   AND  Entity = 'tSecurityGroup'
		   AND  EntityKey = @SecurityGroupKey
		   AND  WebDavSecurityKey = @WebDavSecurityKey
		   
		SET @Comments = 'Security Group ''' + @GroupName + ''' with key ''' + @WebDavSecurityKey + ''' was Deleted'
		exec sptActionLogInsert 'WebDav', @WebDavSecurityKey, @CompanyKey, 0, 'Security Group Deleted', @CurDate, @UserName, @Comments, '', null, @UserKey

	END
GO
