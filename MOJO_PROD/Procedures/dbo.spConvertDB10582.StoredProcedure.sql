USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10582]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10582]
AS
	SET NOCOUNT ON

	-- populate the new table tEstimateTaskExpenseOrder from tEstimateTaskExpense
	-- this is now a 1-to-many relationship
	  
	insert tEstimateTaskExpenseOrder (EstimateTaskExpenseKey, PurchaseOrderDetailKey)
	select EstimateTaskExpenseKey, PurchaseOrderDetailKey
	from tEstimateTaskExpense (nolock)
	where  PurchaseOrderDetailKey > 0
	and PurchaseOrderDetailKey not in (select PurchaseOrderDetailKey from tEstimateTaskExpenseOrder (nolock) )
	

	-- Remove any Client Logins from tActivationLog that should not be there
	delete from tActivationLog where ActivationKey in (
		select al.ActivationKey from tActivationLog al (nolock) 
		inner join  tUser u (nolock) on al.UserKey = u.UserKey
		where al.DateDeactivated is null and u.ClientVendorLogin = 1
	)

	RETURN
GO
