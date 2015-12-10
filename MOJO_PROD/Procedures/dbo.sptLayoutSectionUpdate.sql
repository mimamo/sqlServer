USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutSectionUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutSectionUpdate]
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
	@CanGrow tinyint,
	@CanShrink tinyint
AS --Encrypt

/*
|| When      Who Rel      What
|| 03/11/10  MFT 10.5.2.0 Created
*/

DELETE
FROM
	tLayoutSection
WHERE
	LayoutReportKey = @LayoutReportKey AND
	ElementID = @ElementID

INSERT INTO
	tLayoutSection
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
		CanGrow,
		CanShrink
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
		@CanGrow,
		@CanShrink
	)
GO
