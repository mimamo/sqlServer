USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastDetailUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastDetailUpdate]
	(
	@ForecastDetailKey int
	,@ForecastKey int
	,@Entity varchar(50)
	,@EntityKey int
	,@AccountManagerKey int
	,@GLCompanyKey int
	,@ClientKey int
	,@OfficeKey int
	,@StartDate smalldatetime
	,@Months int
	,@Probability int
	,@Total money
	,@UserKey int
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/31/12  GHL 10.561  Created for revenue forecast
||                       Primarily to use with item and service entities
|| 11/1/12   GHL 10.561  Added @AccountManagerKey
*/
	SET NOCOUNT ON

	declare @EntityID varchar(50)
	declare @EntityName varchar(200)
	declare @Error int

	select @Months = isnull(@Months, 0)
		  ,@Probability = isnull(@Probability, 100)
		  ,@Total = isnull(@Total, 0)

	if @Entity = 'tItem'
		select @EntityID = ItemID
				,@EntityName = ItemName
		from   tItem (nolock)
		where  ItemKey = @EntityKey
	else
		select @EntityID = ServiceCode
				,@EntityName = Description
		from   tService (nolock)
		where  ServiceKey = @EntityKey

	if @ForecastDetailKey <= 0
	begin
		INSERT	tForecastDetail
			(
			ForecastKey,
			Entity,
			EntityKey,
			StartDate,
			Months,
			Probability,
			Total,
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName,
			EntityID,
			GeneratedBy,
			FromEstimate,
			RecalcNeeded
			)
		SELECT	@ForecastKey,
			@Entity,
			@EntityKey,
			@StartDate,
			@Months,
			@Probability,
			@Total,
			@ClientKey,
			@AccountManagerKey,
			@GLCompanyKey,
			@OfficeKey,
			@EntityName,
			@EntityID,
			@UserKey,
			0,
			0

		select @Error = @@ERROR, @ForecastDetailKey = @@IDENTITY

		if @Error <> 0
			return -1
	end
	else
	begin
	
		update tForecastDetail
		set    ForecastKey = @ForecastKey
			  --,Entity = @Entity
			  ,EntityKey = @EntityKey
			  ,StartDate = @StartDate
			  ,Months = @Months
			  ,Probability = @Probability
			  ,Total = @Total
			  ,ClientKey = @ClientKey
			  ,AccountManagerKey = @AccountManagerKey
			  ,GLCompanyKey = @GLCompanyKey
			  ,OfficeKey = @OfficeKey
			  ,EntityName = @EntityName
			  ,EntityID = @EntityID
			  ,ManualUpdateDate = getutcdate()
			  ,ManualUpdateBy = @UserKey
		where  ForecastDetailKey = @ForecastDetailKey

	end 

	-- now calculate the buckets
	exec sptForecastCalcBuckets @ForecastDetailKey, 0

	RETURN @ForecastDetailKey
GO
