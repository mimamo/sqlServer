USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetAppList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetAppList]
	(
	@CompanyKey int,
	@Search varchar(100),
	@UserKey int,
	@GetNotSent int,
	@GetApprovedInternally int,
	@GetRecentlyApproved int
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 12/17/14  GHL 10.587   Creation for the new APP estimate dash
||                        Pull estimates entered by the user for any entity, project, campaign, opps
|| 01/19/15  GHL 10.588   Added sorts
*/

	SET NOCOUNT ON

	declare @ApprovedDays int
	select @ApprovedDays = 5

	declare @Today smalldatetime
	select @Today = getdate()
	select @Today = dbo.fFormatDateNoTime(@Today)

	if @GetNotSent = 1
	begin
		select e.EstimateKey, e.EstimateNumber, e.EstimateName, isnull(e.EstDescription, '') as EstDescription
		, e.Entity, e.EntityKey, e.EstimateTotal
		from   vEstimateApproved e (nolock)
		where e.EnteredBy = @UserKey
		and   e.InternalStatus = 1
		order by e.EstimateNumber

		return 1
	end

	if @GetApprovedInternally = 1
	begin
		select e.EstimateKey, e.EstimateNumber, e.EstimateName, isnull(e.EstDescription, '') as EstDescription
		, e.Entity, e.EntityKey, e.EstimateTotal
		from   vEstimateApproved e (nolock)
		where e.EnteredBy = @UserKey
		and   e.InternalStatus = 4
		and   (isnull(e.ExternalApprover, 0) > 0 and e.ExternalStatus < 4)
		order by e.EstimateNumber

		return 1 
	end

	if @GetRecentlyApproved = 1
	begin
		select e.EstimateKey, e.EstimateNumber, e.EstimateName, isnull(e.EstDescription, '') as EstDescription
		, e.Entity, e.EntityKey, e.EstimateTotal
		from   vEstimateApproved e (nolock)
		where e.EnteredBy = @UserKey
		and   e.Approved = 1
		and   datediff(d, e.DateApproved, @Today)  <=  @ApprovedDays
		and   e.DateApproved is not null 
		order by e.DateApproved desc -- most recent at the top
	
		return 1
	end

	select e.EstimateKey, e.EstimateNumber, e.EstimateName, isnull(e.EstDescription, '') as EstDescription
		, e.Entity, e.EntityKey, e.EstimateTotal
	from   vEstimateApproved e (nolock)
	where e.EnteredBy = @UserKey
	and
	--Search criteria
	(
		LOWER(ISNULL(e.EstimateName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		LOWER(ISNULL(e.EstimateNumber, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		ISNULL(e.EstDescription, '') LIKE '%' + ISNULL(@Search, '') + '%' 
	)
	order by e.EstimateNumber

	RETURN
GO
