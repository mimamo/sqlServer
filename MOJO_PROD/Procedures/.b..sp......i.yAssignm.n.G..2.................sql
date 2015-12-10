USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityAssignmentGet2]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityAssignmentGet2]
 (
 @SecurityGroupKey  int
   ,@ProjectKey        int
   )
AS --Encrypt
 
  SELECT *
  FROM tSecurityAssignment (NOLOCK) 
  WHERE
   SecurityGroupKey = @SecurityGroupKey
  AND  
   ProjectKey       = @ProjectKey
 RETURN 1
GO
