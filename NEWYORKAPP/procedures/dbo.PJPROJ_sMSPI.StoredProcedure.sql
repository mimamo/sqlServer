USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sMSPI]    Script Date: 12/21/2015 16:01:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sMSPI] @parm1 varchar (16)  as
select * from PJPROJ
where project like @parm1
and MSPInterface = 'Y'
order by project
GO
