USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PJPROJ_Descr]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_PJPROJ_Descr]
	@project varchar(16)
AS
	select	project_Desc
	from	PJPROJ
	where	project = @project

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
