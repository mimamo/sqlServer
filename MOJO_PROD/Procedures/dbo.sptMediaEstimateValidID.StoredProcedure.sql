USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaEstimateValidID]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaEstimateValidID]

	(
		@CompanyKey int,
		@EstimateID varchar(50)
	)

AS --Encrypt

Declare @MediaEstimateKey int

Select @MediaEstimateKey = MediaEstimateKey
From tMediaEstimate (nolock)
Where
	CompanyKey = @CompanyKey and
	EstimateID = @EstimateID
	
	
Return ISNULL(@MediaEstimateKey, 0)
GO
