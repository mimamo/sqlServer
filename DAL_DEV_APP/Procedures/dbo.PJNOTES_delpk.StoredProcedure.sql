USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJNOTES_delpk]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJNOTES_delpk] @parm1 varchar (4) , @parm2 varchar (64)   as
delete from PJNOTES
where note_type_cd =  @parm1 and
key_value = @parm2
GO
