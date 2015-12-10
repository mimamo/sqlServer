USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaMixAnalysis]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaMixAnalysis]
	(
		@CompanyKey int,
		@ClientKey int,
		@ProjectKey int,
		@EndDate smalldatetime,
		@UserKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 08/28/07 GHL 8.435 (12215) Taking now in account company's preferences 
|| 09/05/07 GHL 8.435 Added filter by client and project
|| 04/17/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
*/

Declare @Q1 smalldatetime, @Q2 smalldatetime, @Q3 smalldatetime, @Q4 smalldatetime

Select  @Q1 = DATEADD(mm, -12,@EndDate), 
		@Q2 = DATEADD(mm, -9,@EndDate), 
		@Q3 = DATEADD(mm, -6,@EndDate), 
		@Q4 = DATEADD(mm, -3,@EndDate)

DECLARE @IOClientLink INT
		,@BCClientLink INT
						
SELECT @IOClientLink = ISNULL(IOClientLink, 1)
		,@BCClientLink = ISNULL(BCClientLink, 1)
FROM   tPreference (NOLOCK)
WHERE  CompanyKey = @CompanyKey		
		
Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
						
CREATE TABLE #tMixAnalysis (GLCompanyKey INT NULL, ClientKey INT NULL, ProjectKey INT NULL
							,Client VARCHAR(200) NULL, ItemName VARCHAR(200) NULL
							,Q1 MONEY NULL, Q2 MONEY NULL, Q3 MONEY NULL, Q4 MONEY NULL, Total MONEY NULL)
			
INSERT #tMixAnalysis 		
	Select
		po.GLCompanyKey,
		p.ClientKey,
		pod.ProjectKey,
		c.CompanyName,
		i.ItemName,
		Sum(Case When pod.DetailOrderDate > @Q1 and pod.DetailOrderDate <= @Q2 then pod.BillableCost else 0 end) as Q1,
		Sum(Case When pod.DetailOrderDate > @Q2 and pod.DetailOrderDate <= @Q3 then pod.BillableCost else 0 end) as Q2,
		Sum(Case When pod.DetailOrderDate > @Q3 and pod.DetailOrderDate <= @Q4 then pod.BillableCost else 0 end) as Q3,
		Sum(Case When pod.DetailOrderDate > @Q4 and pod.DetailOrderDate <= @EndDate then pod.BillableCost else 0 end) as Q4,
		Sum(pod.BillableCost) as Total
		
	From 
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
		inner join tItem i (nolock) on pod.ItemKey = i.ItemKey
		inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		@IOClientLink = 1 and 
		po.POKind = 1  and
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate <= @EndDate and
		pod.DetailOrderDate > DATEADD(yyyy, -1,@EndDate)
	Group By 
		po.GLCompanyKey,
		p.ClientKey,
		pod.ProjectKey,
		c.CompanyName,
		i.ItemName
	Order By
		c.CompanyName, i.ItemName

INSERT #tMixAnalysis 		
	Select
		po.GLCompanyKey,
		me.ClientKey,
		pod.ProjectKey,
		c.CompanyName,
		i.ItemName,
		Sum(Case When pod.DetailOrderDate > @Q1 and pod.DetailOrderDate <= @Q2 then pod.BillableCost else 0 end) as Q1,
		Sum(Case When pod.DetailOrderDate > @Q2 and pod.DetailOrderDate <= @Q3 then pod.BillableCost else 0 end) as Q2,
		Sum(Case When pod.DetailOrderDate > @Q3 and pod.DetailOrderDate <= @Q4 then pod.BillableCost else 0 end) as Q3,
		Sum(Case When pod.DetailOrderDate > @Q4 and pod.DetailOrderDate <= @EndDate then pod.BillableCost else 0 end) as Q4,
		Sum(pod.BillableCost) as Total
		
	From 
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
		inner join tItem i (nolock) on pod.ItemKey = i.ItemKey
		inner join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		inner join tCompany c (nolock) on me.ClientKey = c.CompanyKey
	Where
		@IOClientLink = 2 and 
		po.POKind = 1  and
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate <= @EndDate and
		pod.DetailOrderDate > DATEADD(yyyy, -1,@EndDate)
	Group By 
		po.GLCompanyKey,
		me.ClientKey,
		pod.ProjectKey,
		c.CompanyName,
		i.ItemName
	Order By
		c.CompanyName, i.ItemName
	
INSERT #tMixAnalysis 		
	Select
		po.GLCompanyKey,
		p.ClientKey,
		pod.ProjectKey,
		c.CompanyName,
		i.ItemName,
		Sum(Case When pod.DetailOrderDate > @Q1 and pod.DetailOrderDate <= @Q2 then pod.BillableCost else 0 end) as Q1,
		Sum(Case When pod.DetailOrderDate > @Q2 and pod.DetailOrderDate <= @Q3 then pod.BillableCost else 0 end) as Q2,
		Sum(Case When pod.DetailOrderDate > @Q3 and pod.DetailOrderDate <= @Q4 then pod.BillableCost else 0 end) as Q3,
		Sum(Case When pod.DetailOrderDate > @Q4 and pod.DetailOrderDate <= @EndDate then pod.BillableCost else 0 end) as Q4,
		Sum(pod.BillableCost) as Total
		
	From 
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
		inner join tItem i (nolock) on pod.ItemKey = i.ItemKey
		inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		@BCClientLink = 1 and 
		po.POKind = 2  and
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate <= @EndDate and
		pod.DetailOrderDate > DATEADD(yyyy, -1,@EndDate)
	Group By 
		po.GLCompanyKey,
		p.ClientKey,
		pod.ProjectKey,
		c.CompanyName,
		i.ItemName
	Order By
		c.CompanyName, i.ItemName

INSERT #tMixAnalysis 		
	Select
		po.GLCompanyKey,
		me.ClientKey,
		pod.ProjectKey,
		c.CompanyName,
		i.ItemName,
		Sum(Case When pod.DetailOrderDate > @Q1 and pod.DetailOrderDate <= @Q2 then pod.BillableCost else 0 end) as Q1,
		Sum(Case When pod.DetailOrderDate > @Q2 and pod.DetailOrderDate <= @Q3 then pod.BillableCost else 0 end) as Q2,
		Sum(Case When pod.DetailOrderDate > @Q3 and pod.DetailOrderDate <= @Q4 then pod.BillableCost else 0 end) as Q3,
		Sum(Case When pod.DetailOrderDate > @Q4 and pod.DetailOrderDate <= @EndDate then pod.BillableCost else 0 end) as Q4,
		Sum(pod.BillableCost) as Total
		
	From 
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
		inner join tItem i (nolock) on pod.ItemKey = i.ItemKey
		inner join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		inner join tCompany c (nolock) on me.ClientKey = c.CompanyKey
	Where
		@BCClientLink = 2 and 
		po.POKind = 2  and
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate <= @EndDate and
		pod.DetailOrderDate > DATEADD(yyyy, -1,@EndDate)
	Group By 
		po.GLCompanyKey,
		me.ClientKey,
		pod.ProjectKey,
		c.CompanyName,
		i.ItemName
	Order By
		c.CompanyName, i.ItemName

IF ISNULL(@ProjectKey, 0) > 0
	DELETE #tMixAnalysis 
	WHERE ISNULL(ProjectKey, 0) <> @ProjectKey
	
IF ISNULL(@ClientKey, 0) > 0
	DELETE #tMixAnalysis 
	WHERE ISNULL(ClientKey, 0) <> @ClientKey
	
IF @RestrictToGLCompany = 1
	DELETE #tMixAnalysis WHERE ISNULL(GLCompanyKey, 0) 
			NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)

SELECT  Client, ItemName, SUM(Q1) AS Q1, SUM(Q2) AS Q2, SUM(Q3) AS Q3, SUM(Q4) AS Q4, SUM(Total) AS Total
FROM    #tMixAnalysis
GROUP BY Client, ItemName 
ORDER BY Client, ItemName 

RETURN 1
GO
