USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILLCH_sappdesc]    Script Date: 12/21/2015 16:13:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBILLCH_sappdesc] @parm1 varchar (16)   as
select * from PJBILLCH
where project =  @parm1  and
status <> 'C' and status <> 'P'
order by project, appnbr desc
GO
