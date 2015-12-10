USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAddressGet]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAddressGet]
	@AddressKey int

AS  -- Encrypt

	SELECT *
	FROM   tAddress (NOLOCK)
	WHERE  AddressKey = @AddressKey

	RETURN 1
GO
