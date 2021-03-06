USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceGetListForEstimate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptServiceGetListForEstimate]

	(
		@CompanyKey int,
		@EstimateKey int
	)

AS --Encrypt

		-- Rate is now stored in tEstimateService
		
		Select 
			s.ServiceKey,
			s.ServiceCode,
			s.Description,
			ISNULL(es.Rate, 0) as HourlyRate
		from 
			tService s (nolock)
			INNER JOIN tEstimateService es (nolock) on s.ServiceKey = es.ServiceKey
		Where
			es.EstimateKey = @EstimateKey
		Order By 
			s.ServiceCode
GO
