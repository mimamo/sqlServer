USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_spk0]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_spk0] @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (16) , @parm4 varchar (6)    as
select * from PJTRAN
where project =  @parm1 and
pjt_entity  =  @parm2 and
acct = @parm3 and
fiscalno like @parm4
order by post_date, trans_date
GO
