USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMiscCostDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMiscCostDelete]
	@MiscCostKey int

AS --Encrypt

  /*
  || When     Who Rel    What
  || 02/15/07 GHL 8.4    Added project rollup section
  || 11/16/11 MFT 10.550 Added check (-2) for WIP post
  || 01/04/12 GHL 10.551 (130427) Added check in tBillingDetail
  || 02/14/12 GHL 10.552 (134402) Removed check of InvoiceLineKey = 0 before checking @WIPPostingInKey
  ||                     i.e. error out if @WIPPostingInKey > 0 regardless of ILK
  */

DECLARE @InvoiceLineKey int
DECLARE @WIPPostingInKey int
DECLARE @WIPPostingOutKey int

SELECT
	@InvoiceLineKey = InvoiceLineKey,
	@WIPPostingInKey = WIPPostingInKey,
	@WIPPostingOutKey = WIPPostingOutKey
FROM tMiscCost (nolock)
WHERE MiscCostKey = @MiscCostKey

IF ISNULL(@InvoiceLineKey, 0) > 0
	RETURN -1

IF ISNULL(@WIPPostingInKey, 0) > 0
	RETURN -2

if exists (select 1 from tBillingDetail bd (nolock)
	inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
	where bd.Entity = 'tMiscCost'
	and   bd.EntityKey = @MiscCostKey
	And   b.Status < 5
	) return -3


if exists(Select 1 from tPreference pre (nolock) 
	inner join tProject pro (nolock) on pre.CompanyKey = pro.CompanyKey
	inner join tMiscCost mc (nolock) on mc.ProjectKey = pro.ProjectKey Where mc.MiscCostKey = @MiscCostKey and pre.TrackQuantityOnHand = 1)
BEGIN
	Declare @CurQty decimal(9, 3), @CurItemQty decimal(9, 3), @ItemKey int

	Select @ItemKey = ItemKey, @CurQty = Quantity from tMiscCost (nolock) Where MiscCostKey = @MiscCostKey

	if ISNULL(@ItemKey, 0) > 0
	begin
		Select @CurItemQty = QuantityOnHand from tItem (nolock) Where ItemKey = @ItemKey
		Update tItem Set QuantityOnHand = @CurItemQty + @CurQty Where ItemKey = @ItemKey

	end
END

DECLARE @ProjectKey INT
SELECT @ProjectKey = ProjectKey
FROM   tMiscCost (NOLOCK)
WHERE  MiscCostKey = @MiscCostKey

	DELETE
	FROM tMiscCost
	WHERE
		MiscCostKey = @MiscCostKey 

	DECLARE	@TranType INT,@BaseRollup INT,@Approved INT,@Unbilled INT,@WriteOff INT
	SELECT	@TranType = 2,@BaseRollup = 1,@Approved = 0,@Unbilled = 1,@WriteOff = 1
	EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff

	RETURN 1
GO
