USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRESTIM_SRESSUM]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRESTIM_SRESSUM] @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (16) , @parm4 smallint   as
select * from PJRESTIM
where    project       =     @parm1 and
pjt_entity    =     @parm2 and
acct          =     @parm3 and
lineid        =     @parm4
order by project,
pjt_entity,
acct,
lineid DESC,
fiscalno
GO
