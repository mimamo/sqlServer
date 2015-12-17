USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRESHDR_spk0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRESHDR_spk0] @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (16)   as
select * from PJRESHDR
where project    like @parm1 and
pjt_entity like @parm2 and
acct       like @parm3
order by project, pjt_entity, acct
GO
