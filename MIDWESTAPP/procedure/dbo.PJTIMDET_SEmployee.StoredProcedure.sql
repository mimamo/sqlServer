USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_SEmployee]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMDET_SEmployee]  @parm1 varchar (10)   as
select DISTINCT(employee), sum(reg_hours), sum(ot1_hours), sum(ot2_hours), sum(tl_id18)
from   PJTIMDET
where docnbr = @parm1
and tl_status <> 'P'
group by  employee
GO
