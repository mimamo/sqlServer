USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContractDelete]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContractDelete]
	@CompanyMediaContractKey int
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 06/17/13 MFT 10.569  Created
*/

DELETE
FROM tCompanyMediaContractClient
WHERE CompanyMediaContractKey = @CompanyMediaContractKey

DELETE
FROM tCompanyMediaContractDetail
WHERE CompanyMediaContractKey = @CompanyMediaContractKey

DELETE
FROM tCompanyMediaContract
WHERE CompanyMediaContractKey = @CompanyMediaContractKey
GO
