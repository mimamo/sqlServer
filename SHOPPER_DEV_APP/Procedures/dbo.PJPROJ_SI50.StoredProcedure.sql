USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_SI50]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_SI50] @parm1 varchar (60)  as
select * from PJPROJ
where project_desc = @parm1
and mspinterface = 'Y'
order by project
GO
