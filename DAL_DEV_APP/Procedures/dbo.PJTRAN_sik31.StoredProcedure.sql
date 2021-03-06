USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_sik31]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_sik31] @parm1 varchar (6) , @parm2 varchar (16) , @parm3 varchar (16) , @parm4 varchar (16) , @parm5 varchar (16)   as
select * from PJTRAN
where
fiscalno = @parm1 and
project  = @parm2  and
(acct     = @parm3 or
acct     = @parm4 or
acct     = @parm5) and
tr_status = ' '
order by  FISCALNO,
PROJECT,
PJT_ENTITY,
ACCT,
TRANS_DATE
GO
