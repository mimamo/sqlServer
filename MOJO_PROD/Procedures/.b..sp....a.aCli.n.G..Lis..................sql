USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataClientGetList]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataClientGetList]
	(
		@CompanyKey int
	)
as --Encrypt


Select
	c.CompanyKey,
	c.CustomerID,
	c.CompanyName,
	ISNULL(c.LinkID, '0') as LinkID,
	addr.Address1,
	addr.Address2,
	addr.Address3,
	addr.City,
	addr.State,
	addr.PostalCode,
	case When baddr.AddressKey is null then addr.Address1 else baddr.Address1 end as BAddress1,
	case When baddr.AddressKey is null then addr.Address2 else baddr.Address2 end as BAddress2,
	case When baddr.AddressKey is null then addr.Address3 else baddr.Address3 end as BAddress3,
	case When baddr.AddressKey is null then addr.City else baddr.City end as BCity,
	case When baddr.AddressKey is null then addr.State else baddr.State end as BState,
	case When baddr.AddressKey is null then addr.PostalCode else baddr.PostalCode end as BPostalCode
From
	tCompany c (nolock)
	Left Outer Join tAddress addr (NOLOCK) on c.DefaultAddressKey = addr.AddressKey
	Left Outer Join tAddress baddr (NOLOCK) on c.BillingAddressKey = baddr.AddressKey	
Where
	c.OwnerCompanyKey = @CompanyKey and
	c.BillableClient = 1
GO
