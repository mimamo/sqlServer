USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignCopy]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignCopy]
	(
	-- required
	@CopyCampaignKey int
	,@UserKey int
	,@CompanyKey int
	,@ClientKey int
	,@CampaignName varchar(200) 
	-- data entered on UI
	,@CampaignID varchar(50) = null
	,@GLCompanyKey int = null
	,@ClientDivisionKey int = null
	,@CurrencyID varchar(10) = null
	--copy parameters
	,@CopyEstimates int = 0 -- copy project and campaign estimates
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/19/13 GHL 10.570  (181227) Created copy function as enhancement for Strong, LLC
|| 07/25/13 GHL 10.570  Added @ClientDivisionKey because this could be part of a project number
|| 09/16/13 GHL 10.572  (190058) Getting now the Account Manager from the new client rather than the campaign to copy
|| 10/08/13 GHL 10.573  Added currency ID to support multi currencies
*/

	SET NOCOUNT ON

	declare @RetVal int
	declare @DateDiff int
	declare @ContactKey int
	declare @NewCampaignKey int
	declare @NewCustomFieldKey int
	
	-- copy of campaign fields
	declare @Description varchar(4000),
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AEKey int,
	@Active tinyint,
	@CustomFieldKey int,
	@GetActualsBy smallint,
	@LayoutKey int,
	@MultipleSegments tinyint,
	@BillBy smallint,
	@OneLinePer smallint,
	@ClientProductKey int,
	@NextProjectNum int
	
	select @Description = Description,
		@StartDate = StartDate,
		@EndDate = EndDate,
		--@AEKey = AEKey, will be copied from client
		@Active =1 ,
		@CustomFieldKey = CustomFieldKey,
		@GetActualsBy = GetActualsBy,
		@LayoutKey = LayoutKey,
		@MultipleSegments = MultipleSegments,
		@BillBy = BillBy,
		@OneLinePer = OneLinePer,
		@ClientProductKey = null,
		@NextProjectNum = 1
	from  tCampaign (nolock)
	where CampaignKey = @CopyCampaignKey 

	select @DateDiff = 0
	if @StartDate is not null and @EndDate is not null
		select @DateDiff = datediff(d, @StartDate, @EndDate)

	select @StartDate = convert(smalldatetime,(convert(varchar(10), getdate(), 101)), 101)
	if @DateDiff > 0
		select @EndDate = dateadd(d, @DateDiff, @StartDate)
	else
		select @EndDate = null

	select @ContactKey = PrimaryContact 
		  ,@AEKey = AccountManagerKey
	from tCompany (nolock) 
	where CompanyKey = @ClientKey

	if @GLCompanyKey = 0
		select @GLCompanyKey = null
	if @CampaignID = ''
		select @CampaignID = null -- sptCampaignUpdate will try to get a valid campaignID 
	if @ClientDivisionKey = 0
		select @ClientDivisionKey = null

	exec @RetVal = sptCampaignUpdate
			@NewCampaignKey,
			@UserKey,
			@CompanyKey,
			@CampaignID,
			@CampaignName,
			@ClientKey,
			@Description,
			null, --@Objective, -- text field, we will update later
			@StartDate,
			@EndDate,
			@AEKey,
			@Active,
			0, --@CustomFieldKey, -- we will copy later
			@GetActualsBy,
			@LayoutKey,
			@MultipleSegments,
			@BillBy,
			@OneLinePer,
			@ContactKey,
			@GLCompanyKey,
			@ClientDivisionKey,
			@ClientProductKey,
			@NextProjectNum,
			@CurrencyID

	if @RetVal > 0
		select @NewCampaignKey = @RetVal
	else
		return @RetVal
		
	-- get a copy of the custom fields
	IF ISNULL(@CustomFieldKey,0) > 0
		exec spCF_CopyFieldSet @CustomFieldKey, 1, @NewCustomFieldKey output

	-- now update the objective and custom fields
	update tCampaign
	set    tCampaign.Objective = (select c.Objective from tCampaign c (nolock) where c.CampaignKey = @CopyCampaignKey)  
	      ,tCampaign.CustomFieldKey = @NewCustomFieldKey
	where  tCampaign.CampaignKey = @NewCampaignKey
	
	insert tCampaignSegment (CampaignKey, SegmentName, DisplayOrder, ProjectTypeKey)
	select @NewCampaignKey, SegmentName, DisplayOrder, ProjectTypeKey
	from   tCampaignSegment cs (nolock)
	where  cs.CampaignKey = @CopyCampaignKey
	order by cs.DisplayOrder

	declare @CopyEstimateKey int
	declare @NewEstimateKey int
	declare @EstType int

	if @CopyEstimates = 1
	begin
		select @CopyEstimateKey = -1

		while (1=1)
		begin
			select @CopyEstimateKey = min(EstimateKey)
			from   tEstimate (nolock)
			where  CampaignKey = @CopyCampaignKey
			and    EstimateKey > @CopyEstimateKey
		
			if @CopyEstimateKey is null
				break

			select @EstType = EstType from tEstimate (nolock) where EstimateKey = @CopyEstimateKey 
			
			select @NewEstimateKey = null

			exec sptEstimateCopy @CopyEstimateKey, null, @NewCampaignKey, null, 1, @UserKey, @NewEstimateKey output

			-- now if by segment and service, we must change the segments
			if @NewEstimateKey > 0 and @EstType = 5 -- By Segment and Service
			begin
				update tEstimateTaskExpense
				set    tEstimateTaskExpense.CampaignSegmentKey = cs_new.CampaignSegmentKey
				from   tEstimateTaskExpense (nolock)
					  ,tEstimateTaskExpense ete_copy (nolock)
				      ,tCampaignSegment cs_copy (nolock)
				      ,tCampaignSegment cs_new (nolock)
				-- new records
				where  tEstimateTaskExpense.EstimateKey = @NewEstimateKey 
				and    cs_new.CampaignKey = @NewCampaignKey 	
				-- copy records
				and    ete_copy.EstimateKey = @CopyEstimateKey
				and    cs_copy.CampaignKey = @CopyCampaignKey
				and    tEstimateTaskExpense.CampaignSegmentKey = cs_copy.CampaignSegmentKey -- it is still pointing to the old
				-- now establish link bewteen 2 campaign segments
				and    isnull(cs_new.SegmentName,'') = isnull(cs_copy.SegmentName, '')
				and    isnull(cs_new.DisplayOrder, 0) = isnull(cs_copy.DisplayOrder, 0)
				and    isnull(cs_new.ProjectTypeKey, 0) = isnull(cs_copy.ProjectTypeKey, 0)

				update tEstimateTaskLabor
				set    tEstimateTaskLabor.CampaignSegmentKey = cs_new.CampaignSegmentKey
				from   tEstimateTaskLabor
					  ,tEstimateTaskLabor ete_copy (nolock)
				      ,tCampaignSegment cs_copy (nolock)
				      ,tCampaignSegment cs_new (nolock)
				-- new records
				where  tEstimateTaskLabor.EstimateKey = @NewEstimateKey 
				and    cs_new.CampaignKey = @NewCampaignKey 	
				-- copy records
				and    ete_copy.EstimateKey = @CopyEstimateKey
				and    cs_copy.CampaignKey = @CopyCampaignKey
				and    tEstimateTaskLabor.CampaignSegmentKey = cs_copy.CampaignSegmentKey -- it is still pointing to the old
				-- now establish link bewteen 2 campaign segments
				and    isnull(cs_new.SegmentName,'') = isnull(cs_copy.SegmentName, '')
				and    isnull(cs_new.DisplayOrder, 0) = isnull(cs_copy.DisplayOrder, 0)
				and    isnull(cs_new.ProjectTypeKey, 0) = isnull(cs_copy.ProjectTypeKey, 0)

			end
			
		 end -- estimate loop

		 -- now rollup estimates to the campaign
		exec sptEstimateRollupCampaign @NewCampaignKey

	end -- if copy estimates = 1

	RETURN @NewCampaignKey
GO
