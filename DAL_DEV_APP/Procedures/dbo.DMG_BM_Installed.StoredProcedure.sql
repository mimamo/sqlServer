USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_BM_Installed]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_BM_Installed]
AS
	select	case when count(*) > 0
		then 1
		else 0
		end
	from	BMSetup (nolock)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
