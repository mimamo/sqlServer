USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_savailemp_ne]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_savailemp_ne] @parm1 varchar (16)  as
select * from PJPROJ
where project    like @parm1
and status_pa  IN   ('A','I','M')
and status_19 = '1' --Available All Employee is unchecked
order by project
GO
