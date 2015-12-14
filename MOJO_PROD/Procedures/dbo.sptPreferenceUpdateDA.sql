USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateDA]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateDA]
 @CompanyKey int,
 @TrackRevisions tinyint,
 @RevisionsToKeep int
 
AS --Encrypt
 UPDATE
  tPreference
 SET
  TrackRevisions = @TrackRevisions,
  RevisionsToKeep = @RevisionsToKeep
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO
