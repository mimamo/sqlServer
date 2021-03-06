USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectHasOpenPrebilledOrders]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectHasOpenPrebilledOrders]
	(
		@ProjectKey INT
		,@OpenOrderCheck tinyint = 0
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/19/07 GHL 8.4   Creation for Bug 8611. Users want a warning when closing project with 
  ||                    prebilled open orders
  || 08/29/12 RLB 10559 (152831) Add an optional parm to check for just open orders on a project                   
  */
  
	SET NOCOUNT ON

	IF @OpenOrderCheck = 0
	BEGIN
		IF EXISTS (SELECT 1 
					FROM tPurchaseOrderDetail (NOLOCK)
					WHERE ProjectKey = @ProjectKey
					AND   InvoiceLineKey IS NOT NULL
					AND   Closed = 0)
				
			RETURN 1 
		ELSE
			RETURN 0
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 
					FROM tPurchaseOrderDetail (NOLOCK)
					WHERE ProjectKey = @ProjectKey
					AND   (InvoiceLineKey IS NULL OR InvoiceLineKey > 0)
					AND   Closed = 0)
				
			RETURN 1 
		ELSE
			RETURN 0


	END
GO
