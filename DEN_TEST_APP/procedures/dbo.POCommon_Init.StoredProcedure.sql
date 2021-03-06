USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POCommon_Init]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POCommon_Init] as
SELECT
         APInstalled=(SELECT count(*) FROM APSetup WITH(NOLOCK)),
         POInstalled=(SELECT count(*) FROM POSetup WITH(NOLOCK)),
         CMInstalled=(SELECT count(*) FROM CMSetup WITH(NOLOCK)),
         GLInstalled=(SELECT count(*) FROM GLSetup WITH(NOLOCK)),	 
         INInstalled=(SELECT count(*) FROM INSetup WITH(NOLOCK) WHERE Init = 1),
         OMInstalled=(SELECT count(*) FROM SOSetup WITH(NOLOCK)),
	 PCInstalled=(SELECT count(*) FROM PCSetup WITH(NOLOCK) WHERE S4Future3 = 'S')
GO
