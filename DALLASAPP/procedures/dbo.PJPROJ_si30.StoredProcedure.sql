USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_si30]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_si30] @parm1 varchar (24)  as
select * from PJPROJ
where gl_subacct like @parm1
order by project
GO
