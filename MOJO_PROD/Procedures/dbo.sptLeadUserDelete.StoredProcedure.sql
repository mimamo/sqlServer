USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadUserDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadUserDelete]
	@LeadUserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 03/12/15 MAS 10.5.8.9	Created for platinum
  */
  
	DELETE
	FROM tLeadUser
	WHERE
		LeadUserKey = @LeadUserKey
		
	RETURN 1
GO
