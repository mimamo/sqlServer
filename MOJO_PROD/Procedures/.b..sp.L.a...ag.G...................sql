USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStageGet]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStageGet]
	@LeadStageKey int

AS --Encrypt

		SELECT *
		FROM tLeadStage (nolock)
		WHERE
			LeadStageKey = @LeadStageKey

	RETURN 1
GO
