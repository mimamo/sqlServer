USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetApprovalList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherGetApprovalList]

	(
		@CompanyKey int,
		@UserKey int
	)

AS --Encrypt

if @UserKey is null
	SELECT * from vVoucher (NOLOCK)
	WHERE 
		Status = 4 AND 
		Posted = 0 AND
		CompanyKey = @CompanyKey
	ORDER BY 
		VendorID, InvoiceNumber
else
	SELECT * from vVoucher (NOLOCK)
	WHERE 
		Status = 2 AND 
		ApprovedByKey = @UserKey
	ORDER BY 
		VendorID, InvoiceNumber
GO
