USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_sall]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_sall] @parm1 varchar (16), @parm2 varchar (10)  as
select * from pjprojem
where pjprojem.project  = @parm1 and
      pjprojem.employee like @parm2
GO
