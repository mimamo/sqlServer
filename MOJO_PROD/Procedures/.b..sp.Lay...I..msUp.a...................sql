USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutItemsUpdate]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutItemsUpdate]
	@LayoutReportKey int,
	@ElementID smallint,
	@ParentID smallint,
	@ReportTag varchar(50),
	@Type varchar(50),
	@Name varchar(100),
	@BackColor int,
	@BorderColor int,
	@BorderStyle varchar(50),
	@BorderLeft tinyint,
	@BorderRight tinyint,
	@BorderTop tinyint,
	@BorderBottom tinyint,
	@BorderThickness smallint,
	@Shadow tinyint,
	@X int,
	@Y int,
	@Height int,
	@Width int,
	@Text text,
	@ForeColor int,
	@FontFamily varchar(50),
	@FontSize smallint,
	@FontItalic tinyint,
	@FontBold tinyint,
	@FontUnderline tinyint,
	@TextAlign varchar(50),
	@LineColor int,
	@LineStyle varchar(50),
	@LineWeight tinyint,
	@X1 int,
	@Y1 int,
	@X2 int,
	@Y2 int,
	@CornerRadius smallint,
	@ShapeType varchar(50),
	@ImageAlignment varchar(50),
	@ImageMode varchar(50),
	@ImageData image,
	@DataField varchar(200),
	@ConfigData text,
	@WordWrap tinyint,
	@CanGrow tinyint,
	@CanShrink tinyint,
	@DataType varchar(50),
	@DecimalPlaces smallint,
	@ShowCurrencySymbol tinyint
AS --Encrypt

/*
|| When      Who Rel      What
|| 03/11/10  MFT 10.5.2.0 Created
|| 3/22/10   CRG 10.5.2.0 Added WordWrap, CanGrow, and CanShrink
|| 3/23/10   CRG 10.5.2.0 Added DataType and DecimalPlaces
|| 3/24/10   CRG 10.5.2.0 Added ShowCurrencySymbol
*/

DELETE
FROM
	tLayoutItems
WHERE
	LayoutReportKey = @LayoutReportKey AND
	ElementID = @ElementID

INSERT INTO
	tLayoutItems
	(
		LayoutReportKey,
		ElementID,
		ParentID,
		ReportTag,
		Type,
		Name,
		BackColor,
		BorderColor,
		BorderStyle,
		BorderLeft,
		BorderRight,
		BorderTop,
		BorderBottom,
		BorderThickness,
		Shadow,
		X,
		Y,
		Height,
		Width,
		Text,
		ForeColor,
		FontFamily,
		FontSize,
		FontItalic,
		FontBold,
		FontUnderline,
		TextAlign,
		LineColor,
		LineStyle,
		LineWeight,
		X1,
		Y1,
		X2,
		Y2,
		CornerRadius,
		ShapeType,
		ImageAlignment,
		ImageMode,
		ImageData,
		DataField,
		ConfigData,
		WordWrap,
		CanGrow,
		CanShrink,
		DataType,
		DecimalPlaces,
		ShowCurrencySymbol
	)
VALUES
	(
		@LayoutReportKey,
		@ElementID,
		@ParentID,
		@ReportTag,
		@Type,
		@Name,
		@BackColor,
		@BorderColor,
		@BorderStyle,
		@BorderLeft,
		@BorderRight,
		@BorderTop,
		@BorderBottom,
		@BorderThickness,
		@Shadow,
		@X,
		@Y,
		@Height,
		@Width,
		@Text,
		@ForeColor,
		@FontFamily,
		@FontSize,
		@FontItalic,
		@FontBold,
		@FontUnderline,
		@TextAlign,
		@LineColor,
		@LineStyle,
		@LineWeight,
		@X1,
		@Y1,
		@X2,
		@Y2,
		@CornerRadius,
		@ShapeType,
		@ImageAlignment,
		@ImageMode,
		@ImageData,
		@DataField,
		@ConfigData,
		@WordWrap,
		@CanGrow,
		@CanShrink,
		@DataType,
		@DecimalPlaces,
		@ShowCurrencySymbol
	)
GO
