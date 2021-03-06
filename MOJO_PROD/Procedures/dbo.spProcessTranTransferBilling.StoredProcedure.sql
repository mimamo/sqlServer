USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransferBilling]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransferBilling]
	(
	@WIK int -- WIPPostingInKey of the original initial tran, could be -1
	,@WOK int -- WIPPostingOutKey of the original initial tran
	,@Type varchar(20) -- Initial, Reversal, New
	,@TransferDate datetime
	
	,@ActualHours decimal(24,4) -- Added if logic requires later to set BilledHours = ActualHours
	,@ActualRate money -- Added if logic requires later to set BilledRate = ActualRate
	,@BillableCost money -- Added if logic requires later to set AmountBilled = BillableCost
	
	,@OrigILK int	-- InvoiceLineKey
	,@OrigDB datetime -- DateBilled	
	,@OrigWO int		-- WriteOff
	,@OrigWOReasonKey int -- WriteOff reason
	,@OrigAB money -- AmountBilled
	,@OrigBH decimal(24,4) -- Billed Hours
	,@OrigBR money -- Billed Rate
	
	,@ILK int output	-- InvoiceLineKey
	,@DB datetime output -- DateBilled	
	,@WO int output		-- WriteOff
	,@WOReasonKey int output -- WriteOff reason
	,@AB money output-- AmountBilled
	,@BH decimal(24,4) output -- Billed Hours
	,@BR money output -- Billed Rate
	
	)
AS
	SET NOCOUNT ON
	
/*
|| When     Who Rel    What
|| 09/02/09 GHL 10.5   Creation to support the transfers
*/

/*
1) Usually in the billing routines

When Writing Off 
=================
WriteOff = 1
BilledHours = 0
BilledRate = 0
DateBilled = set

AmountBilled = 0
DateBilled = set

When Marking As Billed 
======================
InvoiceLineKey = 0
WriteOff = 0
BilledHours = ActualHours
BilledRate = ActualRate
DateBilled = set

InvoiceLineKey = 0
WriteOff = 0
AmountBilled = BillableCost
DateBilled = set

2)Here

When Writing Off 
=================
WriteOff = 1
BilledHours = 0
BilledRate = 0
DateBilled = set

AmountBilled = 0
DateBilled = set

When Marking As Billed 
======================
InvoiceLineKey = 0
WriteOff = 0
BilledHours = 0
BilledRate = 0
DateBilled = set

InvoiceLineKey = 0
WriteOff = 0
AmountBilled = 0
DateBilled = set


*/
	select @OrigWO = isnull(@OrigWO, 0)
	
	-- not posted in WIP, not posted out of WIP
	if @WIK = 0 and @WOK = 0 
	begin

		-- initial will be marked as billed as of today
		if @Type = 'Initial'
			select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0, @BH = 0, @BR = 0, @DB = @TransferDate
			
		-- reversals will be marked as billed as of today		
		if @Type = 'Reversal'
			select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate

		-- new will be copied from orig
		if @Type = 'New'
			select @ILK = @OrigILK, @WO = @OrigWO, @WOReasonKey = @OrigWOReasonKey, @AB = @OrigAB
			, @BH = @OrigBH, @BR = @OrigBR, @DB = @OrigDB

		return 1	
	end
	
	-- posted in WIP, not posted out of WIP
	if @WIK <> 0 and @WOK = 0 
	begin
		-- if Marked as Billed
		if @OrigILK = 0
		begin		
			-- no need to change info of initial 
			if @Type = 'Initial'
				select @ILK = @OrigILK, @WO = @OrigWO, @WOReasonKey = @OrigWOReasonKey, @AB = 0
					, @BH = 0, @BR = 0, @DB = @OrigDB
				
			-- reversals will be marked as billed as of the transfer date (does not matter)		
			if @Type = 'Reversal'
				select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate

			-- new will be copied from orig			
			if @Type = 'New'
				select @ILK = @OrigILK, @WO = @OrigWO, @WOReasonKey = @OrigWOReasonKey, @AB = @OrigAB
				, @BH = @OrigBH, @BR = @OrigBR, @DB = @OrigDB
				
			return 1	

		end
		
		-- if Written Off, set the WO to the new transaction!!!!!!!!!!!!
		if @OrigWO = 1
		begin		
			-- reset the WO on initial
			if @Type = 'Initial'
				select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate

			-- reversals will be marked as billed 		
			if @Type = 'Reversal'
				select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate

			-- new will be copied from orig, i.e will have WO = 1			
			if @Type = 'New'
				select @ILK = @OrigILK, @WO = @OrigWO, @WOReasonKey = @OrigWOReasonKey, @AB = @OrigAB
				, @BH = @OrigBH, @BR = @OrigBR, @DB = @OrigDB

			return 1	

		end
		
		
		-- not MB or WO
		
		-- initial will be marked as billed as of today
		if @Type = 'Initial'
			select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate
			
		-- reversals will be marked as billed as of today		
		if @Type = 'Reversal'
			select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate

		-- new will be copied from orig
		if @Type = 'New'
			select @ILK = @OrigILK, @WO = @OrigWO, @WOReasonKey = @OrigWOReasonKey, @AB = @OrigAB
			, @BH = @OrigBH, @BR = @OrigBR, @DB = @OrigDB
		
		return 1
		
	end
	
	-- posted in WIP, posted out of WIP
	if @WIK <> 0 and @WOK <> 0 
	begin
		if @OrigILK = 0 or @OrigWO = 1
		begin
			-- initial 
			if @Type = 'Initial'
				select @ILK = @OrigILK, @WO = @OrigWO, @WOReasonKey = @OrigWOReasonKey, @AB = 0
				, @BH = 0, @BR = 0, @DB = @OrigDB
				
			-- reversals will be marked as billed as of today		
			if @Type = 'Reversal'
				select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate
				
			-- new will be marked as billed as of today	
			if @Type = 'New' 
				select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate

			return 1
		end

		-- not MB not WO
				
		-- initial will be marked as billed as of today
		if @Type = 'Initial'
			select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate
			
		-- reversals will be marked as billed as of today		
		if @Type = 'Reversal'
			select @ILK = 0, @WO = 0, @WOReasonKey = NULL, @AB = 0,  @BH = 0, @BR = 0, @DB = @TransferDate

		-- new will be copied from orig
		if @Type = 'New'
			select @ILK = @OrigILK, @WO = @OrigWO, @WOReasonKey = @OrigWOReasonKey, @AB = @OrigAB
			, @BH = @OrigBH, @BR = @OrigBR, @DB = @OrigDB
				
		return 1					
	end
	
		
	return 1
GO
