USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerGetAmount]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerGetAmount]
	(
		@RetainerKey INT
	    ,@InvoiceDate DATETIME
	    ,@RetainerAmount MONEY OUTPUT
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/15/08 GHL 10.006 And GWG and RB. Corrected @NumberOfPeriodsBilled       
  || 09/15/08 GHL 10.008 (34396) Number of periods billed was incorrect 
  ||                     when users enter fixed fee manually
  || 10/02/08 GHL 10.010 (36622) Basing now decision to bill retainer upon LastBillingDate only 
  ||                     and not the number of invoices per period since Hawse Design keeps on
  ||                     entering fixed fee invoices for the current period
  || 
  ||                     tRetainer.LastBillingDate is set by:
  ||                     1) mass billing: spMassBillingBillRetainer --> spProcessWIPWorksheetRetainer
  ||                     2) billing WS:   spBillingInvoiceBill	    --> spBillingInvoiceRetainer  
  ||                     OR on the retainer detail 
  || 01/02/09 GHL 10.015 (43190) In the case of Yearly frequency, consider LastBillingDate + 1 year
  ||                     instead of LastBillingDate + 1 year then January 1st for that year
  || 08/28/09 GHL 10.5   (60241) Return now -1 when not the time to bill, we allow now for 0 amount
  || 01/22/10 GHL 10.517 (69011) Using now the stored procedure return to determine whether it is
  ||                      time to bill or not since we can now have retainer amounts <0, =0, >0
  ||                      1 -- Can Bill
  ||                      0 -- Cannot Bill
  || 10/06/11 GHL 10.549 (122952) when StartDate = 10/13/2010, EndDate should be 10/13/2011 not 10/1/2011
  ||                     Removed change of 10/13/2011 to 10/1/2011
  */
  

	SET NOCOUNT ON
	
	DECLARE @kCAN_BILL INT SELECT @kCAN_BILL = 1
	DECLARE @kCANNOT_BILL INT SELECT @kCANNOT_BILL = 0
	
	DECLARE @CompanyKey INT
			,@NumberOfPeriods INT		-- If 0 means infinite
			,@NumberOfPeriodsBilled INT
			,@Frequency SMALLINT		-- 1: monthly, 2: quaterly, 3: yearly
			,@LastBillingDate DATETIME
			,@StartDate DATETIME
			,@NextBillingDate DATETIME
			,@NextEndBillingDate DATETIME
			,@EndDate DATETIME -- This will be the final billing date + 1 day. We will abort if @InvoiceDate >= @EndDate
			
		SELECT @CompanyKey = CompanyKey
			   ,@NumberOfPeriods = NumberOfPeriods
			   ,@RetainerAmount = AmountPerPeriod
			   ,@Frequency = Frequency
			   ,@LastBillingDate = LastBillingDate
			   ,@StartDate = StartDate
		FROM   tRetainer (NOLOCK) 
		WHERE  RetainerKey = @RetainerKey
			
		-- Abort if the invoice date is before the start	
		IF @InvoiceDate < @StartDate
			RETURN @kCANNOT_BILL
		
		-- Calculate the end date, if number of periods > 0 (number of periods = 0, we allow invoice)
		IF @NumberOfPeriods > 0
		BEGIN
		
			IF @Frequency = 1
			BEGIN
				SELECT @EndDate = DATEADD(m, @NumberOfPeriods, @StartDate) 
				--SELECT @EndDate = CAST(DATEPART(m, @EndDate) AS VARCHAR(2)) + '/1/'+CAST(DATEPART(yy, @EndDate) AS VARCHAR(4))  
			END
			
			IF @Frequency = 2
			BEGIN
				SELECT @EndDate = DATEADD(m, 3 * @NumberOfPeriods, @StartDate) -- Add 3 months * # of periods
				SELECT @EndDate = CAST(DATEPART(m, @EndDate) AS VARCHAR(2)) + '/1/'+CAST(DATEPART(yy, @EndDate) AS VARCHAR(4))  
				
			END
			
			IF @Frequency = 3
			BEGIN
				SELECT @EndDate = DATEADD(yy, @NumberOfPeriods, @StartDate) -- Add 1 year * # of periods
				SELECT @EndDate =  '1/1/'+CAST(DATEPART(yy, @EndDate) AS VARCHAR(4))  
			END
			
			-- Abort, if the invoice date is after or ON the end date of the last period	
			IF @InvoiceDate >= @EndDate
				RETURN @kCANNOT_BILL
		
		END

		IF @LastBillingDate IS NOT NULL
		BEGIN
			IF @Frequency = 1
			BEGIN
				-- Add a month
				SELECT @NextBillingDate = DATEADD(m, 1, @LastBillingDate)
				-- Any invoice date after or on the first of the MONTH will be fine
				SELECT @NextBillingDate = CAST(DATEPART(m, @NextBillingDate) AS VARCHAR(2)) + '/1/'+CAST(DATEPART(yy, @NextBillingDate) AS VARCHAR(4))  
				SELECT @NextEndBillingDate = DATEADD(m, 1,@NextBillingDate)
				SELECT @NextEndBillingDate = DATEADD(d, -1,@NextEndBillingDate)
			END
			IF @Frequency = 2
			BEGIN
				-- Add a quarter or 3 months
				SELECT @NextBillingDate = DATEADD(m, 3, @LastBillingDate)
				-- Any invoice date after or on the first of the MONTH will be fine
				SELECT @NextBillingDate = CAST(DATEPART(m, @NextBillingDate) AS VARCHAR(2)) + '/1/'+CAST(DATEPART(yy, @NextBillingDate) AS VARCHAR(4))  
				SELECT @NextEndBillingDate = DATEADD(m, 3,@NextBillingDate)
				SELECT @NextEndBillingDate = DATEADD(d, -1,@NextEndBillingDate)
			END
			IF @Frequency = 3
			BEGIN
				-- Add a year
				SELECT @NextBillingDate = DATEADD(yy, 1, @LastBillingDate)
				-- Any invoice date after or on the first of the YEAR  will be fine
				--SELECT @NextBillingDate = '1/1/'+CAST(DATEPART(yy, @NextBillingDate) AS VARCHAR(4))  
				SELECT @NextEndBillingDate = '12/31/'+CAST(DATEPART(yy, @NextBillingDate) AS VARCHAR(4))  
			
			END
			
			-- Do not create if not in range
			IF @InvoiceDate < @NextBillingDate
				RETURN @kCANNOT_BILL 
			
		END	
		
		RETURN @kCAN_BILL
GO
