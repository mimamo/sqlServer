USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetPostingList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherGetPostingList]

	(
		@CompanyKey int
	)

AS --Encrypt

SELECT * from vVoucherDetail (NOLOCK)
WHERE 
	Status = 4 AND 
	Posted = 0 and
	CompanyKey = @CompanyKey
ORDER BY 
	VendorID, InvoiceNumber, LineNumber
GO
