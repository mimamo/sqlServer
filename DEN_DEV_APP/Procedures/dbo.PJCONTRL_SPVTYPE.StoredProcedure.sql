USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_SPVTYPE]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_SPVTYPE] @parm1 varchar (2)   as
select   distinct control_type from pjcontrl
where    control_type      LIKE @parm1
order by control_type
GO
