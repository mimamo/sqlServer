USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Max_CustID]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_Max_CustID]
as
	select	max(CustID)
	from	Customer

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
