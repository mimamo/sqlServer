USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskLaborGetForReportLayout]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskLaborGetForReportLayout]
	@EstimateKey int,
	@TaskKey int
AS --Encrypt

/*
|| When      Who Rel       What
|| 06/02/11  MFT 10.5.4.5  Created for the labor breakout on Estimate layouts
*/

	-- Estimate Types
	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5
	declare @kByProject int			    select @kByProject = 6
	declare @kByTitleOnly int	        select @kByTitleOnly = 7
	declare @kBySegmentTitle int	    select @kBySegmentTitle = 8

DECLARE @LayoutKey int
DECLARE @EstType int

SELECT
	@LayoutKey = LayoutKey,
	@EstType = EstType
FROM tEstimate (nolock)
WHERE EstimateKey = @EstimateKey

SELECT
	s.ServiceKey,
	etl.TaskKey,
	s.Description AS Service,
	etl.CampaignSegmentKey,
	lb.DisplayOption,
	lb.LayoutLevel - 1 AS LayoutLevel,
	lb.LayoutOrder,
	ISNULL(etl.Hours, 0) AS Hours,
	ISNULL(etl.Rate, 0) AS Rate,
	ROUND(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2) AS Gross,
	etl.Cost,
	CASE WHEN Hours * ROUND(Hours * Rate, 2) <> 0 THEN 1 ELSE 0 END AS ShowService,
	CASE s.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable1,
	CASE s.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2,
	etl.Comments,
	etl.UserKey,
	ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS Person,
	CASE @EstType WHEN 3 THEN ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') ELSE s.Description END AS Subject
FROM tEstimateTaskLabor etl (nolock)
	LEFT JOIN tService s (nolock) ON s.ServiceKey = etl.ServiceKey AND ISNULL(etl.Hours, 0) > 0
	LEFT JOIN tLayoutBilling lb (nolock) ON lb.Entity = 'tService' AND lb.EntityKey = s.ServiceKey AND lb.LayoutKey = @LayoutKey
	LEFT JOIN tUser u (nolock) ON etl.UserKey = u.UserKey
WHERE
	etl.TaskKey = @TaskKey AND
	etl.EstimateKey = @EstimateKey
GO
