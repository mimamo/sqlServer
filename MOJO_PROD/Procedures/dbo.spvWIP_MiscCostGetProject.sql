USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvWIP_MiscCostGetProject]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvWIP_MiscCostGetProject]

	(
		@ProjectKey int,
		@OnlyUnbilled tinyint = 0
	)

AS --Encrypt


if @OnlyUnbilled = 1
	SELECT 
		* 
	FROM 
		vWIP_MiscCost (NOLOCK)
	WHERE
		ProjectKey = @ProjectKey and
		InvoiceLineKey is null and 
		WriteOff <> 1
	ORDER BY
		ExpenseDate
else
	SELECT 
		* 
	FROM 
		vWIP_MiscCost (NOLOCK)
	WHERE
		ProjectKey = @ProjectKey
	ORDER BY
		ExpenseDate
GO
