USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[inventory_spk9]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[inventory_spk9] @parm1 varchar (250) , @parm2 varchar (30)  as
select * from  inventory
where invtid = @parm2
order by invtid
GO
