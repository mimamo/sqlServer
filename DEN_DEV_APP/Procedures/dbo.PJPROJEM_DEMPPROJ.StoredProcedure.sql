USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_DEMPPROJ]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_DEMPPROJ]  @parm1 varchar (10), @parm2 varchar (16) as
delete from PJPROJEM
where Employee = @parm1 and
Project = @parm2
GO
