USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupInsert]
 @GroupName varchar(100),
 @CompanyKey int,
 @Active tinyint,
 @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 04/25/08 GWG 1.0	  Added defaulting of desktop settings by default
*/

 IF @Active IS NULL
  SELECT @Active = 1

 IF @Active = 1
 BEGIN
	IF EXISTS (SELECT 1
	           FROM   tSecurityGroup (NOLOCK) 
	           WHERE  UPPER(LTRIM(RTRIM(GroupName))) = UPPER(LTRIM(RTRIM(@GroupName))) 
						 AND    CompanyKey = @CompanyKey
						 AND    Active = 1)
		RETURN -1
		
 END 
 		
 INSERT tSecurityGroup
  (
  GroupName,
  CompanyKey,
  Active,
  ChangeLayout,
  ChangeDesktop,
  ChangeWindow
  )
 VALUES
  (
  @GroupName,
  @CompanyKey,
  @Active, 
  1,
  1,
  1
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
