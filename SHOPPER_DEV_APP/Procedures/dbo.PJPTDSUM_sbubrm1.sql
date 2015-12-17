USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_sbubrm1]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_sbubrm1] @parm1 varchar (16)   as
select * from PJPTDSUM P, PJACCT A
where p.project =  @parm1 and
a.acct = p.acct and
a.ID1_SW = 'Y'
order by p.project, p.pjt_entity, p.acct
GO
