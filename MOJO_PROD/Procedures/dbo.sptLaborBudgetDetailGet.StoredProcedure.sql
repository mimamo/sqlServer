USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetDetailGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetDetailGet]
	@LaborBudgetKey int,
	@UserKey int

AS --Encrypt

/*
|| When     Who Rel   What
|| 02/29/08 GHL 8.5  (22188) Added FirstMonth to display monthly buckets 
||                    at the right position on traffic screens 
*/
	
		SELECT lbd.*
			  ,lb.BudgetName
			  ,u.FirstName + ' ' + u.LastName as UserName
			  ,ISNULL(FirstMonth, 1) AS FirstMonth	
		FROM tLaborBudgetDetail lbd (nolock)
			inner join tUser u (nolock) on lbd.UserKey = u.UserKey
			inner join tLaborBudget lb (nolock) on lbd.LaborBudgetKey = lb.LaborBudgetKey
			inner join tPreference pref (nolock) on lb.CompanyKey = pref.CompanyKey
		WHERE
			lbd.LaborBudgetKey = @LaborBudgetKey and lbd.UserKey = @UserKey

	RETURN 1
GO
