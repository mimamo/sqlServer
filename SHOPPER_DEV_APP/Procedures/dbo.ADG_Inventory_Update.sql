USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inventory_Update]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Inventory_Update]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@ShipperID	varchar(15)

as
	declare @temp varchar(10)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
