USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentGetPostList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentGetPostList]

	(
		@CompanyKey int
	)

AS --Encrypt


Select * from vPaymentDetail (NOLOCK) 
Where
	Posted = 0 and
	not CheckNumber is null and
	CompanyKey = @CompanyKey
Order By 
	PaymentKey, InvoiceNumber
GO
