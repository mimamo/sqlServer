USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalGetClientAttachments]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalGetClientAttachments]
	(
		@ApprovalKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	SELECT att.AttachmentKey
		,att.FileName
		,air.ApprovalItemReplyKey
	FROM 
	tApproval a (nolock)
	INNER JOIN tApprovalItem ai (nolock) ON a.ApprovalKey = ai.ApprovalKey 
	INNER JOIN tApprovalItemReply air (nolock) ON air.ApprovalItemKey = ai.ApprovalItemKey
	INNER JOIN tAttachment att (NOLOCK) ON air.ApprovalItemReplyKey = att.EntityKey
	WHERE a.ApprovalKey = @ApprovalKey
	AND   att.AssociatedEntity = 'ApprovalItemReply'
	ORDER BY 
		ai.DisplayOrder, 
		air.ApprovalItemReplyKey,
		att.FileName
	
	RETURN 1
GO
