USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Precision_DecPlPrcCst]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Precision_DecPlPrcCst]
as
	select	DecPlPrcCst
	from	INSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
