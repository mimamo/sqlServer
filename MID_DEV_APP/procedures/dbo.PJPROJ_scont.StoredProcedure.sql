USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_scont]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_scont] @parm1 varchar (16)  as
select * from PJPROJ
where contract = @parm1
order by project
GO
