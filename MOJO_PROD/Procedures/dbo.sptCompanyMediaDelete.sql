USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaDelete]
	@CompanyMediaKey int

AS

/*
|| When      Who Rel     What
|| 06/11/13  MFT 10.569  Added tCompanyMedia... Space, Position and Vendors
|| 06/13/16  MFT 10.569  Added tCompanyMedia... Contract and ContractDetail
*/

IF EXISTS(SELECT 1 FROM tPurchaseOrder (nolock) WHERE CompanyMediaKey = @CompanyMediaKey)
	RETURN -1
	
	DELETE
	FROM tCompanyMediaContact
	WHERE CompanyMediaKey = @CompanyMediaKey
	
	DELETE
	FROM tCompanyMediaSpace
	WHERE CompanyMediaKey = @CompanyMediaKey
	
	DELETE
	FROM tCompanyMediaPosition
	WHERE CompanyMediaKey = @CompanyMediaKey
	
	DELETE
	FROM tCompanyMediaVendor
	WHERE CompanyMediaKey = @CompanyMediaKey
	
	DELETE
	FROM tCompanyMediaContractDetail
	WHERE CompanyMediaContractKey IN (
		SELECT CompanyMediaContractKey
		FROM tCompanyMediaContract
		WHERE CompanyMediaKey = @CompanyMediaKey
	)
	
	DELETE
	FROM tCompanyMediaContract
	WHERE CompanyMediaKey = @CompanyMediaKey
	
	DELETE
	FROM tCompanyMedia
	WHERE CompanyMediaKey = @CompanyMediaKey
	
	RETURN 1
GO
