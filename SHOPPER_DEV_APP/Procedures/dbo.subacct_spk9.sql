USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[subacct_spk9]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[subacct_spk9] @parm1 varchar (250) , @parm2 varchar (24)  as
select * from  subacct
where sub = @parm2
order by sub
GO
