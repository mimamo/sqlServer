USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceUpdateServer]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserPreferenceUpdateServer]
(
	@UserKey INT,
	@Server VARCHAR(750)
)

As --Encrypt

  /*
  || When     Who Rel       What
  || 01/16/13 QMD 10.5.6.4  Created for exchange online
  */

	UPDATE tUserPreference
	SET	 ExchangeOnlineServer = @Server
	WHERE UserKey = @UserKey
GO
