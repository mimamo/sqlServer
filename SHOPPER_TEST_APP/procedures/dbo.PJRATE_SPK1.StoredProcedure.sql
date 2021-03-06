USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRATE_SPK1]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRATE_SPK1]  @parm1 varchar (4) , @parm2 varchar (2) , @parm3 varchar (1)   as
       select  rate_table_id, rate_type_cd, count(*)
       from    PJRATE
       where   rate_table_id   =  @parm1
       and     rate_type_cd    =  @parm2
       and     rate_level      =  @parm3
       Group by rate_table_id, rate_type_cd
GO
