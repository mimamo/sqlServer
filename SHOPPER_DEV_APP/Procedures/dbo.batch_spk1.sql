USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[batch_spk1]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[batch_spk1] @parm1 varchar (2) , @parm2 varchar (10)  as
select * from batch
where module = @parm1 and
batnbr = @parm2
order by module, batnbr
GO
