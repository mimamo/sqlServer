USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetApprovalCount]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherGetApprovalCount]

	(
		@UserKey int
	)

AS --Encrypt

DECLARE @VoucherCount int

SELECT 
	@VoucherCount = Count(*)
FROM 
	tVoucher (NOLOCK)
WHERE 
	tVoucher.Status = 2 AND 
	tVoucher.ApprovedByKey = @UserKey

	Return @VoucherCount
GO
