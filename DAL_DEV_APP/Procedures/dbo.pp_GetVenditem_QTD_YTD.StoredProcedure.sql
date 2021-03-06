USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_GetVenditem_QTD_YTD]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[pp_GetVenditem_QTD_YTD]  
	@InvtID			varchar(30),
	@SiteID			varchar(10),
	@VendID			varchar(15),
	@AlternateID		varchar(30),
	@CurrPeriod 		varchar(6),
	@NbrPerYear    		Int        OUTPUT,
	@NbrPerQtr		Int        OUTPUT,
	@PTDLeadTime		Int        OUTPUT,
	@PTDAvgCost		Float      OUTPUT,
	@YTDLeadTime		Int        OUTPUT,
	@YTDAvgCost		Float      OUTPUT
	
As
	SET NOCOUNT ON	

	DECLARE @year Int
	DECLARE @month Int
        DECLARE @QtrBegPeriod varchar(6)
	DECLARE @YearBegPeriod varchar(6)
	
	Declare @StartYear  		varchar(4)
	Declare @EndYear    		varchar(4)
	Declare @NbrPer			smallint
	Declare @PerStr			varchar(2)
	Declare @NumTemp		smallint
	
	Set @Year = Convert(Int,Substring(@CurrPeriod,1,4))
	Set @Month = Convert(Int,Substring(@CurrPeriod,5,2))
	SELECT @NbrPerYear=NbrPer FROM glsetup (NOLOCK)
	SET @NbrPerQtr = Round(@NbrPerYear/4,0)
	If @NbrPerQtr -1 > @Month
	   SET @QtrBegPeriod=CONVERT(CHAR(4),@Year-1)+ Right('0'+ Convert(VarChar(2),@month+(@NbrPerYear-@NbrPerQtr)),2)
	Else 
	   SET @QtrBegPeriod=CONVERT(CHAR(4),@Year)+ Right('0'+ Convert(VarChar(2),@month-(@NbrPerQtr-1)),2)
	If @Month = @NbrPerYear-1
        	SET @YearBegPeriod = CONVERT(CHAR(4),@Year)+ '00'
        Else
		SET @YearBegPeriod = CONVERT(CHAR(4),@Year-1)+ Right('0'+ Convert(VarChar(2),@month+1),2)
	-- Create the VendItemTemp table.
	Create Table #VendItemTemp 
		(Period 		char(6),
		PTDLeadTime 		float,
		PTDCostRcvd 		float,
		PTDQtyRcvd 		float
		)
	
	-- Get the Start and End year for selection.
	select @StartYear = Left(@YearBegPeriod, 4)
	select @EndYear = Left(@CurrPeriod, 4)

	select @NbrPerYear = NbrPer from GLSetup

	-- Iterate through each period up until GLSetup.NbrPer and
	-- get each value for the Qty Sold from VendItem.
	Select @NumTemp = 1
	While @NumTemp >= 1 and @NumTemp <= @NbrPerYear
	Begin
	
		If @NumTemp < 10
			select @PerStr = '0' + convert(varchar(2), @NumTemp)
		Else
			select @PerStr = convert(varchar(2), @NumTemp)
	
		Insert 	Into #VendItemTemp 
		Select 	FiscYr + @PerStr Period, 
			Case @NumTemp 
				When 1 Then PTDLeadTime00
				When 2 Then PTDLeadTime01
				When 3 Then PTDLeadTime02
				When 4 Then PTDLeadTime03
				When 5 Then PTDLeadTime04
				When 6 Then PTDLeadTime05
				When 7 Then PTDLeadTime06
				When 8 Then PTDLeadTime07
				When 9 Then PTDLeadTime08
				When 10 Then PTDLeadTime09
				When 11 Then PTDLeadTime10
				When 12 Then PTDLeadTime11
				When 13 Then PTDLeadTime12
			end,
			Case @NumTemp 
				When 1 Then PTDCostRcvd00
				When 2 Then PTDCostRcvd01
				When 3 Then PTDCostRcvd02
				When 4 Then PTDCostRcvd03
				When 5 Then PTDCostRcvd04
				When 6 Then PTDCostRcvd05
				When 7 Then PTDCostRcvd06
				When 8 Then PTDCostRcvd07
				When 9 Then PTDCostRcvd08
				When 10 Then PTDCostRcvd09
				When 11 Then PTDCostRcvd10
				When 12 Then PTDCostRcvd11
				When 13 Then PTDCostRcvd12
			end,
			Case @NumTemp 
				When 1 Then PTDQtyRcvd00
				When 2 Then PTDQtyRcvd01
				When 3 Then PTDQtyRcvd02
				When 4 Then PTDQtyRcvd03
				When 5 Then PTDQtyRcvd04
				When 6 Then PTDQtyRcvd05
				When 7 Then PTDQtyRcvd06
				When 8 Then PTDQtyRcvd07
				When 9 Then PTDQtyRcvd08
				When 10 Then PTDQtyRcvd09
				When 11 Then PTDQtyRcvd10
				When 12 Then PTDQtyRcvd11
				When 13 Then PTDQtyRcvd12
			end

		From 	VendItem 
		Where 	InvtID = @InvtID
		  and	SiteID = @SiteID
		  and	VendID = @VendID
		  and	AlternateID = @AlternateID
		  and	FiscYr between @StartYear and @EndYear

		select @NumTemp = @NumTemp + 1
	end
		
	select	@PTDLeadTime = Sum(PTDLeadTime),
		@PTDAvgCost = CASE WHEN Sum(PTDQtyRcvd) <> 0 
		THEN Sum(PTDCostRcvd)/Sum(PTDQtyRcvd) 
		ELSE 0 
		END
	 from #VendItemTemp where Period between @QtrBegPeriod and @CurrPeriod

	select	@YTDLeadTime = Sum(PTDLeadTime),
		@YTDAvgCost = CASE WHEN Sum(PTDQtyRcvd) <> 0 
		THEN Sum(PTDCostRcvd)/Sum(PTDQtyRcvd) 
		ELSE 0 
		END
	 from #VendItemTemp where Period between @YearBegPeriod and @CurrPeriod
GO
