USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_DPK0]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_DPK0]  @parm1 varchar (16) as
delete from PJPROJEM
where Project = @parm1
GO
