USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskLaborInsertTemp]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskLaborInsertTemp]
	@EstimateKey int,
	@EstType int,
	@TaskKey int,
	@ServiceKey int,
	@UserKey int,
	@CampaignSegmentKey int,
	@Hours decimal(24,4),
	@Rate money,
	@Cost money,
	@Comments text = null,
	@TitleKey int = null
AS --Encrypt


/*
|| When     Who Rel       What
|| 02/05/10 GHL 10.518  Creation for flash screen
|| 11/11/10 GHL 10.538  (92351) Added Comments param
|| 06/01/12 GHL 10.556  (144282) Added update of field Cost (users can modify on UI now)
|| 03/04/15 GHL 10.590   Added titles for Abelson/Taylor
*/

declare @kByTaskOnly int            select @kByTaskOnly = 1
declare @kByTaskService int         select @kByTaskService = 2
declare @kByTaskPerson int          select @kByTaskPerson = 3
declare @kByServiceOnly int         select @kByServiceOnly = 4
declare @kBySegmentService int      select @kBySegmentService = 5
declare @kByProjectOnly int		    select @kByProjectOnly = 6
declare @kByTitleOnly int			select @kByTitleOnly = 7
declare @kBySegmentTitle int		select @kBySegmentTitle = 8

if @TaskKey = 0				select @TaskKey = null
if @UserKey = 0				select @UserKey = null
if @ServiceKey = 0			select @ServiceKey = null
if @CampaignSegmentKey = 0	select @CampaignSegmentKey = null
if @TitleKey = 0			select @TitleKey = null


if @EstType = @kByTaskService
begin
	if exists (select 1 from #tEstimateTaskLabor where isnull(TaskKey, 0) = isnull(@TaskKey, 0) 
				and isnull(ServiceKey, 0) = isnull(@ServiceKey, 0)) 
		return 1
		
	insert #tEstimateTaskLabor
		(
		--EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		Hours,
		Rate,
		Cost,
		UpdateFlag,
		Comments
		)
	VALUES
		(
		--@EstimateKey,
		@TaskKey,
		@ServiceKey,
		NULL,
		NULL,
		@Hours,
		@Rate,
		@Cost,
		0, 
		@Comments
		)	
end

if @EstType = @kByServiceOnly
begin
	if exists (select 1 from #tEstimateTaskLabor where isnull(ServiceKey, 0) = isnull(@ServiceKey, 0)) 
		return 1
		
	insert #tEstimateTaskLabor
		(
		--EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		Hours,
		Rate,
		Cost,
		UpdateFlag,
		Comments
		)
	VALUES
		(
		--@EstimateKey,
		NULL,
		@ServiceKey,
		NULL,
		NULL,
		@Hours,
		@Rate,
		@Cost,
		0, 
		@Comments
		)	

end

if @EstType = @kByTitleOnly
begin
	if exists (select 1 from #tEstimateTaskLabor where isnull(TitleKey, 0) = isnull(@TitleKey, 0)) 
		return 1
		
	insert #tEstimateTaskLabor
		(
		--EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		Hours,
		Rate,
		Cost,
		UpdateFlag,
		Comments,
		TitleKey
		)
	VALUES
		(
		--@EstimateKey,
		NULL,
		@ServiceKey,
		NULL,
		NULL,
		@Hours,
		@Rate,
		@Cost,
		0, 
		@Comments,
		@TitleKey
		)	

end


if @EstType = @kByTaskPerson
begin
	if exists (select 1 from #tEstimateTaskLabor where isnull(TaskKey, 0) = isnull(@TaskKey, 0) 
				and isnull(UserKey, 0) = isnull(@UserKey, 0)) 
		return 1

	insert #tEstimateTaskLabor
		(
		--EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		Hours,
		Rate,
		Cost,
		UpdateFlag,
		Comments
		)
	VALUES
		(
		--@EstimateKey,
		@TaskKey,
		NULL,
		@UserKey,
		NULL,
		@Hours,
		@Rate,
		@Cost,
		0, 
		@Comments
		)	

end

if @EstType = @kBySegmentService
begin
	if exists (select 1 from #tEstimateTaskLabor where isnull(CampaignSegmentKey, 0) = isnull(@CampaignSegmentKey, 0) 
				and isnull(ServiceKey, 0) = isnull(@ServiceKey, 0)) 
		return 1

	insert #tEstimateTaskLabor
		(
		--EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		Hours,
		Rate,
		Cost,
		UpdateFlag,
		Comments
		)
	VALUES
		(
		--@EstimateKey,
		NULL,
		@ServiceKey,
		NULL,
		@CampaignSegmentKey,
		@Hours,
		@Rate,
		@Cost, 
		0,
		@Comments
		)	

end

if @EstType = @kBySegmentTitle
begin
	if exists (select 1 from #tEstimateTaskLabor where isnull(CampaignSegmentKey, 0) = isnull(@CampaignSegmentKey, 0) 
				and isnull(TitleKey, 0) = isnull(@TitleKey, 0)) 
		return 1

	insert #tEstimateTaskLabor
		(
		--EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		TitleKey,
		CampaignSegmentKey,
		Hours,
		Rate,
		Cost,
		UpdateFlag,
		Comments
		)
	VALUES
		(
		--@EstimateKey,
		NULL,
		NULL,
		NULL,
		@TitleKey,
		@CampaignSegmentKey,
		@Hours,
		@Rate,
		@Cost, 
		0,
		@Comments
		)	

end


return 1
GO
