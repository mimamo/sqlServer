USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemReplyDelete]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemReplyDelete]
 @ApprovalItemReplyKey int
AS --Encrypt
 DELETE
 FROM tApprovalItemReply
 WHERE
  ApprovalItemReplyKey = @ApprovalItemReplyKey 
 RETURN 1
GO
