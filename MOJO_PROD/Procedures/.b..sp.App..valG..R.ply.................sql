USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalGetReply]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptApprovalGetReply]
 (
  @ApprovalKey int,
  @UserKey int
 )
AS --Encrypt

/*
|| When     Who Rel      What
|| 03/28/07 RTC 8.4.1    (8302) Changed union to union all to accomodate Comments being changed to a text data type
|| 8/10/12  CRG 10.5.5.8 Added ProjectKey and WebDavRelativePath
*/


if not exists(Select 1 from tApprovalItemReply air (nolock) 
	inner join tApprovalItem ai (nolock) on ai.ApprovalItemKey = air.ApprovalItemKey
	Where ApprovalKey = @ApprovalKey and UserKey = @UserKey)
BEGIN
 -- If the approval has been sent, then insert the reply keys
	INSERT INTO tApprovalItemReply
		(ApprovalItemKey, UserKey, Status)
	SELECT ApprovalItemKey, @UserKey, 0
	FROM tApprovalItem (nolock)
	WHERE ApprovalKey = @ApprovalKey
END

	SELECT	ai.ApprovalItemKey, ai.ApprovalKey, ai.DisplayOrder, ai.ItemName, ai.Description,
			ai.AttachmentType, ai.FileVersionKey, ai.URL, ai.URLName, ai.FileType, ai.Visible,
			ai.FileHeight, ai.FileWidth, ai.WindowHeight, ai.WindowWidth, ai.WindowBackground,
			ai.Position, air.ApprovalItemReplyKey, air.Status AS ReplyStatus, air.Comments, 
			att.FileName, ai.AttachmentKey, NULL AS FileKey, a.ProjectKey, '' AS WebDavRelativePath
	FROM	tApprovalItem ai (nolock)
	INNER JOIN tApproval a (nolock) on ai.ApprovalKey = a.ApprovalKey
	INNER JOIN tApprovalItemReply air (nolock) ON air.ApprovalItemKey = ai.ApprovalItemKey
	LEFT JOIN tAttachment att (nolock) on ai.AttachmentKey = att.AttachmentKey
	WHERE	air.UserKey = @UserKey 
	AND		a.ApprovalKey = @ApprovalKey
	AND		ISNULL(ai.Visible, 1) = 1
	AND		ISNULL(ai.FileVersionKey,0) = 0
	 
	UNION ALL
	 
	SELECT	ai.ApprovalItemKey, ai.ApprovalKey, ai.DisplayOrder, ai.ItemName, ai.Description,
			ai.AttachmentType, ai.FileVersionKey, ai.URL, ai.URLName, ai.FileType, ai.Visible,
			ai.FileHeight, ai.FileWidth, ai.WindowHeight, ai.WindowWidth, ai.WindowBackground,
			ai.Position, air.ApprovalItemReplyKey, air.Status AS ReplyStatus, air.Comments, 
			f.FileName,
			-ai.FileVersionKey, --Used for the link in the list, so the system knows if it's an attachment or linked from DAM
			f.FileKey, a.ProjectKey, folder.WebDavRelativePath
	FROM	tApprovalItem ai (nolock)
	INNER JOIN tApproval a (nolock) ON ai.ApprovalKey = a.ApprovalKey
	INNER JOIN tApprovalItemReply air (nolock) ON air.ApprovalItemKey = ai.ApprovalItemKey
	INNER JOIN tDAFileVersion fv (NOLOCK) ON ai.FileVersionKey = fv.FileVersionKey
	INNER JOIN tDAFile f (NOLOCK) ON fv.FileKey = f.FileKey
	INNER JOIN tDAFolder folder (NOLOCK) ON f.FolderKey = folder.FolderKey
	WHERE	air.UserKey = @UserKey 
	AND		a.ApprovalKey = @ApprovalKey
	AND		ISNULL(ai.Visible, 1) = 1
	ORDER BY ai.DisplayOrder, ai.ApprovalItemKey
GO
