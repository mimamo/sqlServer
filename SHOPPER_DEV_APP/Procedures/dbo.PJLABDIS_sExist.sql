USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sExist]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJLABDIS_sExist]  @parm1 varchar (6),  @parm2 varchar (10)  as
select count(E1.employee)
from (Select employee
        from pjlabdis
        where fiscalno = @parm1
  union
        Select employee
        from pjexphdr
        where fiscalno = @parm1  and status_1 = 'P') as E1
where employee = @parm2
GO
