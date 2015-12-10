USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeUserInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeUserInsert]
	(
		@ProjectTypeKey int,
		@UserKey int
	)
AS --Encrypt

INSERT tProjectTypeUser
	(
		ProjectTypeKey,
		UserKey
	)
VALUES
	(
		@ProjectTypeKey,
		@UserKey
	)

RETURN 1
GO
