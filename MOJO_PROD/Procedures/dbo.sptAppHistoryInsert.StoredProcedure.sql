USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppHistoryInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppHistoryInsert]
	@CompanyKey int,
	@UserKey int,
	@Section varchar(50),
	@ActionID varchar(300),
	@ActionKey int,
	@Label varchar(500),
	@Description varchar(500),
	@Icon varchar(50)

AS

/*
|| When     Who Rel      What
|| 12/16/10	MAS 10.5.8.7 Added Description and Icon

*/

Delete tAppHistory Where CompanyKey = @CompanyKey and UserKey = @UserKey and ActionID = @ActionID and ActionKey = @ActionKey


INSERT INTO tAppHistory
           (CompanyKey
           ,UserKey
           ,Section
           ,ActionID
           ,ActionKey
           ,Label
           ,Description
           ,Icon)
     VALUES
		   (@CompanyKey
           ,@UserKey
           ,@Section
           ,@ActionID
           ,@ActionKey
           ,@Label
           ,@Description
           ,@Icon)
GO
