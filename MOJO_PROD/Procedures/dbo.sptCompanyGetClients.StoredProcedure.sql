USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetClients]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetClients]

	@CompanyKey int
	
AS --Encrypt

/*
|| When     Who Rel  What
|| 10/09/07 GHL 8.5  Added FormattedID for flash DDs
|| 11/15/07 CRG 8.5  Flipped ID and Name for new DD standard 
*/
	select	CompanyName + '-' + CustomerID AS FormattedID
			,* 
	from tCompany (nolock)
	where OwnerCompanyKey = @CompanyKey
	and CustomerID is not null
	order by CustomerID
	
	return 1
GO
