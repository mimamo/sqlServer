USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalListGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalListGetList]
 @ApprovalKey int
AS --Encrypt
  SELECT 
   tApprovalList.*,
   tApproval.ProjectKey, 
   tUser.FirstName,
   tUser.LastName,
   tUser.Email
  FROM tApprovalList (nolock)
  inner join tApproval (nolock) on tApproval.ApprovalKey = tApprovalList.ApprovalKey
  inner join tUser (nolock) on tApprovalList.UserKey = tUser.UserKey
  WHERE
   tApprovalList.ApprovalKey = @ApprovalKey
  Order By
   tApprovalList.ApprovalOrder
 RETURN 1
GO
