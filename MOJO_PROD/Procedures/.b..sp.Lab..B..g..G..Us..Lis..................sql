USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetGetUserList]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetGetUserList]

	(
		@UserKey int
	)

AS

Select * 
From
	tLaborBudget lb (nolock)
	inner join tLaborBudgetDetail lbd (nolock) on lb.LaborBudgetKey = lbd.LaborBudgetKey
Where
	lbd.UserKey = @UserKey
Order By
	lb.Active DESC, lbd.Locked, lb.BudgetName
GO
