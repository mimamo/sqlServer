USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailFindClient]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailFindClient]
	(
		@ProjectKey int
		,@ItemKey int
		,@PurchaseOrderDetailKey int
		,@IOClientLink int
		,@BCClientLink int
		,@ClientKey int output		
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 4/03/07  GHL 8.41  Creation mostly for wip posting and null client problems
*/

	SET NOCOUNT ON
	
	-- ClientLink: 1 via Project, 2 via Media Estimate
	Declare @CompanyKey int, @POKind int, @MediaEstimateKey int, @PODProjectKey int

	if isnull(@PurchaseOrderDetailKey, 0) > 0
			begin
				Select @POKind = po.POKind
						,@MediaEstimateKey = po.MediaEstimateKey
						,@PODProjectKey = pod.ProjectKey
				From tPurchaseOrderDetail pod (nolock)
					Inner Join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				Where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				
				-- regular po
				If @POKind not in (1, 2)
				begin
					if isnull(@ProjectKey, 0) > 0
						Select @ClientKey = ClientKey From tProject (NOLOCK) Where ProjectKey = @ProjectKey 
					else	
						Select @ClientKey = ClientKey From tProject (NOLOCK) Where ProjectKey = @PODProjectKey 
				end
				
				-- io
				If @POKind = 1
				begin
					If @IOClientLink = 1
						if isnull(@ProjectKey, 0) > 0
							Select @ClientKey = ClientKey From tProject (NOLOCK) Where ProjectKey = @ProjectKey 
						else	
							Select @ClientKey = ClientKey From tProject (NOLOCK) Where ProjectKey = @PODProjectKey 
					else
						Select @ClientKey = ClientKey From tMediaEstimate (NOLOCK) Where MediaEstimateKey = @MediaEstimateKey
				end
				
				-- bc
				If @POKind = 2
				begin
					If @BCClientLink = 1
						if isnull(@ProjectKey, 0) > 0
							Select @ClientKey = ClientKey From tProject (NOLOCK) Where ProjectKey = @ProjectKey 
						else	
							Select @ClientKey = ClientKey From tProject (NOLOCK) Where ProjectKey = @PODProjectKey 
					else
						Select @ClientKey = ClientKey From tMediaEstimate (NOLOCK) Where MediaEstimateKey = @MediaEstimateKey
				end
				
			end	
			else
			begin
			
				-- no po
				-- Determine POKind from item
				if isnull(@ItemKey,0) > 0 
				begin
					Select @POKind = ItemType 
					From tItem (nolock)
					Where ItemKey = @ItemKey
				end		

				Select @POKind = isnull(@POKind, 0) -- by default regular po
								
				-- regular po				
				if @POKind not in (1, 2)
				begin
					if isnull(@ProjectKey, 0) > 0
						select @ClientKey = ClientKey From tProject (nolock) Where ProjectKey = @ProjectKey
				end
				
				-- io
				if @POKind = 1
				begin
					if @IOClientLink = 1 and isnull(@ProjectKey, 0) > 0
						select @ClientKey = ClientKey From tProject (nolock) Where ProjectKey = @ProjectKey
				end
				
				-- bc
				if @POKind = 2
				begin
					if @BCClientLink = 1 and isnull(@ProjectKey, 0) > 0
						select @ClientKey = ClientKey From tProject (nolock) Where ProjectKey = @ProjectKey
				end
				
		end -- pod key > 0
	
	
	RETURN 1
GO
