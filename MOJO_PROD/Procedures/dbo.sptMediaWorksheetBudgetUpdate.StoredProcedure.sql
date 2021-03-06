USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetBudgetUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaWorksheetBudgetUpdate]
	@MediaWorksheetKey int,
	@ItemKey int,
	@Budget money
AS

/*
|| When      Who Rel      What
|| 3/11/14   CRG 10.5.7.8 Created
*/

	IF NOT EXISTS
			(SELECT NULL
			FROM	tMediaWorksheetBudget (nolock)
			WHERE	MediaWorksheetKey = @MediaWorksheetKey
			AND		Budget = @Budget)
		INSERT	tMediaWorksheetBudget
				(MediaWorksheetKey,
				ItemKey,
				Budget)
		VALUES	(@MediaWorksheetKey,
				@ItemKey,
				@Budget)
GO
