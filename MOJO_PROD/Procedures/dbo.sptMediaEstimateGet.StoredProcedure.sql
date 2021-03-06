USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaEstimateGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaEstimateGet]
	@MediaEstimateKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 11/16/06 CRG 8.3571  Added ClassID
|| 09/12/07 BSH 8.5     Added GLCompanyName
*/
		SELECT me.*
			,c.CustomerID as ClientID
			,p.ProjectNumber
			,ta.TaskID
			,ca.CampaignID
			,cl.ClassID
			,glc.GLCompanyName
			,o.OfficeName
			,ISNULL(po.LineCount,0) as LineCount
		FROM tMediaEstimate me (nolock)
			inner join tCompany c (nolock) on me.ClientKey = c.CompanyKey
			left outer join tProject p (nolock) on me.ProjectKey = p.ProjectKey
			left outer join tGLCompany glc (nolock) on me.GLCompanyKey = glc.GLCompanyKey
			left outer join tOffice o (nolock) on me.OfficeKey = o.OfficeKey
			left outer join tTask ta (nolock) on me.TaskKey = ta.TaskKey
			left outer join tCampaign ca (nolock) on me.CampaignKey = ca.CampaignKey
			left outer join tClass cl (nolock) on me.ClassKey = cl.ClassKey
			left outer join 
				(Select po.MediaEstimateKey, Count(*) as LineCount
				From tPurchaseOrder po (nolock) 
				Group By MediaEstimateKey) as po on po.MediaEstimateKey = me.MediaEstimateKey			
		WHERE
			me.MediaEstimateKey = @MediaEstimateKey

	RETURN 1
GO
