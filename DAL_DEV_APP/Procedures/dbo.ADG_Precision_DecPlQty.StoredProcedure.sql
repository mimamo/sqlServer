USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Precision_DecPlQty]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Precision_DecPlQty]
as
	select	DecPlQty
	from	INSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
