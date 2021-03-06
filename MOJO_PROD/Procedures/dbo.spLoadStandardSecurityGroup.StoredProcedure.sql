USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadStandardSecurityGroup]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadStandardSecurityGroup]
 @GroupName varchar(100),
 @CompanyKey int,
 @StandardDesktop text,
 @ChangeLayout int,
 @ChangeDesktop int,
 @ChangeWindow int,
 @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/12/09 GHL 10.512 Creation for LoadStandard
*/



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
  Active,
  StandardDesktop,
  ChangeLayout,
  ChangeDesktop,
  ChangeWindow
  )
 VALUES
  (
  @GroupName,
  @CompanyKey,
  1, 
  @StandardDesktop,
  @ChangeLayout,
  @ChangeDesktop,
  @ChangeWindow
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
