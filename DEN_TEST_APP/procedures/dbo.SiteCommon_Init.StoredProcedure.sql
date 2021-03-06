USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SiteCommon_Init]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SiteCommon_Init] as
SELECT
         GLInstalled=(SELECT count(*) FROM GLSetup WITH(NOLOCK)),	 
         BMInstalled=(SELECT count(*) FROM BMSetup WITH(NOLOCK)), 
         WOInstalled=(SELECT count(*) FROM WOSetup WITH(NOLOCK) WHERE Init = 'Y'),	 
	 PWOInstalled=(SELECT count(*) FROM WOSetup WITH(NOLOCK) WHERE Init = 'Y' AND substring(regoptions, 4, 1) = 'Y' )
GO
