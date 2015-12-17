USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJACCT_spk2]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACCT_spk2] @parm1 varchar (16)  as
select * from PJACCT
where acct like @parm1 and
id2_sw = '1' and
(acct_status = 'A' or
acct_status = 'I')
order by sort_num, acct
GO
