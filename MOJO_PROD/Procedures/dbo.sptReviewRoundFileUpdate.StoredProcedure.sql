USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundFileUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundFileUpdate]
 @ReviewRoundKey INT,
 @FilePath VARCHAR(2000),
 @IsURL TINYINT,
 @DisplayOrder INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/01/11	QMD 10.5.x.x	Created for new ArtReview
  || 09/28/11	QMD 10.5.4.8	added display order
  || 02/25/14	QMD 10.5.7.7	added is null
  */

IF (@DisplayOrder = -1)
	SELECT @DisplayOrder = ISNULL(MAX(DisplayOrder),0) + 1 FROM tReviewRoundFile (NOLOCK) WHERE ReviewRoundKey = @ReviewRoundKey
	
IF EXISTS (SELECT * FROM tReviewRoundFile (NOLOCK) WHERE ReviewRoundKey = @ReviewRoundKey AND FilePath = @FilePath)
	UPDATE  tReviewRoundFile
	SET		FilePath = @FilePath, IsURL = @IsURL, DisplayOrder = @DisplayOrder		
	WHERE   ReviewRoundKey = @ReviewRoundKey AND FilePath = @FilePath
	
ELSE
	INSERT INTO tReviewRoundFile
			(ReviewRoundKey,
			 FilePath,
			 IsURL,
			 DisplayOrder
			)
	VALUES  (@ReviewRoundKey,
			 @FilePath,
			 @IsURL,
			 @DisplayOrder
			)
GO
