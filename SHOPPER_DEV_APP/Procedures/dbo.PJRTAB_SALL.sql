USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRTAB_SALL]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRTAB_SALL]  @parm1 varchar (4) , @parm2 varchar (2)   as
       select * from PJRTAB
       where    rate_table_id  LIKE @parm1
       and      rate_type_cd   LIKE @parm2
       order by
              rate_table_id, rate_type_cd
GO
