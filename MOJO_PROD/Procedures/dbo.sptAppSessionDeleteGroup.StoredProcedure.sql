USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppSessionDeleteGroup]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAppSessionDeleteGroup]
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@GroupID varchar(50)
AS

-- Deletes all user settings for the Entity passed in for all the users
IF @Entity = 'user' AND @EntityKey = 0
	BEGIN
		DELETE ap
		FROM tAppSession ap
		JOIN tUser u ON u.UserKey = ap.EntityKey AND ap.Entity = 'user'
		WHERE ap.GroupID = @GroupID AND u.CompanyKey = @CompanyKey
	END

IF @Entity = 'securitygroup'
	BEGIN	
		Delete tAppSession Where Entity = @Entity and EntityKey = @EntityKey and GroupID = @GroupID
	END
GO
