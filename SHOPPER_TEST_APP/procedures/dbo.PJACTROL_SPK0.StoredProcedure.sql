USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJACTROL_SPK0]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACTROL_SPK0] @parm1 varchar (4) , @parm2 varchar (16) , @parm3 varchar (16)  as
select * from PJACTROL
where    fsyear_num = @parm1
and    project    = @parm2
and    acct       = @parm3
order by fsyear_num,
project,
acct
GO
