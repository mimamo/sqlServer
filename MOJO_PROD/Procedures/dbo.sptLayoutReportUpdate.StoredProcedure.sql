USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutReportUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutReportUpdate]
	@LayoutReportKey int = NULL,
	@LayoutKey int,
	@Entity varchar(50),
	@PaperType varchar(50),
	@PaperWidth smallint,
	@PaperHeight smallint,
	@PaperOrientation varchar(50),
	@MarginTop smallint,
	@MarginBottom smallint,
	@MarginLeft smallint,
	@MarginRight smallint,
	@Watermark image,
	@WatermarkSizeMode varchar(50),
	@WatermarkAlignment varchar(50)
AS --Encrypt

/*
|| When      Who Rel      What
|| 03/11/10  MFT 10.5.2.0 Created
|| 3/24/10   CRG 10.5.2.0 Modified Watermark to image type
|| 3/26/10   CRG 10.5.2.0 Removed CompanyKey
|| 12/02/10  MFT 10.5.3.8 Added DELETE prior to INSERT
*/

IF ISNULL(@LayoutReportKey, 0) > 0
	UPDATE
		tLayoutReport
	SET
		LayoutKey = @LayoutKey,
		Entity = @Entity,
		PaperType = @PaperType,
		PaperWidth = @PaperWidth,
		PaperHeight = @PaperHeight,
		PaperOrientation = @PaperOrientation,
		MarginTop = @MarginTop,
		MarginBottom = @MarginBottom,
		MarginLeft = @MarginLeft,
		MarginRight = @MarginRight,
		Watermark = @Watermark,
		WatermarkSizeMode = @WatermarkSizeMode,
		WatermarkAlignment = @WatermarkAlignment
	WHERE
		LayoutReportKey = @LayoutReportKey
ELSE
	BEGIN
		DELETE FROM tLayoutReport
		WHERE
			LayoutKey = @LayoutKey AND
			Entity = @Entity
		
		INSERT INTO
			tLayoutReport
			(
					LayoutKey,
					Entity,
					PaperType,
					PaperWidth,
					PaperHeight,
					PaperOrientation,
					MarginTop,
					MarginBottom,
					MarginLeft,
					MarginRight,
					Watermark,
					WatermarkSizeMode,
					WatermarkAlignment
			)
		VALUES
			(
				@LayoutKey,
				@Entity,
				@PaperType,
				@PaperWidth,
				@PaperHeight,
				@PaperOrientation,
				@MarginTop,
				@MarginBottom,
				@MarginLeft,
				@MarginRight,
				@Watermark,
				@WatermarkSizeMode,
				@WatermarkAlignment
			)
		
		SELECT @LayoutReportKey = SCOPE_IDENTITY()
	END

RETURN @LayoutReportKey
GO
