USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJACTSUM_SPK0]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACTSUM_SPK0] @parm1 varchar (4) , @parm2 varchar (16) , @parm3 varchar (32) , @parm4 varchar (16)  as
select * from PJACTSUM
where    fsyear_num = @parm1
and    project    = @parm2
and    pjt_entity = @parm3
and    acct       = @parm4
order by fsyear_num,
project,
pjt_entity,
acct
GO
