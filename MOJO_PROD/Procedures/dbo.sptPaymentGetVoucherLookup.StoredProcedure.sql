USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentGetVoucherLookup]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentGetVoucherLookup]

	(
		@VendorKey int
	)

AS --Encrypt

Select * 
From vVoucher (nolock)
Where
	VendorKey = @VendorKey and
	OpenAmount > 0 and
	Status = 4
	
Order by DueDate
GO
