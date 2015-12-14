USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetGetNewUserList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetGetNewUserList]

	(
		@CompanyKey int,
		@LaborBudgetKey int
	)

AS --Encrypt

Select u.FirstName + ' ' + u.LastName as UserName, u.UserKey
From tUser u (nolock)
Where CompanyKey = @CompanyKey and
UserKey not in (Select UserKey from tLaborBudgetDetail Where LaborBudgetKey = @LaborBudgetKey)
Order By u.LastName
GO
