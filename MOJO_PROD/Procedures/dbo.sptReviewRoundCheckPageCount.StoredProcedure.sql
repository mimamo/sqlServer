USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundCheckPageCount]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundCheckPageCount]
 @ReviewRoundKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 04/15/15	GWG 10.5.9.0	Created for the deliverables
  */


if exists(Select 1 from tReviewRoundFile (nolock) Where ReviewRoundKey = @ReviewRoundKey and ISNULL(PageCount, 0) > 0)
	return 1
else
	return 0
GO
