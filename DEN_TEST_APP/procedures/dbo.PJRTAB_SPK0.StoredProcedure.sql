USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRTAB_SPK0]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRTAB_SPK0]  @parm1 varchar (4) , @parm2 varchar (2)   as
       select * from PJRTAB
       where    rate_table_id    =    @parm1
       and      rate_type_cd     =    @parm2
       order by rate_table_id, rate_type_cd
GO
