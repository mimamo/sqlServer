USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Max_CustID]    Script Date: 12/16/2015 15:55:17 ******/
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
