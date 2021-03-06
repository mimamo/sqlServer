USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sCount]    Script Date: 12/21/2015 14:34:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJLABDIS_sCount]  @parm1 varchar (6)   as
select count(E1.employee)
from (Select employee
        from pjlabdis
        where fiscalno = @parm1
  union
        Select employee
        from pjexphdr
        where fiscalno = @parm1 and status_1 = 'P') as E1
GO
