USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutCopy]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutCopy]
	@LayoutKey int
AS

/*
|| When      Who Rel      What
|| 4/20/10   CRG 10.5.2.2 Created to make a copy of a layout
|| 10/28/10  GHL 10.5.3.7 Added Task Show Transactions field
*/

	DECLARE	@NewLayoutKey int,
			@LayoutReportKey int,
			@NewLayoutReportKey int,
			@Entity varchar(50)
			
	SELECT	@Entity = Entity
	FROM	tLayout (nolock)
	WHERE	LayoutKey = @LayoutKey
	
	INSERT	tLayout
			(CompanyKey,
			LayoutName,
			Entity,
			Active,
			TaskDetailOption,
			TaskShowTransactions)
	SELECT	CompanyKey,
			'Copy of ' + ISNULL(LayoutName, ''),
			Entity,
			Active,
			TaskDetailOption,
			TaskShowTransactions
	FROM	tLayout (nolock)
	WHERE	LayoutKey = @LayoutKey
	
	SELECT	@NewLayoutKey = @@IDENTITY
	
	IF @Entity = 'billing'
	BEGIN
		INSERT	tLayoutBilling
				(LayoutKey,
				Entity,
				EntityKey,
				ParentEntity,
				ParentEntityKey,
				DisplayOption,
				DisplayOrder,
				LayoutOrder,
				LayoutLevel)
		SELECT	@NewLayoutKey,
				Entity,
				EntityKey,
				ParentEntity,
				ParentEntityKey,
				DisplayOption,
				DisplayOrder,
				LayoutOrder,
				LayoutLevel
		FROM	tLayoutBilling (nolock)
		WHERE	LayoutKey = @LayoutKey
	END
	
	SELECT	@LayoutReportKey = 0
	
	WHILE(1=1)
	BEGIN
		SELECT	@LayoutReportKey = MIN(LayoutReportKey)
		FROM	tLayoutReport (nolock)
		WHERE	LayoutKey = @LayoutKey
		AND		LayoutReportKey > @LayoutReportKey
		
		IF @LayoutReportKey IS NULL
			BREAK
		
		INSERT	tLayoutReport
				(LayoutKey,
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
				WatermarkAlignment)
		SELECT	@NewLayoutKey,
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
		FROM	tLayoutReport (nolock)
		WHERE	LayoutReportKey = @LayoutReportKey
	
		SELECT	@NewLayoutReportKey = @@IDENTITY
	
		INSERT	tLayoutSection
				(LayoutReportKey,
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
				CanGrow,
				CanShrink)
		SELECT	@NewLayoutReportKey,
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
				CanGrow,
				CanShrink
		FROM	tLayoutSection (nolock)
		WHERE	LayoutReportKey = @LayoutReportKey
				
		INSERT	tLayoutItems
				(LayoutReportKey,
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
				DataField,
				ConfigData,
				ForeColor,
				ImageData,
				CanGrow,
				CanShrink,
				WordWrap,
				DataType,
				DecimalPlaces,
				ShowCurrencySymbol)
		SELECT	@NewLayoutReportKey,
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
				DataField,
				ConfigData,
				ForeColor,
				ImageData,
				CanGrow,
				CanShrink,
				WordWrap,
				DataType,
				DecimalPlaces,
				ShowCurrencySymbol
		FROM	tLayoutItems (nolock)
		WHERE	LayoutReportKey = @LayoutReportKey
		
	END

	RETURN @NewLayoutKey
GO
