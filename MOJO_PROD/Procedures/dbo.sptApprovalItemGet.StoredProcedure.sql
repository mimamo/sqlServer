USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemGet]
	@ApprovalItemKey int
AS --Encrypt
	
	SELECT	ai.ApprovalItemKey, ai.ApprovalKey, ai.DisplayOrder, ai.ItemName, ai.Description,
			ai.AttachmentType, ai.FileVersionKey, ai.URL, ai.URLName, ai.FileType, ai.Visible,
			ai.FileHeight, ai.FileWidth, ai.WindowHeight, ai.WindowWidth, ai.WindowBackground,
			ai.Position, a.ProjectKey, att.FileName, ai.AttachmentKey, NULL as FileKey
	FROM	tApprovalItem ai (nolock)
	INNER JOIN tApproval a (nolock) on ai.ApprovalKey = a.ApprovalKey
	LEFT JOIN tAttachment att (nolock) on ai.AttachmentKey = att.AttachmentKey
	WHERE	ai.ApprovalItemKey = @ApprovalItemKey
	AND		ISNULL(ai.FileVersionKey,0) = 0
	 
	UNION
	 
	SELECT	ai.ApprovalItemKey, ai.ApprovalKey, ai.DisplayOrder, ai.ItemName, ai.Description,
			ai.AttachmentType, ai.FileVersionKey, ai.URL, ai.URLName, ai.FileType, ai.Visible,
			ai.FileHeight, ai.FileWidth, ai.WindowHeight, ai.WindowWidth, ai.WindowBackground,
			ai.Position, a.ProjectKey, 
			ISNULL(f.FileName,'') + ' (' + CAST(ISNULL(fv.VersionNumber,'') AS varchar) + ': ' + CAST(ISNULL(fv.VersionDate,'') AS varchar) + ')' AS FileName, 
			-ai.FileVersionKey, --Used for the link in the list, so the system knows if it's an attachment or linked from DAM
			f.FileKey
	FROM	tApprovalItem ai (nolock)
	INNER JOIN tApproval a (nolock) ON ai.ApprovalKey = a.ApprovalKey
	INNER JOIN tDAFileVersion fv (NOLOCK) ON ai.FileVersionKey = fv.FileVersionKey
	INNER JOIN tDAFile f (NOLOCK) ON fv.FileKey = f.FileKey
	WHERE	ai.ApprovalItemKey = @ApprovalItemKey
	
	RETURN 1
GO
