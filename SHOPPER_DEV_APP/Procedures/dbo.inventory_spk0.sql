USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[inventory_spk0]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[inventory_spk0] @parm1 varchar (30)  as
select * from Inventory
where InvtId = @parm1
order by InvtId
GO
