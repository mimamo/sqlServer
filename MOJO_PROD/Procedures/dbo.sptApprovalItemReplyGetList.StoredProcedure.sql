USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemReplyGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemReplyGetList]
 @ApprovalItemKey int
AS --Encrypt

 /*
  || When     Who Rel   What
  || 11/22/10 RLB 10537 (92531) added Order by Date Updated
  */


 SELECT air.*, u.FirstName + ' ' + u.LastName as UserName
 FROM tApprovalItemReply air (nolock)
	inner join tUser u (nolock) on air.UserKey = u.UserKey
 WHERE
  ApprovalItemKey = @ApprovalItemKey
  Order by air.DateUpdated, air.ApprovalItemReplyKey
 RETURN 1
GO
