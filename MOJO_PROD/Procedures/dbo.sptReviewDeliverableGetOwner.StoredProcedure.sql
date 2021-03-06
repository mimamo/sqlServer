USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewDeliverableGetOwner]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewDeliverableGetOwner]
 @keys VARCHAR(500)
 
  /*
  || When		Who Rel			What
  || 09/11/12	QMD 10.5.6.0	Created to get the owner of the deliverable.
  */
 
AS --Encrypt
 
DECLARE @sql VARCHAR(1000)
DECLARE @owners INT
  	
	CREATE TABLE #Owner (
		[ReviewDeliverableKey] [int] NOT NULL,
		[CompanyKey] [int] NULL,
		[DeliverableName] [varchar](1000) NULL,
		[Description] [text] NULL,
		[ProjectKey] [int] NULL,
		[OwnerKey] [int] NULL,
		[DueDate] [smalldatetime] NULL,
		[LastCompletedRoundKey] [int] NULL,
		[Approved] [tinyint] NULL,
		[ApprovedDate] [smalldatetime] NULL,		
		[OwnerEmail] [varchar](100) NULL 
		)

	SET @sql = 'SELECT d.ReviewDeliverableKey, d.CompanyKey, d.DeliverableName, d.Description, d.ProjectKey, d.OwnerKey, d.DueDate, d.LastCompletedRoundKey, d.Approved, d.ApprovedDate, u.Email '
	SET @sql = @sql + 'FROM tReviewDeliverable d (NOLOCK) INNER JOIN tReviewRound r (NOLOCK) ON d.ReviewDeliverableKey = r.ReviewDeliverableKey '
	SET @sql = @sql + 'INNER JOIN tUser u (NOLOCK) ON d.OwnerKey = u.UserKey '
	SET @sql = @sql + 'WHERE r.ReviewRoundKey IN ( ' + @keys + ')'
	
	INSERT INTO #Owner
	EXEC (@sql)
	
	SELECT DISTINCT OwnerKey, OwnerEmail FROM #Owner
GO
