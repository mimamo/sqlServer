USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_DPK0]    Script Date: 12/21/2015 13:57:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_DPK0]  @parm1 varchar (16) as
delete from PJPROJEM
where Project = @parm1
GO
