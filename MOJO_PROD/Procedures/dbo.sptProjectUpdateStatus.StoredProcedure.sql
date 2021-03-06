USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateStatus]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateStatus]
 @ProjectKey int,
 @ProjectStatusKey int
AS --Encrypt

/*
|| When		Who	Rel     	What
|| 01/28/09	MFT	10.0.1.8	(45415) Added RETURN -1 to trap for missing ProjectStatusKey record
*/

Declare  @Active tinyint
	
	SELECT @Active = IsActive
	FROM tProjectStatus (NOLOCK) 
	WHERE ProjectStatusKey = @ProjectStatusKey
	
	IF @Active IS NULL RETURN -1 --ProjectStatusKey record does not exist
	
	UPDATE
	 tProject
	SET
	 ProjectStatusKey = @ProjectStatusKey,
	 Active = @Active
	WHERE
	 ProjectKey = @ProjectKey 
	RETURN 1
GO
