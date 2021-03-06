USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vEstimateClient]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vEstimateClient]
AS
  /*
  || When     Who Rel    What
  || 03/17/10 GHL 10.520 Created to find who the client is
  */
SELECT 	e.EstimateKey
       ,case when e.ProjectKey > 0 then p.ClientKey
             when e.CampaignKey > 0 then c.ClientKey
             when e.LeadKey > 0 then l.ContactCompanyKey
             else p.ClientKey
       end as ClientKey   
FROM	tEstimate e (NOLOCK)
LEFT OUTER JOIN tProject p (nolock) on e.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tCampaign c (nolock) on e.CampaignKey = c.CampaignKey
LEFT OUTER JOIN tLead l (nolock) on e.LeadKey = l.LeadKey
GO
