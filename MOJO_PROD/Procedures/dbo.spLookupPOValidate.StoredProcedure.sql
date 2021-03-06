USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupPOValidate]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spLookupPOValidate]

	@CompanyKey int,			    -- CompanyKey
	@VendorKey int,
	@ID varchar(50)		-- ClientID
	
AS --Encrypt

	DECLARE @LookupKey int
	       ,@Status INT
				 ,@Closed INT
				 	
	SELECT	@LookupKey = PurchaseOrderKey 
				 ,@Status = Status
	FROM		tPurchaseOrder (NOLOCK) 
	WHERE		CompanyKey = @CompanyKey
	AND     VendorKey  = @VendorKey
	AND			UPPER(PurchaseOrderNumber) = UPPER(@ID)

	
	IF @LookupKey IS NOT NULL
		IF @Status <> 3	-- Approved
			RETURN - 2		-- Not Approved
		ELSE	
			IF @Closed = 1
				RETURN -3		-- Closed
			ELSE	
				RETURN @LookupKey
	ELSE
		RETURN -1				-- Not found
GO
