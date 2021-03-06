USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetRecurringList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetRecurringList]

	(
		@VoucherKey int
	)

AS


Declare @RecurringVoucherKey int

Select @RecurringVoucherKey = RecurringParentKey from tVoucher (NOLOCK) Where VoucherKey = @VoucherKey

If ISNULL(@RecurringVoucherKey, 0) = 0
	Select @RecurringVoucherKey = @VoucherKey
	
	
	
Select * from vVoucher (NOLOCK) Where RecurringParentKey = @RecurringVoucherKey and VoucherKey <> @RecurringVoucherKey  Order By InvoiceDate
GO
