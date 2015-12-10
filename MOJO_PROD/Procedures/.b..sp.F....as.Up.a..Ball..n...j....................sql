USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastUpdateBalloonProject]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastUpdateBalloonProject]
	(
	@ForecastDetailKey int
	,@UserKey int
	,@Probability int
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 11/01/12  GHL 10.561   Created for revenue forecast app
*/

	SET NOCOUNT ON 
	
	update tForecastDetail
	set    Probability = @Probability
	      ,ManualUpdateBy = @UserKey
		  ,ManualUpdateDate = getutcdate() 
	where  ForecastDetailKey = @ForecastDetailKey

	-- if the project is tied to an opportunity, we must update the probability on the opp
	declare @LeadKey int
	
	select @LeadKey = p.LeadKey
	from   tForecastDetail fd (nolock)
		inner join tProject p (nolock) on fd.EntityKey = p.ProjectKey
	where fd.ForecastDetailKey = @ForecastDetailKey
	and   fd.Entity in ('tProject-Approved', 'tProject-Potential')

	if isnull(@LeadKey, 0) > 0
	begin
		update tLead
		set    Probability = @Probability
		where  LeadKey = @LeadKey
	end

	-- Do not regenerate tForecastDetailItem recs...would require modification of sptForecastDetailItemGenerate
	-- Less of a need for approved projects

	RETURN 1
GO
