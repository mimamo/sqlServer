USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_sall]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_sall] @parm1 varchar (16), @parm2 varchar (10)  as
select * from pjprojem
where pjprojem.project  = @parm1 and
      pjprojem.employee like @parm2
GO
