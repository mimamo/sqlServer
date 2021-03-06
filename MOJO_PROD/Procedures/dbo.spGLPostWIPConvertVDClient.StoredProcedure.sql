USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertVDClient]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPConvertVDClient]
	
AS --Encrypt

/* GHL Creation for wip conversion
   10/29/07 Added checking of wippostingoutkey

*/

	SET NOCOUNT ON
		
	DECLARE @CompanyKey INT
			,@VoucherDetailKey INT
			,@LineProjectKey INT
			,@LineItemKey INT
			,@PurchaseOrderDetailKey INT
			,@LineClientKey int
			,@IOClientLink INT
			,@BCClientLink INT
				
	CREATE TABLE #tComp (CompanyKey INT NULL)
	INSERT #tComp 
	SELECT DISTINCT t.CompanyKey
	FROM   tTransaction t (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON t.CompanyKey = c.CompanyKey
	WHERE c.Locked = 0
	AND   c.Active = 1
	AND t.Entity = 'WIP'
		
	/*	
	INSERT #tComp
	SELECT p.CompanyKey
	FROM   tPreference p (NOLOCK)
		INNER JOIN tCompany c (NOLOCK) ON p.CompanyKey = c.CompanyKey
	WHERE  ISNULL(p.TrackWIP, 0) = 1
	AND   c.Locked = 0
	AND   c.Active = 1
	*/
	
	SELECT @CompanyKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CompanyKey = MIN(CompanyKey)
		FROM   #tComp
		WHERE  CompanyKey > @CompanyKey
		
		IF @CompanyKey IS NULL
			BREAK
		
		Select
			@IOClientLink = ISNULL(IOClientLink, 1)
			,@BCClientLink = ISNULL(BCClientLink, 1)
		From
			tPreference (nolock)
		Where
			CompanyKey = @CompanyKey
		
		SELECT @VoucherDetailKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @VoucherDetailKey = MIN(vd.VoucherDetailKey)
			FROM  tVoucher v (nolock)
			INNER JOIN tVoucherDetail vd (nolock) ON vd.VoucherKey = v.VoucherKey 
			WHERE v.CompanyKey = @CompanyKey
			AND  vd.VoucherDetailKey > @VoucherDetailKey
			AND  v.Posted = 0
			AND  isnull(vd.ClientKey, 0) = 0
			AND  isnull(vd.WIPPostingOutKey, 0) = 0
			
			IF @VoucherDetailKey IS NULL
				BREAK
				
		Select @LineProjectKey = ProjectKey
			, @LineItemKey = ItemKey
			, @PurchaseOrderDetailKey = ISNULL(PurchaseOrderDetailKey, 0)	
		From tVoucherDetail (nolock)
		Where VoucherDetailKey = @VoucherDetailKey
			 	
		select @LineClientKey = null
			 	
		EXEC sptVoucherDetailFindClient @LineProjectKey, @LineItemKey, @PurchaseOrderDetailKey, @IOClientLink ,@BCClientLink 
			,@LineClientKey output	

		if isnull(@LineClientKey, 0) > 0
			Update tVoucherDetail Set ClientKey = @LineClientKey Where VoucherDetailKey = @VoucherDetailKey 
	
				
		END
					
	
	END	
	

	RETURN 1
GO
