USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_SPKTEST]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_SPKTEST] @parm1 varchar (2)   as
select distinct control_type from pjcontrl
where    control_type      LIKE @parm1
order by control_type
GO
