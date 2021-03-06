USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetDD]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetDD]

	@ProjectKey int


AS --Encrypt

	
		SELECT EstimateKey, EstimateName + ' - ' + cast(Revision as varchar(10)) as EstimateFullName
		FROM   tEstimate (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND    ( (ISNULL(ExternalApprover, 0) > 0 AND ExternalStatus = 4) OR
				  (ISNULL(ExternalApprover, 0) = 0 AND InternalStatus = 4)
				)
GO
