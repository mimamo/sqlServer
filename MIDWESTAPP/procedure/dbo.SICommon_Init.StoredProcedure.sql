USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SICommon_Init]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SICommon_Init] as
SELECT
	 INInstalled=(SELECT count(*) FROM INSetup WITH(NOLOCK) WHERE Init = 1),
	 WOInstalled=(SELECT count(*) FROM WOSetup WITH(NOLOCK) WHERE Init = 'Y'),
	 APInstalled=(SELECT count(*) FROM APSetup WITH(NOLOCK)),
	 GLInstalled=(SELECT count(*) FROM GLSetup WITH(NOLOCK)),
	 POInstalled=(SELECT count(*) FROM POSetup WITH(NOLOCK)),
         PWOInstalled=(SELECT count(*) FROM WOSetup WITH(NOLOCK) WHERE Init = 'Y' AND substring(regoptions, 4, 1) = 'Y' )
GO
