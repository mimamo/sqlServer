USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjprojmx_dpk0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjprojmx_dpk0]  @parm1 varchar (16) as
delete from PJPROJMX
where Project = @parm1
GO
