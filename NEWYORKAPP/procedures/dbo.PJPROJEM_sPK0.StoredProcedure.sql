USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_sPK0]    Script Date: 12/21/2015 16:01:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_sPK0] @parm1 varchar (16), @parm2 varchar (10)  as
select * from pjprojem
where pjprojem.project  = @parm1 and
      pjprojem.employee = @parm2
GO
