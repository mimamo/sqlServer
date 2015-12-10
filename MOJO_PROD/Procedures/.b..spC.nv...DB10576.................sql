USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10576]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10576]
AS
	SET NOCOUNT ON 

	UPDATE	tPreference
	SET		IntNumPrefix = 'INT',
			IntNumPlaces = 5
	
	-- reload PTotalCost (Project Cost) because of problems on some servers
	update tPurchaseOrderDetail
	set    PTotalCost = TotalCost
		  ,PAppliedCost = AppliedCost

	update tVoucherDetail
	set    PTotalCost = TotalCost

	update tExpenseReceipt
	set    PTotalCost = ActualCost

	update tTime
	Set    HCostRate = CostRate

-- fix the applied cost
declare @PODKey int
select @PODKey = -1
while (1=1)
begin
	select @PODKey = min(vd.PurchaseOrderDetailKey)
	from tVoucherDetail vd (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
	where pod.TotalCost is not null and vd.TotalCost is not null and pod.AppliedCost is null
	and vd.PurchaseOrderDetailKey > @PODKey
	
	if @PODKey is null
		break
		
	exec sptPurchaseOrderDetailUpdateAppliedCost @PODKey
	
end

-- Update tMediaDays new days columns
-- Changed from Daypart to Days
	update tMediaDays
	set Monday = isnull(Monday,0)
		,Tuesday = isnull(Tuesday,0)
		,Wednesday = isnull(Wednesday,0)
		,Thursday = isnull(Thursday,0)
		,Friday = isnull(Friday,0)
		,Saturday = isnull(Saturday,0)
		,Sunday = isnull(Sunday,0)
	

	RETURN
GO
