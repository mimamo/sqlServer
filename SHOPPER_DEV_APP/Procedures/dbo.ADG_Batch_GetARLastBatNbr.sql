USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_GetARLastBatNbr]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_GetARLastBatNbr]
as
	select		LastBatNbr
	from		ARSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
