USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_sALL]    Script Date: 12/21/2015 15:43:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_sALL] @parm1 varchar (16)  as
select * from PJBILL
where project like @parm1
order by project
GO
