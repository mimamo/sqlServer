USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[inventory_spk9]    Script Date: 12/21/2015 13:57:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[inventory_spk9] @parm1 varchar (250) , @parm2 varchar (30)  as
select * from  inventory
where invtid = @parm2
order by invtid
GO
