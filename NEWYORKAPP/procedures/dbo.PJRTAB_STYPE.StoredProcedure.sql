USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJRTAB_STYPE]    Script Date: 12/21/2015 16:01:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRTAB_STYPE]  @parm1 varchar (4) , @parm2 varchar (2)   as
       select * from PJRTAB, PJCODE
       where    rate_table_id  =    @parm1
       and      rate_type_cd   like @parm2
       and      code_type      =    'RATE'
       and      code_value     =    rate_type_cd
       order by
              rate_table_id, rate_type_cd
GO
