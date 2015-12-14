USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertVDGLAccount2]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spGLPostWIPConvertVDGLAccount2]
(
@CompanyKey int
)

AS --Encrypt

/* GHL Creation for wip conversion
	Clone of spGLPostWIPConvertVDGLAccount
	To fix situation like at WildFire (17067)
*/

	SET NOCOUNT ON

	 	
	DECLARE @VoucherDetailKey INT
			,@VoucherKey INT
			,@ItemKey INT
			,@VendorKey INT
			,@Posted INT
			,@OldExpenseAccountKey INT
			,@NewExpenseAccountKey INT
			,@NewWIPPostingInKey INT
			,@ItemExpenseAccountKey INT
			,@IOClientLink INT
			,@BCClientLink INT
			,@WIPExpenseAssetAccountKey INT
			,@WIPMediaAssetAccountKey INT
			,@ExpenseAcctChanged INT
			,@RetVal int
			
-- Default Expense Keys in following precedence: Item, Vendor, Company
Declare @ItemDefaultExpenseAccountKey int
Declare @VendorDefaultExpenseAccountKey int
Declare @CompanyDefaultExpenseAccountKey int
Declare @CompanyDefaultExpenseAccountFromItem tinyint

			
	CREATE TABLE #tVD(VoucherDetailKey INT NULL, OldExpenseAccountKey INT NULL
		, NewExpenseAccountKey INT NULL, WIPPostingInKey int null)
							
	CREATE TABLE #tComp (CompanyKey INT NULL)
	INSERT #tComp 
	SELECT DISTINCT t.CompanyKey
	FROM   tTransaction t (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON t.CompanyKey = c.CompanyKey
	WHERE c.Locked = 0
	AND   c.Active = 1
	AND t.Entity = 'WIP'
	AND t.CompanyKey = @CompanyKey
		
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
			,@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0)
			,@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0)
			,@CompanyDefaultExpenseAccountKey = ISNULL(DefaultExpenseAccountKey, 0)
		    ,@CompanyDefaultExpenseAccountFromItem = ISNULL(DefaultExpenseAccountFromItem, 0)
		From
			tPreference (nolock)
		Where
			CompanyKey = @CompanyKey
	
		TRUNCATE TABLE #tVD
	
		SELECT @VoucherKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @VoucherKey = MIN(v.VoucherKey)
				FROM  tVoucher v (nolock)
				INNER JOIN tVoucherDetail vd (nolock) ON vd.VoucherKey = v.VoucherKey 
				WHERE v.CompanyKey = @CompanyKey
				AND  v.VoucherKey > @VoucherKey
				AND  isnull(vd.WIPPostingOutKey, 0) = 0
				
				IF @VoucherKey IS NULL
					BREAK
			
				SELECT @Posted = v.Posted, @VendorKey = v.VendorKey				
				FROM  tVoucher v (NOLOCK)
				WHERE v.VoucherKey = @VoucherKey
										
				SELECT @VoucherDetailKey = -1
				WHILE (1=1)
				BEGIN
					SELECT @VoucherDetailKey = MIN(vd.VoucherDetailKey)
					FROM  tVoucherDetail vd (nolock)  
					WHERE vd.VoucherKey = @VoucherKey
					AND  vd.VoucherDetailKey > @VoucherDetailKey
					AND  isnull(vd.WIPPostingOutKey, 0) = 0
					
					IF @VoucherDetailKey IS NULL
						BREAK
						
					SELECT @ItemKey = ISNULL(vd.ItemKey, 0)
							,@OldExpenseAccountKey = vd.ExpenseAccountKey				
					FROM  tVoucherDetail vd (NOLOCK)
					WHERE vd.VoucherDetailKey = @VoucherDetailKey
					
					SELECT @NewExpenseAccountKey = 0
						  ,@NewWIPPostingInKey = 0
						  
					-- If the GL account has been changed to WIP Asset, correct it
					IF @OldExpenseAccountKey IN (@WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
					BEGIN
						-- Old expense acct was WIP account
						IF @Posted = 1
							SELECT @NewWIPPostingInKey = -1
						
						If @CompanyDefaultExpenseAccountFromItem = 1 And @ItemKey > 0
							Select @ItemDefaultExpenseAccountKey = ExpenseAccountKey
							From   tItem (nolock)
							Where  ItemKey = @ItemKey

						Else
							Select @ItemDefaultExpenseAccountKey = 0
					 
			 			-- If not found, set to 0
						Select @ItemDefaultExpenseAccountKey = ISNULL(@ItemDefaultExpenseAccountKey, 0)

						If @ItemDefaultExpenseAccountKey > 0
						BEGIN
							-- Found it
							SELECT @NewExpenseAccountKey = @ItemDefaultExpenseAccountKey 
						END
						ELSE
						BEGIN
							-- Not Found try to get it from vendor
							Select @VendorDefaultExpenseAccountKey = ISNULL(co.DefaultExpenseAccountKey , 0)
							from	tCompany co (nolock)
							where	co.CompanyKey = @VendorKey

			 				-- If not found, set to 0
							Select @VendorDefaultExpenseAccountKey = ISNULL(@VendorDefaultExpenseAccountKey, 0)
						
							If @VendorDefaultExpenseAccountKey > 0
							BEGIN
								-- Found it
								SELECT @NewExpenseAccountKey = @VendorDefaultExpenseAccountKey 
							END
							ELSE
							BEGIN
								-- Not found, try to get it from company
								SELECT @NewExpenseAccountKey = @CompanyDefaultExpenseAccountKey
							END
								
						END -- @ItemDefaultExpenseAccountKey > 0
					  	
			  			SELECT @NewExpenseAccountKey = ISNULL(@NewExpenseAccountKey, 0)
				  		
				  		
					END -- correct wip acct, wrong exp acct
						
					IF @NewExpenseAccountKey = 0
						SELECT @NewExpenseAccountKey = @OldExpenseAccountKey
							
					INSERT #tVD(VoucherDetailKey, OldExpenseAccountKey, NewExpenseAccountKey, WIPPostingInKey)
				  			SELECT @VoucherDetailKey, @OldExpenseAccountKey, @NewExpenseAccountKey, @NewWIPPostingInKey
				  				
				END -- VD loop
					
												
			END -- V Loop
		
		-- just update the ExpenseAccountKey
		UPDATE tVoucherDetail
		SET    tVoucherDetail.ExpenseAccountKey = b.NewExpenseAccountKey 
		FROM   #tVD b
		WHERE  tVoucherDetail.VoucherDetailKey = b.VoucherDetailKey	
				
						

-- To prevent situations like WildFire, where WOK > 0 then they unpost
/*
Update tVoucherDetail
set    tVoucherDetail.WIPPostingInKey = -1
from   tVoucher v (nolock)
	,tPreference pref (nolock)
where  tVoucherDetail.VoucherKey = v.VoucherKey 
and    v.CompanyKey = @CompanyKey
and    v.Posted = 1
and    pref.CompanyKey = v.CompanyKey
--and    tVoucherDetail.WIPPostingOutKey = 0
and    tVoucherDetail.WIPPostingInKey = 0
and    ISNULL(pref.TrackWIP, 0) = 1
and    tVoucherDetail.OldExpenseAccountKey in (pref.WIPExpenseAssetAccountKey, pref.WIPMediaAssetAccountKey)
*/					
				
					
	END	-- Company loop

	
	
	RETURN 1
GO
