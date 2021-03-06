USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewCommentMarkupInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewCommentMarkupInsert]
 @ReviewCommentKey INT,
 @Name VARCHAR (50),
 @Type VARCHAR(50),
 @X0 INT,
 @Y0 INT,
 @X1 INT,
 @Y1 INT,
 @LineWidth INT,
 @StrokeStyle VARCHAR(50),
 @FillStyle VARCHAR(50),
 @Style VARCHAR(50),
 @MarkupData VARCHAR(max) = NULL
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 01/01/12	RJE 10.5.9.0	Created for new ArtReview
  */

	INSERT INTO tReviewCommentMarkup
			(
			 ReviewCommentKey,
			 Name,
			 Type,
			 X0,
			 Y0,
			 X1,
			 Y1,
			 LineWidth,
			 StrokeStyle,
			 FillStyle,
			 Style,
			 MarkupData
			)
	VALUES  (
			 @ReviewCommentKey,
			 @Name,
			 @Type,
			 @X0,
			 @Y0,
			 @X1,
			 @Y1,
			 @LineWidth,
			 @StrokeStyle,
			 @FillStyle,
			 @Style,
			 @MarkupData
			)
			
			RETURN @@IDENTITY
GO
