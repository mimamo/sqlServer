USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemReplyGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemReplyGet]
 @ApprovalItemReplyKey int
AS --Encrypt
 SELECT *
 FROM tApprovalItemReply (nolock)
 WHERE
  ApprovalItemReplyKey = @ApprovalItemReplyKey
 RETURN 1
GO
