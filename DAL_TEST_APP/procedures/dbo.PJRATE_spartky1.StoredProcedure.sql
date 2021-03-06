USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRATE_spartky1]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRATE_spartky1]  @parm1 varchar (4) , @parm2 varchar (2) , @parm3 varchar (1), @parm4 varchar (32)  as
       select * from PJRATE
       where rate_table_id   =  @parm1
       and   rate_type_cd    =  @parm2
       and   rate_level      =  @parm3
	 and   rate_key_value1 =  @parm4
       order by
              rate_table_id,
              rate_type_cd,
              rate_level,
              rate_key_value1,
              rate_key_value2,
              effect_date
GO
