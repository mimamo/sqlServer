USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Max_UserID]    Script Date: 12/21/2015 15:42:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_Max_UserID]

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	select	max(UserID)
	from	vs_UserRec

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
