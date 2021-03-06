USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadGetByEmail]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptUserLeadGetByEmail]
	 @Email varchar(100),
	 @CompanyKey int
AS 

/*
|| When			Who Rel			What
|| 05/04/2009	MFT	10.5		Added @CompanyKey parameter
*/
select * 
from tUserLead (nolock)
where
	upper(Email) = upper(@Email) AND
	CompanyKey = @CompanyKey

return 1
GO
