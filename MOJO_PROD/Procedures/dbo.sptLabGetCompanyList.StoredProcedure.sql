USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLabGetCompanyList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLabGetCompanyList]
	(
	@CompanyKey int
	)
AS


	Select l.*, case When lc.CompanyKey is null then 0 else 1 end as HasLab, 0 as UserHasLab, 0 as selected, '' as Activated
	From tLab l (nolock) 
	left outer join (Select * from tLabCompany (nolock) Where CompanyKey = @CompanyKey) as lc on l.LabKey = lc.LabKey
	Where ISNULL(Beta, 0) = 0
	
	UNION ALL
	
	Select l.*, case When lc.CompanyKey is null then 0 else 1 end as HasLab, 0 as UserHasLab, 0 as selected, '' as Activated
	From tLab l (nolock) 
	inner join tLabBeta lb (nolock) on l.LabKey = lb.LabKey and lb.CompanyKey = @CompanyKey
	left outer join (Select * from tLabCompany (nolock) Where CompanyKey = @CompanyKey) as lc on l.LabKey = lc.LabKey
	Where ISNULL(Beta, 0) = 1
GO
