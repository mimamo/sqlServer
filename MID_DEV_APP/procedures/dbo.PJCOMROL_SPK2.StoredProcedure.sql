USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMROL_SPK2]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMROL_SPK2] @parm1 varchar (4)  as
select * from PJCOMROL
where    fsyear_num = @parm1
order by fsyear_num,
project,
acct
GO
