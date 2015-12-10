USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAddressDelete]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAddressDelete]
	@AddressKey int

AS -- Encrypt

/*
|| When     Who Rel     What
|| 12/09/09 MAS	10.6.0	Added tOffice Update
|| 09/18/12 QMD	10.5.6	Fixed home address and other address
*/
	
	UPDATE	tUser
	SET		AddressKey = NULL
	WHERE	AddressKey = @AddressKey
	
	UPDATE	tUser
	SET		HomeAddressKey = NULL
	WHERE	HomeAddressKey = @AddressKey
	
	UPDATE	tUser
	SET		OtherAddressKey = NULL
	WHERE	OtherAddressKey = @AddressKey
	
	UPDATE	tCompany
	SET		DefaultAddressKey = NULL
	WHERE	DefaultAddressKey = @AddressKey
	
	UPDATE	tCompany
	SET		BillingAddressKey = NULL
	WHERE	BillingAddressKey = @AddressKey

	UPDATE	tCompany
	SET		PaymentAddressKey = NULL
	WHERE	PaymentAddressKey = @AddressKey
	
	UPDATE	tInvoice
	SET		AddressKey = NULL
	WHERE	AddressKey = @AddressKey

	UPDATE	tInvoiceTemplate
	SET		AddressKey = NULL
	WHERE	AddressKey = @AddressKey

	UPDATE	tEstimate
	SET		AddressKey = NULL
	WHERE	AddressKey = @AddressKey

	UPDATE	tEstimateTemplate
	SET		AddressKey = NULL
	WHERE	AddressKey = @AddressKey

	UPDATE	tBilling
	SET		AddressKey = NULL
	WHERE	AddressKey = @AddressKey
	
	UPDATE	tPayment
	SET		AddressKey = NULL
	WHERE	AddressKey = @AddressKey
	
	UPDATE	tOffice
	SET		AddressKey = NULL
	WHERE	AddressKey = @AddressKey
		
	DELETE
	FROM tAddress
	WHERE
		AddressKey = @AddressKey 



	RETURN 1
GO
