USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetbyCompanyName]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetbyCompanyName]
	@OwnerCompanyKey Int,
	@CompanyName Varchar(200),
	@PartialMatch tinyint = 0
As 

  /*
  || When     Who Rel      What
  || 04/28/09 MAS 10.5.0.0 Created
  || 05/30/09 MFT 10.5.0.0 Added partial match
  */

IF @PartialMatch = 1
	BEGIN
		DECLARE @Len int
		SET @Len = ROUND((LEN(@CompanyName) + .5)/2, 0)
		
		SELECT
			*
		FROM
			tCompany (nolock)
		WHERE
			OwnerCompanyKey = @OwnerCompanyKey AND
			CompanyName LIKE '%' + LEFT(@CompanyName, @Len) + '%'
	END
ELSE
	Select * 
	from tCompany (nolock) 
	Where  OwnerCompanyKey = @OwnerCompanyKey
	And ltrim(rtrim(upper(CompanyName))) = ltrim(rtrim(upper(@CompanyName)))

Return 1
GO
