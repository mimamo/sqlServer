USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeUserGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeUserGet]
	@ProjectTypeKey int
AS

/*
|| When     Who Rel    What
|| 11/02/12 MFT 10.561 Created
*/

SELECT
	UserKey
FROM
	tProjectTypeUser
WHERE
	ProjectTypeKey = @ProjectTypeKey
GO
