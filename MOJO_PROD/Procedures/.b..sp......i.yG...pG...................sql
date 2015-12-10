USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupGet]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupGet]
 @SecurityGroupKey int
 ,@Active tinyint
AS --Encrypt
 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
 IF @SecurityGroupKey IS NULL
  SELECT *
  FROM  tSecurityGroup (NOLOCK) 
  WHERE (Active = @Active OR @Active IS NULL)
 ELSE
  SELECT *
  FROM tSecurityGroup (NOLOCK) 
  WHERE
   SecurityGroupKey = @SecurityGroupKey
  AND (Active = @Active OR @Active IS NULL)
 RETURN 1
GO
