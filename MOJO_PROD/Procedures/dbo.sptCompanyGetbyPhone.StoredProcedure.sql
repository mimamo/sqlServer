USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetbyPhone]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetbyPhone]
	@Phone Varchar(50),
	@OwnerCompanyKey int
AS

  /*
  || When     Who Rel      What
  || 04/28/09 MAS 10.5     Created
  || 09/22/09 MFT 10.5.1.1 Added @OwnerCompanyKey
  */

SELECT *
FROM tCompany (nolock)
WHERE
	REPLACE(REPLACE(REPLACE(REPLACE(@Phone,'(',''),')',''),'-',''),' ','') = REPLACE(REPLACE(REPLACE(REPLACE(Phone,'(',''),')',''),'-',''),' ','') AND
	OwnerCompanyKey = @OwnerCompanyKey

RETURN 1
GO
