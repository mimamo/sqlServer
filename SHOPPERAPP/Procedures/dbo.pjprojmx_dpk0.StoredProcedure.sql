USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjprojmx_dpk0]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjprojmx_dpk0]  @parm1 varchar (16) as
delete from PJPROJMX
where Project = @parm1
GO
