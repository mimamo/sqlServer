USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_DPK0]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_DPK0]  @parm1 varchar (16) as
    delete from PJPENTEM
        where Project = @parm1
GO
