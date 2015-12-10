USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMailingSetupUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMailingSetupUpdate]
	(
	@CompanyKey INT,
	@EmailSystem VARCHAR(50),
	@SystemID VARCHAR(50),
	@UserID VARCHAR(50),
	@Password VARCHAR(200),
	@AddActivityForSentEmail TINYINT,
	@AddActivityForBB TINYINT,
	@AddActivityForClick TINYINT,
	@AddActivityForEachClick TINYINT,
	@AddActivityForOpens TINYINT,
	@BBDeactivate TINYINT,
	@BBRemoveFromLists TINYINT,
	@BBDelete TINYINT,
	@SyncUsers TINYINT,
	@AutoSync TINYINT,
	@LastSync DATETIME
	)
AS --Encrypt
select * from tMailingSetup
/*
|| When      Who Rel      What
|| 09/16/08  QMD 10.5.0.0 Initial Release
|| 02/03/09  QMD 10.5     Added Last_Modified, AutoSync
|| 10/22/09  MFT 10.5.1.2 Added SyncUsers
|| 03/01/10  QMD 10.5.1.9 Added AddActivityForOpens
|| 08/25/11  RLB 10.5.4.7 (93517) added Activity for each click
*/

	IF EXISTS (SELECT 1 FROM tMailingSetup (NOLOCK) WHERE CompanyKey = @CompanyKey)
	  BEGIN
		UPDATE	tMailingSetup
		SET		EmailSystem = @EmailSystem,
				SystemID = @SystemID,
				UserID = @UserID,
				[Password] = @Password,
				AddActivityForSentEmail = @AddActivityForSentEmail,
				AddActivityForBB = @AddActivityForBB,
				AddActivityForClick = @AddActivityForClick,
				AddActivityForEachClick = @AddActivityForEachClick,			
				AddActivityForOpens = @AddActivityForOpens,	
				BBDeactivate = @BBDeactivate,
				BBRemoveFromLists = @BBRemoveFromLists,
				BBDelete = @BBDelete,
				SyncUsers = @SyncUsers,
				AutoSync = @AutoSync,
				LastSync = @LastSync		
		WHERE	CompanyKey = @CompanyKey

		IF (@@ERROR > 0)
		   RETURN -1
		ELSE
		   RETURN 1
	  END
	ELSE
	  BEGIN

		INSERT tMailingSetup (CompanyKey, EmailSystem, SystemID, UserID, [Password], AddActivityForSentEmail, AddActivityForBB, AddActivityForClick,AddActivityForEachClick, AddActivityForOpens, BBDeactivate, BBRemoveFromLists, BBDelete, SyncUsers, LastSync, AutoSync)
		VALUES (@CompanyKey, @EmailSystem, @SystemID, @UserID, @Password, @AddActivityForSentEmail, @AddActivityForBB, @AddActivityForClick, @AddActivityForEachClick, @AddActivityForOpens, @BBDeactivate, @BBRemoveFromLists, @BBDelete, @SyncUsers, @LastSync, @AutoSync)

		IF (@@ERROR > 0)
		   RETURN -2
        ELSE
		   RETURN 2

	  END
GO
