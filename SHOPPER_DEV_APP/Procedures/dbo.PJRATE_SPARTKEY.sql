USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRATE_SPARTKEY]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRATE_SPARTKEY]  @parm1 varchar (4) , @parm2 varchar (2) , @parm3 varchar (1)  as
       select * from PJRATE
       where rate_table_id   =  @parm1
       and   rate_type_cd    =  @parm2
       and   rate_level      =  @parm3
       order by
              rate_table_id,
              rate_type_cd,
              rate_level,
              rate_key_value1,
              rate_key_value2,
              effect_date
GO
