USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[batch_spk0]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[batch_spk0] @parm1 varchar (10) , @parm2 varchar (2)  as
select * from batch
where batnbr = @parm1 and
module = @parm2
order by module, batnbr
GO
