USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJRATE_SALL]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRATE_SALL]  @parm1 varchar (4) , @parm2 varchar (2) , @parm3 varchar (1)   as
       select * from PJRATE
       where    rate_table_id  LIKE @parm1
       and      rate_type_cd   LIKE @parm2
       and      rate_level     like @parm3
       order by
              rate_table_id,
              rate_type_cd,
              rate_level,
              rate_key_value1,
              rate_key_value2,
              effect_date
GO
