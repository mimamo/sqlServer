USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_InventoryQtys_QAvlParm]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_InventoryQtys_QAvlParm]
as
	select	InclAllocQty,
		InclQtyCustOrd,
		InclQtyOnBO,
		InclQtyOnPO
	from	INSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
