USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SS_Installed]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SS_Installed]
AS
	select	case when count(*) > 0
		then 1
		else 0
		end
	from	smProServSetup (nolock)
GO
