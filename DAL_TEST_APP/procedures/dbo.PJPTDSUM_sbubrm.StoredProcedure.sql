USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_sbubrm]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_sbubrm] @parm1 varchar (16) , @parm2 varchar (32)     as
select * from PJPTDSUM P, PJACCT A
where p.project =  @parm1 and
p.pjt_entity = @parm2 and
a.acct = p.acct and
a.ID1_SW = 'Y'
order by p.project, p.pjt_entity, p.acct
GO
