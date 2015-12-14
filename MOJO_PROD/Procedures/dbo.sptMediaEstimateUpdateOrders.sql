USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaEstimateUpdateOrders]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaEstimateUpdateOrders]

	(
		@MediaEstimateKey int
	)

AS --Encrypt

  /*
  || When     Who Rel      What
  || 01/21/10 GHL 10.517   (72848) Allowing now more flexibility in the update of the orders 
  ||                       Also added project rollup when the project is changed
  || 02/26/13 GHL 10.565   (165725) Added updates of IOBillAt and BCBillAt
  */
  
if isnull(@MediaEstimateKey, 0) = 0
	return 1
	
Declare @FlightStartDate smalldatetime, @FlightEndDate smalldatetime
Declare @CompanyKey int, @ProjectKey int, @TaskKey int, @OfficeKey int
Declare @IOOrderDisplayMode smallint, @BCOrderDisplayMode smallint
Declare @IOBillAt smallint, @BCBillAt smallint

select @FlightStartDate = FlightStartDate
      ,@FlightEndDate = FlightEndDate
      ,@CompanyKey = CompanyKey
      ,@ProjectKey = ProjectKey
	  ,@TaskKey = TaskKey
	  ,@OfficeKey = OfficeKey
	  ,@IOOrderDisplayMode = IOOrderDisplayMode
	  ,@BCOrderDisplayMode = BCOrderDisplayMode
	  ,@IOBillAt = isnull(IOBillAt, 0)
	  ,@BCBillAt = isnull(BCBillAt, 0)
  from tMediaEstimate (nolock)
 where MediaEstimateKey = @MediaEstimateKey
 
If isnull(@ProjectKey, 0) > 0
begin
	if @TaskKey = 0
	    select @TaskKey = null
	    
    update tPurchaseOrder 
    set    ProjectKey = @ProjectKey
          ,TaskKey = @TaskKey
    where  CompanyKey = @CompanyKey  -- use an index
    and    MediaEstimateKey = @MediaEstimateKey

	create table #projects(ProjectKey int null)
    
	-- must be done before update
	insert #projects (ProjectKey)
	select isnull(pod.ProjectKey, 0) 
	from   tPurchaseOrder po (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
	Where  po.CompanyKey = @CompanyKey
	And    po.MediaEstimateKey = @MediaEstimateKey
	And    pod.InvoiceLineKey is null 
	And    ISNULL(pod.AppliedCost, 0) = 0 
	And    ISNULL(pod.AmountBilled, 0) = 0
       
    Update tPurchaseOrderDetail
	Set    ProjectKey = @ProjectKey
	      ,TaskKey = @TaskKey
    From   tPurchaseOrder po (nolock)
	Where  po.CompanyKey = @CompanyKey
	And    po.MediaEstimateKey = @MediaEstimateKey
	And    po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey 
	And    tPurchaseOrderDetail.InvoiceLineKey is null 
	And    ISNULL(tPurchaseOrderDetail.AppliedCost, 0) = 0 
	And    ISNULL(tPurchaseOrderDetail.AmountBilled, 0) = 0
	
	if not exists (select 1 from #projects where ProjectKey = @ProjectKey) 
		insert #projects (ProjectKey) values (@ProjectKey)

	if (select count(*) from #projects) > 1
	begin	
		select @ProjectKey = 0
		while (1=1)
		begin
			select @ProjectKey = min(ProjectKey)
			from   #projects
			where  ProjectKey > @ProjectKey
			
			if @ProjectKey is null
				break
			
			-- project rollup, 5 indicates PO	
			exec sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1	
		end
	end
	
end

If @OfficeKey is not null
begin
    Update tPurchaseOrderDetail
	Set    OfficeKey = @OfficeKey
	From   tPurchaseOrder po (nolock)
	Where  po.CompanyKey = @CompanyKey
	And    po.MediaEstimateKey = @MediaEstimateKey
	And    po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey 
	And    tPurchaseOrderDetail.InvoiceLineKey is null 
	And    ISNULL(tPurchaseOrderDetail.AppliedCost, 0) = 0 
	And    ISNULL(tPurchaseOrderDetail.AmountBilled, 0) = 0

end
    
Update tPurchaseOrder
Set    OrderDisplayMode = case when POKind = 1 then @IOOrderDisplayMode else @BCOrderDisplayMode end 
Where  CompanyKey = @CompanyKey
And    MediaEstimateKey = @MediaEstimateKey and POKind in  (1, 2)

Update tPurchaseOrder
Set    BillAt = case when POKind = 1 then @IOBillAt else @BCBillAt end 
Where  CompanyKey = @CompanyKey
And    MediaEstimateKey = @MediaEstimateKey and POKind in  (1, 2)
And    not exists (select 1 from tPurchaseOrderDetail pod (nolock) where tPurchaseOrder.PurchaseOrderKey = pod.PurchaseOrderKey
					And pod.InvoiceLineKey > 0
)
  
-- verify there are no broadcast media orders with detail lines before or after the estimate flight start and end dates	
if isnull((select isnull(count(*),0) 
             from tPurchaseOrderDetail pod (nolock) 
             inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
            where po.MediaEstimateKey = @MediaEstimateKey
              and po.CompanyKey = @CompanyKey
              and po.POKind = 2
              and (pod.DetailOrderDate < @FlightStartDate or pod.DetailOrderEndDate > @FlightEndDate)),0) > 0
	return -1 
	
	
Update tPurchaseOrder
Set
	FlightStartDate = @FlightStartDate,
	FlightEndDate = @FlightEndDate
Where
	CompanyKey = @CompanyKey and MediaEstimateKey = @MediaEstimateKey and POKind = 2
	
return 1
GO
