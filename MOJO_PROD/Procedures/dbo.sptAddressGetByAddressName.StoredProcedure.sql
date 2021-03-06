USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAddressGetByAddressName]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptAddressGetByAddressName]
	@CompanyKey Int,
	@AddressName varchar(200)

AS --Encrypt

/*
  || When     Who Rel		What
  || 04/28/09 MAS 10.5		Created
*/
	SELECT *
	FROM tAddress (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(AddressName))) = ltrim(rtrim(upper(@AddressName)))

 RETURN 1
GO
