USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CS_Installed]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_CS_Installed]
AS
	select	case when count(*) > 0
		then 1
		else 0
		end
	from	CSSetup (nolock)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
