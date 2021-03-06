USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataMediaEstimateGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataMediaEstimateGetList]

	(
		@CompanyKey int
	)

AS --Encrypt

Select 
	tMediaEstimate.CompanyKey, 
	MediaEstimateKey,
	ISNULL(tMediaEstimate.LinkID, '0') as LinkID,
	tMediaEstimate.ClientKey,
	EstimateID,
	EstimateName,
	tMediaEstimate.FlightStartDate,
	tMediaEstimate.FlightEndDate,
	ProjectNumber,
	TaskID,
	tCompany.CustomerID as ClientID 
from tMediaEstimate (NOLOCK) 
inner join tCompany (NOLOCK) on tMediaEstimate.ClientKey = tCompany.CompanyKey
left outer join tProject (NOLOCK) on tMediaEstimate.ProjectKey = tProject.ProjectKey
left outer join tTask (NOLOCK) on tMediaEstimate.TaskKey = tTask.TaskKey
Where
	tMediaEstimate.CompanyKey = @CompanyKey
	
Order By EstimateID
GO
