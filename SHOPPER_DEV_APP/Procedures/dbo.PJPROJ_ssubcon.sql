USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_ssubcon]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_ssubcon] @parm1 varchar (16)  as
select distinct PJPROJ.* from PJPROJ, PJSUBCON
where PJPROJ.project like @parm1 and
PJPROJ.project = PJSUBCON.project
order by PJPROJ.project
GO
