USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJACCT_spk9]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACCT_spk9] @parm1 varchar (250) , @parm2 varchar (16)  as
select * from PJACCT
where acct = @parm2
order by acct
GO
