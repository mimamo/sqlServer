USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentGet]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAssignmentGet]
 @AssignmentKey int
AS --Encrypt
 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
 IF @AssignmentKey IS NULL
  SELECT *
  FROM  tAssignment (nolock)
 ELSE
  SELECT 
   tAssignment.*, 
      tUser.FirstName + ' ' + tUser.LastName AS UserName
  FROM 
   tAssignment (nolock) INNER JOIN
      tUser (nolock) ON tAssignment.UserKey = tUser.UserKey
  WHERE 
   tAssignment.AssignmentKey = @AssignmentKey
 RETURN 1
GO
