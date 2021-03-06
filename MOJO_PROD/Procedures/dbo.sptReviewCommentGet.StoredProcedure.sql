USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewCommentGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewCommentGet]
 @ReviewDeliverableKey INT,
 @ReviewRoundKey INT,
 @UserKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 01/01/12	RJE 10.5.x.x	Created for new ArtReview
  || 01/10/12   GWG 10.5.5.5    Added code to find the round in a number of ways
  || 02/15/12   QMD 10.5.5.5    Added logic to restrict attachments to external steps for client logins
  || 4/17/12    CRG 10.5.5.5    Returning the Project's OfficeKey in case the office is using a different WebDAV server
  ||                            Added Src to the File and Attachment queries so that we can add the WebDAV URL in VB prior to sending it to the JS
  ||                            Added FileID to the Attachment query
  || 3/13/13    GWG 10.5.6.6    If there is no active step, getting the last step as we allow comments at any time now
  || 07/15/13	QMD 10.5.6.9    Fixed the approval step status description to match the code
  || 07/16/13	QMD 10.5.7.0    Changed Rejected status description to Changes Needed
  || 07/19/13	QMD 10.5.7.0    Added #ReviewKeys to limit the review markup get when clientlogin = 1
  || 09/06/13	QMD 10.5.7.1    Added Distinct to insert of review keys to eliminate duplicates
  || 02/27/14	QMD 10.5.7.7    Added Distinct to the clientvendorlogin
  || 05/28/14	QMD 10.5.8.0    Added ApprovalStepKey, MaxNumberOfRounds
  || 06/13/14	QMD 10.5.8.1    Added Approveral Select
  */
  -- Get the round info object
  
declare @RequestedRoundKey int, @PrivateCanView tinyint, @CanApprove tinyint, @ClientLogin tinyint, @ProjectKey int

if @ReviewRoundKey is null
BEGIN
	-- Just passed a deliverablekey, so find the round to show by the last completed review (non cancelled)
	Select @ReviewRoundKey = LastCompletedRoundKey
	From tReviewDeliverable (nolock) 
	Where ReviewDeliverableKey = @ReviewDeliverableKey

	if @ReviewRoundKey is null
		Select @ReviewRoundKey = Max(ReviewRoundKey)
		From tReviewRound (nolock) 
		Where ReviewDeliverableKey = @ReviewDeliverableKey
END

-- See if the user is a client login
if @UserKey = 0
	Select @ClientLogin = 1
else
	Select @ClientLogin = ISNULL(ClientVendorLogin, 0) from tUser Where UserKey = @UserKey


 -- Need to figure out which deliverable we are on
if @ReviewDeliverableKey is null
	Select @ReviewDeliverableKey = ReviewDeliverableKey from tReviewRound (nolock) Where ReviewRoundKey = @ReviewRoundKey

Select @ProjectKey = ProjectKey from tReviewDeliverable (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey

-- Is this person listed as an approver anywhere on this deliverable. If not and a login is required, then not allowed to view
if exists(Select 1 from tApprovalStepUser asu (nolock)
		inner join tApprovalStep tas (nolock) on asu.ApprovalStepKey = tas.ApprovalStepKey
		Where asu.AssignedUserKey = @UserKey and tas.Entity = 'tReviewRound' and EntityKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey))
	Select @PrivateCanView = 1
Else
	Select @PrivateCanView = 0

-- See if the person viewing the review is the active approver
if exists(Select 1 From tApprovalStep aps (nolock)
			INNER JOIN tApprovalStepUser asu (nolock) on aps.ApprovalStepKey = asu.ApprovalStepKey
			Where aps.EntityKey = @ReviewRoundKey and aps.Entity = 'tReviewRound' and ActiveStep = 1 and asu.AssignedUserKey = @UserKey and asu.ActiveUser = 1)
	SELECT @CanApprove = 1
ELSE
	SELECT @CanApprove = 0

Declare @ApprovalStepKey int

Select @ApprovalStepKey = ApprovalStepKey from tApprovalStep (nolock) Where Entity = 'tReviewRound' and EntityKey = @ReviewRoundKey and ActiveStep = 1
if @ApprovalStepKey is null
	Select @ApprovalStepKey = Max(ApprovalStepKey) from tApprovalStep (nolock) Where Entity = 'tReviewRound' and EntityKey = @ReviewRoundKey

SELECT	r.*, p.ProjectKey, p.ProjectName, p.ProjectNumber, p.OfficeKey,
		ISNULL(p.ProjectNumber,'') + ' - ' + ISNULL(p.ProjectName,'')AS ProjectFormattedName,
		d.DeliverableName,
		CASE r.Status
			WHEN 1 THEN 'New'
			WHEN 2 THEN 'Submitted'
			WHEN 3 THEN 'Completed'
			WHEN 4 THEN 'Cancelled'
			ELSE 'Invalid Status ... Check SP'
		END AS StatusDescription,
		ISNULL(aps.Instructions, '') AS Instructions,
		ISNULL(aps.ApprovalStepKey, 0) as CurrentStepKey,
		ISNULL(aps.LoginRequired, 1) as LoginRequired,
		@PrivateCanView as PrivateCanView,
		@CanApprove as CanApprove,
		@ClientLogin AS ClientLogin,
		CASE WHEN r.Status = 4 THEN 0 ELSE 1 END AS CanComment,
		aps.ApprovalStepKey,
		ISNULL(d.MaxNumberOfRounds,0) AS MaxNumberOfRounds
FROM tReviewRound r (NOLOCK) 
INNER JOIN tReviewDeliverable d (NOLOCK) ON d.ReviewDeliverableKey = r.ReviewDeliverableKey
INNER JOIN tProject p (NOLOCK) ON p.ProjectKey = d.ProjectKey
LEFT OUTER JOIN tApprovalStep aps (NOLOCK) on r.ReviewRoundKey= aps.EntityKey and aps.Entity = 'tReviewRound' and ApprovalStepKey = @ApprovalStepKey
WHERE		ReviewRoundKey = @ReviewRoundKey

IF Object_Id('tempdb..#ReviewKeys') IS NOT NULL  
  DROP TABLE #ReviewKeys  

CREATE TABLE #ReviewKeys(	
	[ReviewRoundKey] [int] NULL )
  
-- Get all comments for this round/step
if @ClientLogin = 1
	INSERT INTO #ReviewKeys
	SELECT	DISTINCT rc.ReviewRoundKey
	FROM	tReviewComment rc (NOLOCK) 
			LEFT OUTER JOIN tUser u (NOLOCK) on rc.UserKey = u.UserKey	
	WHERE	rc.ReviewRoundKey = @ReviewRoundKey
			AND	(u.UserKey is null OR u.ClientVendorLogin = 1 OR u.UserKey = @UserKey)
ELSE
	INSERT INTO #ReviewKeys
	SELECT	DISTINCT rc.ReviewRoundKey
	FROM	tReviewComment rc (NOLOCK) 
	WHERE	rc.ReviewRoundKey = @ReviewRoundKey

SELECT	rc.*,
	CASE asu.Action
			WHEN 1 THEN 'Approved'
			WHEN 2 THEN 'Changes Needed'
			ELSE ''
		END AS Status	
FROM		tReviewComment rc (NOLOCK) 
	LEFT OUTER JOIN tApprovalStepUser asu (NOLOCK) on rc.UserKey = asu.AssignedUserKey AND rc.ApprovalStepKey = asu.ApprovalStepKey
	INNER JOIN #ReviewKeys rk (NOLOCK) ON rc.ReviewRoundKey = rk.ReviewRoundKey
ORDER BY  rc.ParentCommentKey ASC, rc.ReviewCommentKey ASC
  
-- Get all markup for this round/step
SELECT	rm.*
FROM	tReviewCommentMarkup rm (NOLOCK) 
		INNER JOIN tReviewComment rc (NOLOCK) ON rm.ReviewCommentKey = rc.ReviewCommentKey
		INNER JOIN #ReviewKeys rk (NOLOCK) ON rc.ReviewRoundKey = rk.ReviewRoundKey

-- Get the list of files for downloading
SELECT FilePath, IsURL, '' AS Src, ReviewRoundFileKey 
FROM tReviewRoundFile (NOLOCK)
WHERE ReviewRoundKey = @ReviewRoundKey
ORDER BY DisplayOrder

-- Get the Other Rounds for this deliverable
if @ClientLogin = 1
BEGIN
	SELECT	ReviewCommentKey, FileName, Path, FileID, CASE WHEN CHARINDEX('.',REVERSE(FileName)) > 1 THEN LOWER( RIGHT(FileName, CHARINDEX('.',REVERSE(FileName))-1)) ELSE '' END AS FileType, '' AS Src
	FROM	tAttachment a (NOLOCK) 
				inner join tReviewComment rc (NOLOCK) on a.EntityKey = rc.ReviewCommentKey and a.AssociatedEntity = 'tReviewComment'
				inner join tApprovalStep tas (NOLOCK) on tas.Entity = 'tReviewRound' and tas.ApprovalStepKey = rc.ApprovalStepKey
	WHERE	rc.ReviewRoundKey = @ReviewRoundKey
				and tas.Internal = 0

	Select Distinct rr.ReviewRoundKey, Status, RoundName, Case When CancelledDate is null then 0 else 1 end as Cancelled, Case When rr.ReviewRoundKey = @ReviewRoundKey then 1 else 0 end as SelectedRound
	From tReviewRound rr (nolock)
	inner join tApprovalStep aps (nolock) on rr.ReviewRoundKey= aps.EntityKey and aps.Entity = 'tReviewRound'
	inner join tApprovalStepUser asu (nolock) on aps.ApprovalStepKey = asu.ApprovalStepKey
	Where ReviewDeliverableKey = @ReviewDeliverableKey and asu.AssignedUserKey = @UserKey and (asu.CompletedUser = 1 OR asu.ActiveUser = 1)
	Order By ReviewRoundKey

	Select rd.ReviewDeliverableKey, rd.DeliverableName, ISNULL(rr.RoundName, 'Round 1') as RoundName
	From tReviewDeliverable rd (nolock) 
	inner join tReviewRound rr (nolock) on rd.LastCompletedRoundKey = rr.ReviewRoundKey
	Where rd.ProjectKey = @ProjectKey
	and rd.ReviewDeliverableKey in (Select Distinct ReviewDeliverableKey from tReviewRound rr (nolock)
										inner join tApprovalStep a (nolock) on rr.ReviewRoundKey = a.EntityKey AND a.Entity = 'tReviewRound'
										inner join tApprovalStepUser asu (NOLOCK) on asu.ApprovalStepKey = a.ApprovalStepKey
										Where asu.AssignedUserKey = @UserKey and (asu.CompletedUser = 1 OR asu.ActiveUser = 1))
	Order By DeliverableName

END
ELSE
BEGIN
	SELECT ReviewCommentKey, a.AttachmentKey, FileName, Path, FileID, CASE WHEN CHARINDEX('.',REVERSE(FileName)) > 1 THEN LOWER( RIGHT(FileName, CHARINDEX('.',REVERSE(FileName))-1)) ELSE '' END AS FileType, '' AS Src
	From tAttachment a (nolock) 
	inner join tReviewComment rc (nolock) on a.EntityKey = rc.ReviewCommentKey and a.AssociatedEntity = 'tReviewComment'
	Where rc.ReviewRoundKey = @ReviewRoundKey

	Select rr.ReviewRoundKey, Status, RoundName, Case When CancelledDate is null then 0 else 1 end as Cancelled, Case When rr.ReviewRoundKey = @ReviewRoundKey then 1 else 0 end as SelectedRound
	From tReviewRound rr (nolock)
	Where ReviewDeliverableKey = @ReviewDeliverableKey
	Order By ReviewRoundKey


	Select rd.ReviewDeliverableKey, rd.DeliverableName, ISNULL(rr.RoundName, 'Round 1') as RoundName
	From tReviewDeliverable rd (nolock) 
	left outer join tReviewRound rr (nolock) on rd.LastCompletedRoundKey = rr.ReviewRoundKey
	Where rd.ProjectKey = @ProjectKey and rd.ReviewDeliverableKey in (Select Distinct revD.ReviewDeliverableKey from tReviewRound rev (nolock)
																			inner join tReviewDeliverable revD on revD.ReviewDeliverableKey = rev.ReviewDeliverableKey
																			Where revD.ProjectKey = @ProjectKey)
	Order By DeliverableName
END


--Get Approvers who approved
SELECT	u.FirstName + ' ' + u.LastName AS FullName
FROM	tApprovalStepUser asu (NOLOCK) INNER JOIN tUser u (NOLOCK) ON asu.AssignedUserKey = u.UserKey
WHERE	ApprovalStepKey = @ApprovalStepKey And Action = 1
GO
