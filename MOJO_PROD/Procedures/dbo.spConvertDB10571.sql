USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10571]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10571]
AS

	UPDATE	tReviewRound
	SET		DateCreated = ISNULL(DateSent, ISNULL(CompletedDate, ISNULL(CancelledDate, ISNULL(RejectedDate, GETDATE()))))
	WHERE	DateCreated IS NULL

	-- convert the GL tables to multi currency
	exec spConvertMCGL

	-- call again spConvertMC because we added fields to tTime amd tMiscCost for the multi currency logic
	exec spConvertMC
GO
