USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[inventory_spk0]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[inventory_spk0] @parm1 varchar (30)  as
select * from Inventory
where InvtId = @parm1
order by InvtId
GO
