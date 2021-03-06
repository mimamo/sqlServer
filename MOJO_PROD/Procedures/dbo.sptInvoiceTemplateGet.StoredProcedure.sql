USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTemplateGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTemplateGet]
	@InvoiceTemplateKey int

AS --Encrypt

/*  Who When        Rel     What
||  GHL 11/14/2007  8.440   (15928) Added Phone/Fax 
*/ 
		SELECT it.*,
			a.Address1 as TAddress1,
			a.Address2 as TAddress2,
			a.Address3 as TAddress3,
			a.City as TCity,
			a.State as TState,
			a.PostalCode as TPostalCode,
			a.Country as TCountry,
			c.Phone,
			c.Fax
		FROM tInvoiceTemplate it (nolock)
		left outer join tAddress a (nolock) on it.AddressKey = a.AddressKey
		inner join tCompany c (nolock) on it.CompanyKey = c.CompanyKey
		WHERE
			it.InvoiceTemplateKey = @InvoiceTemplateKey

	RETURN 1


	RETURN 1
GO
