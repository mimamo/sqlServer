USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastUpdate]
	@ForecastKey int,
	@CompanyKey int,
	@ForecastName varchar(200),
	@GLCompanyKey int,
	@StartMonth int,
	@StartYear int,
	@SpreadExpense smallint,
	@CreatedBy int
AS

/*
|| When      Who Rel      What
|| 8/22/12   CRG 10.5.5.9 Created
|| 10/30/12  GHL 10.5.6.1 Added logic when changing SpreadExpense
|| 10/31/12  GHL 10.5.6.1 Added items when changing SpreadExpense
|| 11/16/12  GHL 10.5.6.2 Setting now RecalcNeeded when changing the spread
|| 12/14/12  GHL 10.5.6.3 Added Exclude spread
*/

	declare @kSpreadExpenseFromStart int		select @kSpreadExpenseFromStart = 0
	declare @kSpreadExpenseToEnd int			select @kSpreadExpenseToEnd = 1
	declare @kSpreadExpenseEvenly int			select @kSpreadExpenseEvenly = 2
	declare @kSpreadExpenseExclude int			select @kSpreadExpenseExclude = 3

	declare @OldSpreadExpense int
	declare @ForecastDetailKey int

	IF @ForecastKey > 0
	begin
		select @OldSpreadExpense = SpreadExpense
		From   tForecast (nolock)
		where  ForecastKey = @ForecastKey

		UPDATE	tForecast
		SET		ForecastName = @ForecastName,
				GLCompanyKey = @GLCompanyKey,
				StartMonth = @StartMonth,
				StartYear = @StartYear,
				SpreadExpense = @SpreadExpense
		WHERE	ForecastKey = @ForecastKey

		if @OldSpreadExpense <> @SpreadExpense
		begin

			-- if the new spread is Exclude, we must delete expenses
			if @SpreadExpense = @kSpreadExpenseExclude
			begin
				delete tForecastDetailItem 
				from   tForecastDetail (nolock)
				where  tForecastDetail.ForecastKey = @ForecastKey
				and    tForecastDetail.ForecastDetailKey = tForecastDetailItem.ForecastDetailKey 
				and    tForecastDetailItem.Labor = 0 -- i.e. Expense
				
				delete tForecastDetail 
				where  ForecastKey = @ForecastKey
				and    Entity = 'tItem'

				update tForecastDetail
				set    RecalcNeeded = 1
				where  tForecastDetail.ForecastKey = @ForecastKey
			end
			else
			begin
				update tForecastDetail
				set    tForecastDetail.RecalcNeeded = 1
				from   tForecastDetailItem fdi (nolock)
				where  tForecastDetail.ForecastKey = @ForecastKey
				and    tForecastDetail.ForecastDetailKey = fdi.ForecastDetailKey
				and    fdi.Labor = 0 -- i.e. Expense

				-- also flag the item entities, these have no tForecastDetailItem recs
				update tForecastDetail
				set    tForecastDetail.RecalcNeeded = 1
				where  tForecastDetail.ForecastKey = @ForecastKey
				and    tForecastDetail.Entity = 'tItem'
			end
		end
	end
	ELSE
	BEGIN
		INSERT	tForecast
				(CompanyKey,
				ForecastName,
				GLCompanyKey,
				StartMonth,
				StartYear,
				SpreadExpense,
				CreatedBy)
		VALUES	(@CompanyKey,
				@ForecastName,
				@GLCompanyKey,
				@StartMonth,
				@StartYear,
				@SpreadExpense,
				@CreatedBy)

		SELECT	@ForecastKey = @@IDENTITY
	END

	RETURN @ForecastKey
GO
