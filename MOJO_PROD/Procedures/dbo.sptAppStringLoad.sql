USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppStringLoad]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAppStringLoad]
 
 
AS --Encrypt

  /*
  || When  Who Rel   What
  || 28/05/13 RJE 10.5.x.x Created for new WJApp
  */
  -- Get the round info object
  
-- Get all markup for this round/step
SELECT tams.*
FROM tAppModuleString tams (NOLOCK) 

-- Get the list of files for downloading
SELECT tas.*
FROM tAppString tas (NOLOCK)
GO
