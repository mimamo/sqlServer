USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetDetailDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetDetailDelete]
	@LaborBudgetDetailKey int

AS --Encrypt

	DELETE
	FROM tLaborBudgetDetail
	WHERE
		LaborBudgetDetailKey = @LaborBudgetDetailKey 

	RETURN 1
GO
