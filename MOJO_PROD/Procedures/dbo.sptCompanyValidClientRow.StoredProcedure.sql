USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyValidClientRow]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyValidClientRow]
	@CompanyKey int,
	@CustomerID varchar(50),
	@ActiveOnly tinyint
AS

 /*
 || When    Who Rel      What
 || 3/6/10  CRG 10.5.1.9 Created for the ItemRateManager client validation
 */
  
	SELECT	*
	FROM	tCompany  (nolock)
	WHERE	OwnerCompanyKey = @CompanyKey
	AND		UPPER(CustomerID) = UPPER(@CustomerID)
	AND		BillableClient = 1
	AND		Active >= @ActiveOnly
GO
