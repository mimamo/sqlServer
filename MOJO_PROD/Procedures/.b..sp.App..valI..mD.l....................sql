USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemDelete]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemDelete]
 @ApprovalItemKey int
AS --Encrypt
 DELETE
 FROM tApprovalItemReply
 WHERE
  ApprovalItemKey = @ApprovalItemKey
 DELETE
 FROM tApprovalItem
 WHERE
  ApprovalItemKey = @ApprovalItemKey 
 RETURN 1
GO
