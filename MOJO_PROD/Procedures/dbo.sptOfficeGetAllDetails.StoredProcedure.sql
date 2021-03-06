USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeGetAllDetails]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeGetAllDetails]
	@CompanyKey int

AS --Encrypt

/*
|| When     Who Rel			What
|| 10/06/09 MAS 10.5.1.1	Created
*/

-- Offices 
SELECT *
FROM tOffice (nolock)
WHERE CompanyKey = @CompanyKey

--  Addresses
SELECT tAddress.*
FROM tAddress (nolock)
WHERE CompanyKey = @CompanyKey
GO
