USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContractrDetailDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContractrDetailDelete]
	@CompanyMediaContractDetailKey int
	
	AS --Encrypt
	
	/*
	|| When     Who Rel     What
	|| 06/21/13 MFT 10.569  Created
*/

DELETE
FROM tCompanyMediaContractDetail
WHERE CompanyMediaContractDetailKey = @CompanyMediaContractDetailKey
GO
