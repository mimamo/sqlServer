USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMSUM_SPK2]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMSUM_SPK2] @parm1 varchar (4)  as
select * from PJCOMSUM
where    fsyear_num = @parm1
order by fsyear_num,
project,
pjt_entity,
acct
GO
