USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRESSUM_spk1]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRESSUM_spk1] @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (16)   as
select * from PJRESSUM
where    project        =       @parm1 and
pjt_entity     =       @parm2 and
acct           =       @parm3
order by project,
pjt_entity,
acct,
lineID DESC
GO
