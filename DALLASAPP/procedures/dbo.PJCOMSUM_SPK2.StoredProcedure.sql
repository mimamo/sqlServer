USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMSUM_SPK2]    Script Date: 12/21/2015 13:44:59 ******/
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
